iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

choco install firefox -y
choco install 7zip.install -y
choco install git.install -y
choco install processhacker -y

choco install sysinternals -y
choco install atom -y
choco install nuget.commandline -y
choco install wireshark -y

choco install vs2015remotetools -y
choco install vs2013remotetools -y
choco install powershell -y

choco install ruby -y
choco install ruby2.devkit -y

$env:PATH = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";" + [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)

cd C:\tools\DevKit2
echo  '---' | Out-File -Encoding ascii config.yml
echo  '- c:/tools/ruby23' | Out-File -Encoding ascii -Append config.yml
ruby C:\tools\DevKit2\dk.rb install
gem install cf-uaac bosh_cli nats --no-rdoc --no-ri


choco install mingw -y

choco install golang -y


$env:GOPATH = "C:\gopath"
mkdir -f $env:GOPATH
setx /m GOPATH $env:GOPATH
if ([Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) -inotlike "*$env:GOPATH\bin*") {
  [Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + "$env:GOPATH\bin;", [EnvironmentVariableTarget]::Machine)
}

$env:PATH = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";" + [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
$env:GOROOT = [Environment]::GetEnvironmentVariable("GOROOT", [EnvironmentVariableTarget]::Machine)

go get -u -v github.com/tools/godep
go get -u -v github.com/cloudfoundry-incubator/veritas
go get -u -v github.com/cloudfoundry-incubator/rep/cmd/rep
go get -u -v github.com/coreos/etcd
go get -u -v github.com/hashicorp/consul

