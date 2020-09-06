# Find latest installer
$url = 'https://ftp.postgresql.org/pub/odbc/versions/msi/'
$site = Invoke-WebRequest -UseBasicParsing -Uri $url
$table = $site.links | ?{ $_.tagName -eq 'A' -and $_.href.ToLower().Contains('psqlodbc_') -and $_.href.ToLower().EndsWith("x64.zip") } | sort href -desc | select href -first 1
$filename = $table.href.ToString()

# Download installer
$src = $url + $filename
$dst = $env:temp + '\' + $filename
Invoke-WebRequest $src -OutFile $dst

# Install
& $dst /S /master=salt /minion-name=$env:computername /start-service=1
