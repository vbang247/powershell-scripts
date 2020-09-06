##Vertica
$url = 'https://my.vertica.com/download/vertica/client-drivers/'
$site = Invoke-WebRequest -UseBasicParsing -Uri $url
#$version = $site.links | ?{ $_.href.Contains('VerticaSetup') -and $_.href.ToLower().EndsWith("exe") } | sort href -desc | select href -first 1
$table = $site.links | ?{ $_.tagName -eq 'a' -and $_.href.Contains('VerticaSetup') -and $_.href.ToLower().EndsWith("exe") } | sort href -desc | select href -first 1
$filename = $table.href.ToString()
#$version1 = $version.href.ToString()
Write-Host "filename is $filename"
Write-Host "table is $table"
Write-Host "version is $version"

# Download installer
$src = $filename
Write-Host "src is $src"
$dst = $env:temp + '\' + "VerticaSetup.exe"
Write-Host "dst is $dst"
#Invoke-WebRequest $src -OutFile $dst

# Install
##& $dst /S /master=salt /minion-name=$env:computername /start-service=1



