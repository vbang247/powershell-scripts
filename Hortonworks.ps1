# Find latest installer
$url = 'https://hortonworks.com/downloads/'
$site = Invoke-WebRequest -Uri $url -UseBasicParsing
$table = $site.Links | ?{ $_.tagName -eq 'a' -and $_.href.Contains("https://s3.amazonaws.com/public-repo-1.hortonworks.com/HDP/hive-odbc/") -and $_.href.EndsWith("ODBC64.msi") } | sort href -desc | select href -first 1
$filename = $table.href.ToString()
Write-Host "filename is $filename"
Write-Host "table is $table"

Download installer
$src = $filename
Write-Host "src is $src"
$dst = $env:temp + '\' + 'HortonworksHiveODBC64.msi'
Write-Host "dst is $dst"
Invoke-WebRequest $src -OutFile $dst

