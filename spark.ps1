# Find latest installer
$url = 'http://apache.mirror.anlx.net/spark/'
Write-Host "Invoking URL $url for downloading Apache Spark latest distribution"
$site = Invoke-WebRequest -Uri $url -UseBasicParsing
$url = $url + ((Invoke-WebRequest -Uri $url -UseBasicParsing).Links | ?{ $_.tagName -eq 'a' -and $_.href.Contains('spark')} | Select-Object href -Last 1).href
$url = $url + ((Invoke-WebRequest -Uri $url -UseBasicParsing).Links | ?{ $_.tagName -eq 'a' -and $_.href.Contains('bin-hadoop')} | Select-Object href -Last 1).href                   
Write-Host "Complete URL for Apache Spark tar.gz file is $url"
wget -q $url
#tar -xf *.tgz