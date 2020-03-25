# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# General config
enable_dns = false
# Override to false when bringing up a cluster on AWS
enable_hostmanager = true
enable_jmx = false
num_zookeepers = 1
num_brokers = 3
num_workers = 0 # Generic workers that get the code, but don't start any services
ram_megabytes = 1280
base_box = "ubuntu/xenial64"

# local_config_file = File.join(File.dirname(__FILE__), "Vagrantfile.local")
# if File.exists?(local_config_file) then
#   eval(File.read(local_config_file), binding, "Vagrantfile.local")
# end

# TODO(ksweeney): RAM requirements are not empirical and can probably be significantly lowered.
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.hostmanager.enabled = enable_hostmanager
  config.hostmanager.manage_host = enable_dns
  config.hostmanager.include_offline = false

  ## Provider-specific global configs
  config.vm.provider :virtualbox do |vb,override|
    override.vm.box = base_box

    override.hostmanager.ignore_private_ip = false

    # Brokers started with the standard script currently set Xms and Xmx to 1G,
    # plus we need some extra head room.
    vb.customize ["modifyvm", :id, "--memory", ram_megabytes.to_s]

    if Vagrant.has_plugin?("vagrant-cachier")
      override.cache.scope = :box
    end
  end

  def name_node(node, name)
    node.vm.hostname = name
  end

  def assign_local_ip(node, ip_address)
    node.vm.provider :virtualbox do |vb,override|
      override.vm.network :private_network, ip: ip_address
    end
  end

  ## Cluster definition
  zookeepers = []
  (1..num_zookeepers).each { |i|
    name = "zk" + i.to_s
    zookeepers.push(name)
    config.vm.define name do |zookeeper|
      name_node(zookeeper, name)
      ip_address = "192.168.50." + (10 + i).to_s
      assign_local_ip(zookeeper, ip_address)
    end
  }

  kafka_brokers = []
  (1..num_brokers).each { |i|
    name = "broker" + i.to_s
    kafka_brokers.push(name)
    config.vm.define name do |broker|
      name_node(broker, name)
      ip_address = "192.168.50." + (50 + i).to_s
      assign_local_ip(broker, ip_address)
    end
  }

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.become = true
    ansible.groups = {
        "zookeeper" => zookeepers,
        "kafka_broker" => kafka_brokers
    }
    ansible.playbook = "all.yml"
  end

end
