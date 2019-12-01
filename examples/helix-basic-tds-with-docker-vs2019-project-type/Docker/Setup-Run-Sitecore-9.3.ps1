param(
    [Parameter(Mandatory = $true)]
    [string]$ComposeFile
    ,
    [Parameter(Mandatory = $true)]
    [ValidateScript( { Test-Path $_ -PathType "Leaf" })]
    [string]$PathToLicense
)

function CreateWWWrootFoldersInCMAndCD() 
{

	$cmPath = Join-Path $PSScriptRoot "\data\cm\wwwroot"
	$cdPath = Join-Path $PSScriptRoot "\data\cd\wwwroot"
	
	if (!(Test-Path $cmPath) -or !(Test-Path $cdPath)) {
		# Remove docker data path from Windows Defender
		Add-MpPreference -ExclusionPath (Join-Path $PSScriptRoot "\data")
	}
	
	if (!(Test-Path $cmPath)) {
		new-item -type directory -path $cmPath -Force
	}
	
	if (!(Test-Path $cdPath)) {
		new-item -type directory -path $cdPath -Force
	}
	
}


function SetupAndRun($composeFile)
{

  $azureRepository = "sitecoreimages.azurecr.io"
	$userName = "username"
	$password = "lGEllXfJ2/yB9q39a63tSZJ4jv9FaXj2"

	docker login $azureRepository -u $userName -p $password

	docker-compose -f $composeFile up -d --build

}
function CopySitecoreFiles($sitecoreContainerName, $outputDir){
    
    Write-Output "Start compressing wwwroot from ${sitecoreContainerName}"

    $dockerId = docker ps -q --filter name=${sitecoreContainerName}

    docker exec $dockerId powershell -command "C:\scripts\GenerateZipForWwwroot.ps1"

    docker stop $dockerId

    Write-Output "wwwroot.zip will be copied from ${sitecoreContainerName} to  ${outputDir}"

    $dockerIdAndPath = "${dockerId}:/wwwroot.zip"

    docker cp $dockerIdAndPath "${outputDir}"

    docker start $dockerId
	
    
    #Add-Type -Assembly "System.IO.Compression.Filesystem"
    #[System.IO.Compression.ZipFile]::ExtractToDirectory("${PSScriptRoot}\${outputDir}\wwwroot.zip","${PSScriptRoot}\${outputDir}\wwwroot")

    #Expand-Archive -Path "${PSScriptRoot}\${outputDir}\wwwroot.zip" -DestinationPath $PSScriptRoot\${outputDir}\wwwroot

	  Write-Output "Sorry good people, but we need you to unzip the wwwroot.zip in ${PSScriptRoot}\${outputDir}" 
    Write-Output "When you are done with the unzipping, please run following comman:"
   
}

CreateWWWrootFoldersInCMAndCD
.\Set-LicenseEnvironmentVariable.ps1 -Path $PathToLicense  -PersistForCurrentUser:$true
SetupAndRun $ComposeFile



