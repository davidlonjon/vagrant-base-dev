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

# Set default fallback settings
def set_default_fallback_settings()
  default_settings = Hash.new
  default_settings[:vm_name] = 'dev'
  default_settings[:box_name] = 'trusty-server-cloudimg-i386-vagrant-disk1'
  default_settings[:box_url] = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box'
  default_settings[:ip] = '10.10.10.100'
  default_settings[:forward_agent] = true
  default_settings[:forwards] = Hash.new
  default_settings[:forwards][:http] = Hash.new
  default_settings[:forwards][:http][:from] = 80
  default_settings[:forwards][:http][:to] = 80
  default_settings[:forwards][:nginx] = Hash.new
  default_settings[:forwards][:nginx][:from] = 8080
  default_settings[:forwards][:nginx][:to] = 8080
  default_settings[:forwards][:jekyll] = Hash.new
  default_settings[:forwards][:jekyll][:from] =4000
  default_settings[:forwards][:jekyll][:to] = 4000
  default_settings[:forwards][:expressjs] = Hash.new
  default_settings[:forwards][:expressjs][:from] =3000
  default_settings[:forwards][:expressjs][:to] = 3000
  default_settings[:forwards][:api] = Hash.new
  default_settings[:forwards][:api][:from] =9090
  default_settings[:forwards][:api][:to] = 9090
  default_settings[:forwards][:mysql] = Hash.new
  default_settings[:forwards][:mysql][:from] = 3306
  default_settings[:forwards][:mysql][:to] = 3306
  default_settings[:forwards][:xdebug] = Hash.new
  default_settings[:forwards][:xdebug][:from] = 9000
  default_settings[:forwards][:xdebug][:to] = 9000
  default_settings[:forwards][:livereload] = Hash.new
  default_settings[:forwards][:livereload][:from] = 35729
  default_settings[:forwards][:livereload][:to] = 35729
  default_settings[:forwards][:memcached] = Hash.new
  default_settings[:forwards][:memcached][:from] = 12111
  default_settings[:forwards][:memcached][:to] = 12111
  default_settings[:share_folders] = Hash.new
  default_settings[:share_folders][:shared] = Hash.new
  default_settings[:share_folders][:shared][:host_path] = 'shared/'
  default_settings[:share_folders][:shared][:guest_path] = '/srv/'
  default_settings[:share_folders][:shared][:create] = true
  default_settings[:share_folders][:shared][:type] = 'nfs'
  default_settings[:use_hostupdater] = false
  default_settings[:hostupdater_aliases] = 'www.local.dev,tools.local.dev,mysql.local.dev,phpmyadmin.local.dev'
  default_settings[:hostupdater_remove_on_suspend] = true
  default_settings[:use_cashier] = false
  default_settings[:use_salt_provisioner] = true
  default_settings[:salt_verbose] = true
  default_settings[:salt_update] = 'stable'
  default_settings[:timezone_default_settings] = 'Asia/Seoul'
  default_settings[:locales] = Hash.new
  default_settings[:locales][:en] = Hash.new
  default_settings[:locales][:en][:locale] = 'en_US.UTF-8'
  default_settings[:locales][:gb] = Hash.new
  default_settings[:locales][:gb][:locale] = 'en_GB.UTF-8'
  default_settings[:locales][:ko] = Hash.new
  default_settings[:locales][:ko][:locale] = 'ko_KR.UTF-8'

  return default_settings
end

# Set default fallback settings for the salt pillar settings file
def set_fallback_default_salt_pillar_settings(settings)
  salt_settings_file_content = "phpmyadmin:
  server_name: 'phpmyadmin." + settings[:hostname]+ "'
  server_admin: 'admin@" + settings[:hostname]+ "'
  allow_from: '" + settings[:ip][ 0..settings[:ip].rindex(/\./)] +  "0/24'
  logs_dir: '" + settings[:share_folders][:logs][:guest_path] + "/apache2/phpmyadmin'

mysql_server:
  root_username: 'root'
  root_password: 'root'
  bind_address: '127.0.0.1'
  version: '5.5'

php:
  php_upload_max_filesize: '200M'

memcached:
  memory: 128
  host: '127.0.0.1'
  port: " + settings[:forwards][:memcached][:from].to_s + "

apc:
  memory: 64

#Timezone settings for Webgrind
timezone: '" + settings[:timezone_default_settings] + "'"

  return salt_settings_file_content
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
else
  # Set default fallback settings settings
  settings = set_default_fallback_settings()
  salt_pillar_settings = set_fallback_default_salt_pillar_settings(settings)
end

# Set pillar settings file
File.open(File.join(vagrant_dir, 'shared/salt/pillar/settings.sls'), 'w+' ) do |f|
  f << salt_pillar_settings
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
