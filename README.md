# OpenStack-FUEL-9.0-9.2-OFFLINE-INSTALLATION-AUTOMATIC
Self designed script(including resource) to deploy fuel+mos(9.0 and 9.2) in offline environment

### Environment
1.Install MirantisOpenStack-9.0.iso according to the installation guide by mirantis. <br/>
2.Make sure the fuel-master node can not access the internet.

You can find the ISO download here: https://www.mirantis.com/software/openstack/download/<br/>
You can find the doc of the installation here: https://docs.mirantis.com/openstack/fuel/fuel-9.2/<br/>

### Needed Resource
fuel_build_local-9.0.run = fuel_build_local-9.0.sh + 9.0 resources<br/>
fuel_build_local-9.2.run = fuel_build_local-9.2.sh + 9.2 resources<br/>
  
warning: The git only provide the single shell script. You need to download the following resource.

Download:<br/>
fuel_build_local-9.0.run:<br/>

fuel_build_local-9.2.run:<br/>


### How to use
1.Wait the MirantisOpenStack-9.0.iso installation finished. Like:<br/>
![fuel master installed](https://github.com/BalaBalaYi/OpenStack-FUEL-9.0-9.2-OFFLINE-INSTALLATION-AUTOMATIC/raw/master/install.png) 

2.Run the script on fuel-master node. <br/>
e.g. chmod +x fuel_build_local-9.2.run && sh ./fuel_build_local-9.2.run

3.Then you can deploy openstack with fuel web. GoodLuck^^


