# Find latest installer
$url = 'http://docs.aws.amazon.com/redshift/latest/mgmt/install-odbc-driver-windows.html'
$site = Invoke-WebRequest -Uri $url -UseBasicParsing
$table = $site.Links | ?{ $_.href.Contains('https://s3.amazonaws.com/redshift-downloads/drivers/AmazonRedshiftODBC64') -and $_.href.EndsWith(".msi") } | sort href -desc | select href -first 1
$filename = $table.href.ToString()
Write-Host "filename is $filename"
Write-Host "table is $table"

#Download installer
$src = $filename
Write-Host "src is $src"
$dst = $env:temp + '\VBANG\' + 'AmazonRedshiftODBC64.msi'
Write-Host "dst is $dst"
Invoke-WebRequest $src -OutFile $dst

