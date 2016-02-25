Vagrant.configure('2') do |config|
  config.vm.box = 'cloudfoundry/bosh-lite'

  config.vm.provision "shell", run: "always", inline: "route add  -net 10.11.0.0/16  gw 192.168.50.1"
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |v, override|
    override.vm.box_version = '9000.130.0' # ci:replace
    # To use a different IP address for the bosh-lite director, uncomment this line:
    # override.vm.network :private_network, ip: '192.168.59.4', id: :local
    # override.vm.network :private_network, ip: '192.168.50.4', id: :local, nic_type: 'virtio'
    # v.customize ['modifyvm', :id, '--nictype1', 'virtio']
    v.customize ["modifyvm", :id, "--paravirtprovider", "default"]
    # v.customize ["modifyvm", :id, "--pae", "off"]
    # v.customize ["storagectl", :id, "--name", "SATA Controller", "--hostiocache", "off"]
    v.customize ["storagectl", :id, "--name", "IDE Controller", "--hostiocache", "off"]

    # http://blog.glehmann.net/2015/01/20/Shrinking-VirtualBox-vdi-files/
    # v.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", "0", "--discard", "on", "--nonrotational", "on"]
  end

  config.vm.provider :aws do |v, override|
    override.vm.box_version = '9000.130.0' # ci:replace
    # To turn off public IP echoing, uncomment this line:
    # override.vm.provision :shell, id: "public_ip", run: "always", inline: "/bin/true"

    # To turn off CF port forwarding, uncomment this line:
    # override.vm.provision :shell, id: "port_forwarding", run: "always", inline: "/bin/true"

    # Following minimal config is for Vagrant 1.7 since it loads this file before downloading the box.
    # (Must not fail due to missing ENV variables because this file is loaded for all providers)
    v.access_key_id = ENV['BOSH_AWS_ACCESS_KEY_ID'] || ''
    v.secret_access_key = ENV['BOSH_AWS_SECRET_ACCESS_KEY'] || ''
    v.ami = ''
  end

  config.vm.provider :vmware_fusion do |v, override|
    override.vm.box = 'cloudfoundry/no-support-for-bosh-lite-on-fusion'
    #we no longer build current boxes for vmware_fusion
    #ensure that this fails. otherwise the user gets an old box
  end

  config.vm.provider :vmware_workstation do |v, override|
    override.vm.box = 'cloudfoundry/no-support-for-bosh-lite-on-workstation'
    #we no longer build current boxes for vmware_workstation
    #ensure that this fails. otherwise the user gets an old box
  end
end
