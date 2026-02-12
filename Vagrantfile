Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"

  # Private network = libvirt NAT
  config.vm.network "private_network",
    ip: "192.168.121.50"

  config.vm.provider :libvirt do |lv|
    lv.memory = 4096
    lv.cpus = 2
  end
end

