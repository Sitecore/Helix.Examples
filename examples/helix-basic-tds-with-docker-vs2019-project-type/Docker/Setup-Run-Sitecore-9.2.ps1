
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
	$userName = "AZURE USERNAME"
	$password = "AZURE PASSWORD"

	docker login $azureRepository -u $userName -p $password

	docker-compose -f $composeFile up -d --build

}
function CopySitecoreFiles($sitecoreContainerName, $outputDir){
    
    $dockerId = docker ps -q --filter name=${sitecoreContainerName}

    docker stop $dockerId

    $dockerIdAndPath = "${dockerId}:/inetpub/wwwroot"

    docker cp $dockerIdAndPath "${outputDir}"

    docker start $dockerId
	
	Write-Output "Sitecore files from container, " $sitecoreContainerName  ", have been copied to " $outputDir
}

CreateWWWrootFoldersInCMAndCD
SetupAndRun "docker-compose.9.2.0.xp.yml"
CopySitecoreFiles "docker_cm_1" "data/cm"
CopySitecoreFiles "docker_cd_1" "data/cd"



