# -*- mode: ruby -*-
# vi: set ft=ruby :

# Inspired from
# http://vstone.eu/my-improved-vagrantfile/
# https://github.com/elasticdog/puppet-sandbox/blob/master/Vagrantfile
# https://github.com/Mayflower/puppet-dev-env/blob/master/Vagrantfile
# https://github.com/Varying-Vagrant-Vagrants/VVV

require 'yaml'

# The following function is taken from:
# It makes sure that we can symbolize recursively the keys
# http://devblog.avdi.org/2009/07/14/recursively-symbolize-keys/
def symbolize_keys(hash)
  hash.inject({}){|result, (key, value)|
    new_key = case key
              when String then key.to_sym
              else key
              end
    new_value = case value
                when Hash then symbolize_keys(value)
                else value
                end
    result[new_key] = new_value
    result
  }
end

# Get the current directory
dir = Dir.pwd
vagrant_dir = File.expand_path(File.dirname(__FILE__))

# Read the settings from the settings file if it exists
# The idea is from:
# http://stackoverflow.com/questions/3903376/how-do-i-save-settings-as-a-hash-in-a-external-file
if File.exists?(File.join(vagrant_dir, 'settings.yml'))
  settings = YAML::load_file 'settings.yml'
  settings = symbolize_keys(settings)

  # Create the settings file to be used by Salt
  source_lines = IO.readlines('settings.yml')
  start_line = source_lines.index{ |line| line =~ /# SETTINGS FOR SALT - DO NOT DELETE THIS LINE/ } + 1
  salt_pillar_settings = source_lines[ start_line..-1 ].join( "" )

  # Set pillar settings file
  File.open(File.join(vagrant_dir, 'shared/salt/pillar/settings.sls'), 'w+' ) do |f|
    f << salt_pillar_settings
  end
else
  # Set default fallback settings settings
  abort "settings.yml file is missing. Please make sure it exists with the correct syntax"
end


# Create the settings file to be used by Salt
Vagrant.configure('2') do |config|
  # Store the current version of Vagrant for use in conditionals when dealing
  # with possible backward compatible issues.
  # vagrant_version = Vagrant::VERSION.sub(/^v/, '')

  config.vm.define settings[:vm_name] do |vm_config|
    # Build the box from an image
    vm_config.vm.box = settings[:box_name]

    # If the box does not exist locally it will be fetched from a given URL
    vm_config.vm.box_url = settings[:box_url]

    # Make this VM reachable on the host network as well, so that other
    # VM's running other browsers can access our dev server
    vm_config.vm.network :private_network, ip: settings[:ip]

    # Set the hostname
    vm_config.vm.hostname = settings[:hostname]

    # Make it so that network access from the vagrant guest is able to
    # use SSH private keys that are present on the host without copying
    # them into the VM.
    vm_config.ssh.forward_agent = settings[:forward_agent]

    # Use the hostupdater plugin to set aliases on host machine
    if Vagrant.has_plugin?('vagrant-hostsupdater') and settings[:use_hostupdater]
      config.hostsupdater.aliases = settings[:hostupdater_aliases].split(',')
      config.hostsupdater.remove_on_suspend = settings[:hostupdater_remove_on_suspend]
    end

    # Use vagrant cashier plugin to maximize caching
    if Vagrant.has_plugin?('vagrant-cachier') and settings[:use_cashier]
      # Configure cached packages to be shared between instances of the same base box.
      # More info on the "Usage" link above
      config.cache.scope = :box

      # If you are using VirtualBox, you might want to use that to enable NFS for
      # shared folders. This is also very useful for vagrant-libvirt if you want
      # bi-directional sync
      config.cache.synced_folder_opts = {
        type: :nfs,
        # The nolock option can be useful for an NFSv3 client that wants to avoid the
        # NLM sideband protocol. Without this option, apt-get might hang if it tries
        # to lock files needed for /var/cache/* operations. All of this can be avoided
        # by using NFSv4 everywhere. Please note that the tcp option is not the default.
        mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
      }
    end

    # Modify the default setup of the VM
    # modifyvm options can be found at
    # http://www.virtualbox.org/manual/ch08.html#idp56719296
    # This apply only if using vituabox
    vm_config.vm.provider :virtualbox do |v|

      # Taken from http://www.stefanwrobel.com/how-to-make-vagrant-performance-not-suck
      host = RbConfig::CONFIG['host_os']

      # Give VM 1/4 system memory & access to all cpu cores on the host
      if host =~ /darwin/
        cpus = `sysctl -n hw.ncpu`.to_i
        # sysctl returns Bytes and we need to convert to MB
        mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
      elsif host =~ /linux/
        cpus = `nproc`.to_i
        # meminfo shows KB and we need to convert to MB
        mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
      else # sorry Windows folks, I can't help you
        cpus = 2
        mem = 1024
      end

      if settings[:cpus]
        cpus = cpus
      end

      if settings[:mem]
        mem = mem
      end

      # This setting gives the VM the amount of RAM specified in settings file instead of the default 384.
      v.customize ['modifyvm', :id, '--memory', mem]

      # This setting gives the VM the amount of CPUs specified in settings file.
      v.customize ['modifyvm', :id, '--cpus', cpus]

      # This setting allow network access from inside the vagrant guest
      # it can resolve DNS using the hosts VPN connection.
      v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']

      # This setting proxies guest DNS requests through the host machine
      v.customize ['modifyvm', :id, '--natdnsproxy1', 'on']

      # This option lets the real-time clock (RTC) operate in UTC time (see the section called “'Motherboard' tab”).
       v.customize ['modifyvm', :id, '--rtcuseutc', 'on']
    end

    # Setup ports forwarding
    if settings[:forwards]
      settings[:forwards].each do |f_name, forward|
        vm_config.vm.network :forwarded_port, guest: forward[:from], host: forward[:to]
      end
    end

    # Setup shared folders
    if settings[:share_folders]
      settings[:share_folders].each do |sf_name, sf|
        vm_config.vm.synced_folder sf[:host_path], sf[:guest_path], type: sf[:type] , create: sf[:create]
      end
    end

    # Provision box with core packages using Salt provisioner
    if settings[:use_salt_provisioner] == true
        # Set Salt Share
        vm_config.vm.provision :salt do |salt|
          # Locate the minion file
          salt.minion_config = 'shared/salt/minion'

          # Execute SaltStack  provisioning
          salt.run_highstate = true

          # Install the latest version of SaltStack
          salt.install_type = settings[:salt_update]
          salt.verbose = settings[:salt_verbose]
      end
    end

    # Setup box timezone
    if settings[:timezone_default_settings]
      vm_config.vm.provision :shell, :inline => "echo \"" + settings[:timezone_default_settings] + "\" | sudo tee /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata | export TZ=" + settings[:timezone_default_settings]
    end

    # # Setup locales
    if settings[:locales]
      settings[:locales].each do |locale_name, locale|
        vm_config.vm.provision :shell, :inline => 'sudo locale-gen ' + locale[:locale]
      end
    end

  end
end
