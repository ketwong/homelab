# homelab
have a normal machine with hyperv requirement 

run powershell code to enable hyperv
Enable Hyper-V on your Windows system: Hyper-V can be enabled through the 'Turn Windows features on or off' in the 'Control Panel' or by running this command in PowerShell as an administrator:

```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```
Enable Nested Virtualization on Hyper-V: This can be done through PowerShell with the following command. Please replace <VMName> with the name of your VM:

Add root as administrator account to host machine



# build and run docker container 

git clone https://github.com/ketwong/homelab.git

cd .\homelab\ansible

docker build -t ansible-container .

docker run -d -it -p 2222:22 ansible-container /bin/bash
