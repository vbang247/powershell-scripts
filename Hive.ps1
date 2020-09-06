<# $URI = 'https://www.cloudera.com/search.html?q=ODBC+driver&start=0&limit=10&sort=score+desc'
$HTML = Invoke-WebRequest -Uri $URI
$version = $HTML.ParsedHtml.getElementById("download-eselect-0")
Write-Host " latest driver version is $version" #>

$url = 'https://www.cloudera.com/downloads/connectors/hive/odbc.html'
$url1 = 'https://www.cloudera.com'
$site = Invoke-WebRequest -UseBasicParsing -Uri $url
$table = $site.Links | ?{ $_.tagName -eq 'A' -and $_.href.Contains('/downloads/connectors/hive/odbc/') } | select href -first 1
$filename = $table.href.ToString()
$src = $url1 + $filename
Write-Host " Download URL is $src"

#$site1 = Invoke-WebRequest -UseBasicParsing -Uri $src
Write-Host " Site1 is $site1"
#$table1 = $site1.Links | ?{ $_.tagName -eq 'A' -and -and $_.href.EndsWith('Windows/ClouderaHiveODBC64.msi') } | select href -first 1
#Write-Host " Table1 is $table1"

<# $HTML = Invoke-WebRequest -Uri $src
$version = ($HTML.ParsedHtml.getElementsByTagName("a") ).innerText
$table1 = $src.Links | ?{ $_.tagName -eq 'a' -and $_.href.Contains('https://downloads.cloudera.com/connectors/hive_odbc_') -and $_.href.EndsWith("Windows/ClouderaHiveODBC64.msi")} | select href -first 1 #> #>