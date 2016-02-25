Set-PSDebug -Trace 1

$wd="C:\diego-kit"
mkdir -Force $wd
cd $wd


## Cleanup previous installations

echo "Trying to uninstall DiegoWindows and GardenWindows"

gwmi Win32_Product -Filter "Name = 'DiegoWindows'" | % { $_.Uninstall() }
gwmi Win32_Product  -Filter "Name = 'GardenWindows'" | % { $_.Uninstall() }

Get-CimInstance Win32_Product  -Filter "Name = 'DiegoWindows'" | Invoke-CimMethod -MethodName Uninstall
Get-CimInstance Win32_Product  -Filter "Name = 'GardenWindows'" | Invoke-CimMethod -MethodName Uninstall


## Download installers

$gardenReleaseVersion="v0.171"
$diegoReleaseVersion="v0.461"
curl -UseBasicParsing -OutFile $wd\setup.ps1 https://github.com/cloudfoundry/garden-windows-release/releases/download/$gardenReleaseVersion/setup.ps1 -Verbose
curl -UseBasicParsing -OutFile $wd\GardenWindows.msi https://github.com/cloudfoundry/garden-windows-release/releases/download/$gardenReleaseVersion/GardenWindows.msi -Verbose
curl -UseBasicParsing -OutFile $wd\DiegoWindows.msi https://github.com/cloudfoundry/diego-windows-release/releases/download/$diegoReleaseVersion/DiegoWindows.msi -Verbose
curl -UseBasicParsing -OutFile $wd\generate.exe https://github.com/cloudfoundry/diego-windows-release/releases/download/$diegoReleaseVersion/generate.exe -Verbose
curl -UseBasicParsing -OutFile $wd\hakim.exe https://github.com/cloudfoundry/diego-windows-release/releases/download/$diegoReleaseVersion/hakim.exe -Verbose


# Dependencies

# Install chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Make sure powershell is installed
Install-WindowsFeature PowerShell


# Deps for cf-iis8-buildpack
Install-WindowsFeature Web-Net-Ext45, Web-AppInit 
choco install vcredist2013 -y
choco install vcredist2015 -y

## Setup diego networking

$machineIp = (Find-NetRoute -RemoteIPAddress "192.168.50.4")[0].IPAddress
$diegoInterface = Get-NetIPAddress -IPAddress $machineIp
# $diegoInterface | Remove-NetIPAddress -AddressFamily IPv4 -Confirm:$false
# $diegoInterface | New-NetIPAddress -AddressFamily IPv4  -IPAddress $machineIp -PrefixLength $diegoInterface.PrefixLength

### 1.2.3.4 is used by rep to discover the IP address to be announced to the diego cluster
route delete 1.2.3.4
route add 1.2.3.4 192.168.50.4 -p

route delete 10.244.0.0
route add 10.244.0.0 mask 255.255.0.0 192.168.50.4 -p


## Setup diego

echo "Running setup.ps1"
powershell $wd\setup.ps1 -quiet

echo "Running generate.exe"
& $wd\generate.exe  -boshUrl https://admin:admin@192.168.50.4:25555  -outputDir .  -machineIp "$machineIp"

echo "Installing DiegoWindows and GardenWindows"
& $wd\install.bat

echo "Running hakim to check windows cell status"
& $wd\hakim.exe
