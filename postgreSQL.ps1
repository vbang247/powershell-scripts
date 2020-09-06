		# Find latest installer
		$connector = 'PostgreSQL'


		#creating folder structure
		$folder = $env:temp + '\' + 'Latest_' + $connector
		Write-Host "Folder location to download the $connector driver is $folder"
		"Creating the folder"
		New-Item -ItemType Directory -Force -Path $folder

		#log file
		$LogTime = Get-Date -Format "MM-dd-yyyy_hh-mm-ss"
		"Getting Date format as MM-dd-yyyy_hh-mm-ss to append to the log file name"
		$Log_File = 'Script' + $LogTime + '.log'
		"Setting the name of the log file to $Log_File" 
		$Log_File= $folder + '\' + $Log_File
		"Setting the log file location"
		Get-ChildItem -Path $folder -File -Include Script*.log -Recurse | Remove-Item -Force -Verbose
		"Removing the log file from any previous download"
		Start-Transcript -path $Log_File -force

		Try
		{

		$url = 'https://ftp.postgresql.org/pub/odbc/versions/msi/'
		"Setting URL for driver download: $url" 
		$site = Invoke-WebRequest -UseBasicParsing -Uri $url
		"Invoking Web Request to parse the URL $url"
		$table = $site.links | ?{ $_.tagName -eq 'A' -and $_.href.ToLower().Contains('psqlodbc_') -and $_.href.ToLower().EndsWith("x64.zip") } | sort href -desc | select href -first 1
		"Searching and selecting the latest version of $connector driver on the $url page and storing it in 'table' variable"
		"table variable value is $table"
		$filename = $table.href.ToString()
		"Converting the table variable value to string and storing it in 'filename' variable"
		"filename variable value is $filename"

		#getting version and extension
		"Splitting the filename variable using '.' to get the latest version of driver on the download site and storing it in version variable"
		$version = (Split-Path -Path $filename -Leaf).Split(".")[0];
		"Latest version of $connector driver on vendor's site is: $version"

		#creating file to write version number to 
		$versionFilename = 'version.text'

		"Setting file name to $versionFilename to write the version number to"
		$versionFile = $folder + '\' + $versionFilename
		"$versionFilename file location is $versionFile"

		####################test##############
		$shareLocation = '\\DA-DESKTOP-04.pun.qclab.test\f$\test'
		$shareVersionFile = $shareLocation + '\' + $versionFilename
		"Deleting any remote connections to the artifactory"
		net use * /d /y
		"Accessing the artifactory using user apac\spotfiretest"
		net use x: $shareLocation /user:pun\admin Tibco2012
		Compare-Object -ReferenceObject $version -DifferenceObject $(Get-Content $shareVersionFile)

		#############################################
		"Using if condition to verify if $versionFilename exists in the $folder location"
		if (!(Test-Path $versionFile))
		{
		New-Item -path $folder -name $versionFilename -type "file" -value "This file is newly created and hence has no version number"
		"Created new file $versionFilename in the $folder location to store the version extracted from the vendor's site"
		}
		else
		{
		"File $versionFilename already exists in the location $folder. 
		Hence skipping the $versionFilename creation step"
		}

		#comparison with the version in text file
		"Getting content of the $versionFilename from previous download"
		Get-Content -Path $versionFile

		 
		   
		"Comparing the $versionFilename content with the version variable to see if the latest version on the vendor's site is same or different"
		if(Compare-Object -ReferenceObject $version -DifferenceObject $(Get-Content $versionFile))
		{
		 "The installer should be downloaded"
		  #Setting variables for source and destination
		  $src = $url + $filename
		  "Source for downloading the installer is: $src"
		  $dst = $folder + '\' + $filename
		  "Destination for downloaded installer is: $dst"
		  "Invoking Web Request to download the installer"
		  Invoke-WebRequest $src -OutFile $dst
		  "Writing the new Latest version $version on the vendor's site to version file $versionFilename"
		   $version > $versionFile
		   if(Compare-Object -ReferenceObject $version -DifferenceObject $(Get-Content $shareVersionFile))
		   {
		   $version > $shareVersionFile
		   #copying installer to the artifactory
		   "Deleting any remote connections to the artifactory"
		   net use * /d /y
		   "Accessing the artifactory using user apac\spotfiretest"
		   net use x: \\DA-DESKTOP-04.pun.qclab.test\f$\test /user:pun\admin Tibco2012
		   "Copying the installer to the artifactory"
		   Copy-Item -Path $dst -Destination \\DA-DESKTOP-04.pun.qclab.test\f$\test -Force
		   }
		}
		Else 
		{"The Latest version on the vendor's site is same as the Latest version of $connector driver in artifactory"
		"Hence skipping download"
		}


		#end of try block
		}
		Catch
		{
			#start of catch block
			"In Catch block,Error message is: "
			$ErrorMessage = $_.Exception.Message
			"$ErrorMessage"
			Break

		}
		Finally
		{
			#In Finally block
			$Time=Get-Date
			"This script made a read attempt at $Time" | out-file $folder\Timestamp.log
		}

		Stop-Transcript

		# Install
		#& $dst /S /master=salt /minion-name=$env:computername /start-service=1

