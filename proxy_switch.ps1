#$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet" | Where-Object {$_.AddressFamily -eq 'IPv4'}).IPAddress
#Write-Host "A belső hálózati IP cím: $ipAddress"

#$networkInterfaces = Get-NetIPAddress -AddressFamily IPv4 | Select-Object -Property InterfaceAlias, IPAddress
$networkInterfaces = (Get-NetIPAddress -AddressFamily IPv4).IPAddress
#Write-Host $networkInterfaces

$proxy_required_array = @("11.0","172.17","132")

foreach ($iface in $networkInterfaces) {
	$firstOctets = ($iface -split '\.')[0..1] -join '.'
#	Write-Host $firstOctets

	foreach ($proxy_required_ip in $proxy_required_array){
		if ($proxy_required_ip -eq $firstOctets) {
			$proxy_need = "yes"
#			Write-Host "Match"
#		} else {
#			Write-Host "Not Match"
		}
	}
}

#Write-Host $proxy_need_array

if ($proxy_need -eq "yes") {
	Write-Host "Proxy need to set up"
	Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyServer -Value "192.168.1.200:3128"
	Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -Value 1
	} else {
	Write-Host "Proxy need to remove"
	Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyServer -Value ""
	Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -Value 0
}

function Remove-Proxy {    
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyServer -Value ""
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -Value 0
}
