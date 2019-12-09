# Docker 

### Install and run Sitecore 9.3

#### Prerequisites - Generate Sitecore Docker Images:

Go to https://github.com/Sitecore/docker-images and clone or copy solution.
Follow instructions and run the Build.ps1. If you just want to have the images locally(not pushing to any registry), change the -PushMode to Never

Here is an example of a Build.ps1 script:
```
[CmdletBinding(SupportsShouldProcess = $true)]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "SitecorePassword")]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$InstallSourcePath = (Join-Path $PSScriptRoot "\packages")
    ,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$SitecoreUsername
    ,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$SitecorePassword
)

$ErrorActionPreference = "STOP"
$ProgressPreference = "SilentlyContinue"


$azureRepository = "sitecoreimages.azurecr.io"
$azureUserName = "ZZZZZZZZZ"
$azurePassword = "XXXXXXXXX"

# Login
docker login $azureRepository -u $azureUserName -p $azurePassword


# load module
Import-Module (Join-Path $PSScriptRoot "\modules\SitecoreImageBuilder") -Force

$baseTags = "*:9.3.0*1903"

# restore any missing packages
SitecoreImageBuilder\Invoke-PackageRestore `
    -Path (Join-Path $PSScriptRoot "\windows") `
    -Destination $InstallSourcePath `
    -SitecoreUsername $SitecoreUsername `
    -SitecorePassword $SitecorePassword `
    -Tags $baseTags `
    -WhatIf:$WhatIfPreference

# start the build
SitecoreImageBuilder\Invoke-Build `
    -Path (Join-Path $PSScriptRoot "\windows") `
    -InstallSourcePath $InstallSourcePath `
    -Registry $azureRepository `
    -Tags $baseTags `
    -PushMode "WhenChanged" # optional (default "WhenChanged"), can also be "Never" or "Always".
    -WhatIf:$WhatIfPreference
```


#### Prerequisites - Install Dockers:

- Navigate to: https://hub.docker.com/editions/community/docker-ce-desktop-windows
- Register and login. Here you will see the download for docker.
- When you've installed Dockers, select windows mode.


#### 1. Verify .env file
Verify and check the ".env variables". They are needed for the docker-compose file. (The .env file is located in the Docker folder)
```
REGISTRY=sitecoreimages.azurecr.io/
WINDOWSSERVERCORE_VERSION=1903
NANOSERVER_VERSION=1903
SITECORE_VERSION=9.3.0
SITECORE_LICENSE=
REMOTEDEBUGGER_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\Remote Debugger
SQL_SA_PASSWORD=8Tombs-Given-Clock#-arming-Alva-debut-Spine-monica-Normal-Ted-About1-chard-Easily-granddad-5Context!
TELERIK_ENCRYPTION_KEY=qspJhcSmT5VQSfbZadFfzhCK6Ud7uRoS42Qcm8UofvVLiXciUBcUeZELsTo8KD9o6KderQr9Z8uZ9CHisFJNRz46WTZ5qCRufRFt
```

 
#### 2. Run script:
Open windows powershell. Run it as administrator. 
Navigate to docker in the windows powershell window (e.g C:\Projects\Helix.Examples\examples\helix-basic-tds-with-a-twist\Docker) and run script:
```
.\Setup-Run-Sitecore-9.3.ps1 "docker-compose.9.3.0.xp.yml"  -Path C:\license\license.xml
```
It will download images(if needed) from the repository, compose/setup a Sitecore instance. 
We will not copy files to the wwwroot(in data/cm/), we will go for the black-box approach(recommended). 


<details>
  <summary>Folders and files (for the Sitecore instance) are located in the data folder.</summary>
  
- cd
- cm
- commerce-authoring
- commerce-minions
- commerce-ops
- commerce-shops
- creativeexchange
- identity
- solr
- sql
- xconnect
- xconnect-automationengine
- xconnect-indexworker
- xconnect-processingengine

</details>


<details>
<summary>View script: Setup-Run-Sitecore-9.3.ps1</summary>

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
      $userName = "ZZZZZZZZZ"
      $password = "XXXXXXXXX"

      docker login $azureRepository -u $userName -p $password

      docker-compose -f $composeFile up -d --build

    }

    CreateWWWrootFoldersInCMAndCD
    .\Set-LicenseEnvironmentVariable.ps1 -Path $PathToLicense  -PersistForCurrentUser:$true
    SetupAndRun $ComposeFile

</details>   
    


To make Sitecore TDS work properly, changes had to be made in the docker compose file.
When the CM and CD container starts up they calls the C:\\tools\\entrypoints\\iis\\Development.ps1 script. The script does many things... One of them is to listen to changes in the root folder C:\src, if changes then move content to the intepub/wwwroot. That is also why it is mapped to the data/cm/wwwroot folder in the docker-compose file. 

The issue is that it ignores web.config files, that means any web.config file will be ignored if deployed/published to data/cm/wwwroot. Sitecore TDS uses a web.config(in the _DEV folder) to get the SitecoreAccessGuid. 

To fix this I have created a modified version of the Development.ps1, the script is called Custom-Tools-Entrypoints-IIS-Development.ps1 and it will not exclude web.config's.
The script is placed in folder ContainerScripts, the folder will be mapped to C:\scripts in the docker container.
In docker compose CM container will call the Custom-Tools-Entrypoints-IIS-Development.ps1 instead of the original Development.ps1.

```
cm:
        image: ${REGISTRY}sitecore-xp-standalone:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - .\ContainerScripts:C:\scripts
          - .\data\cm\wwwroot:C:\src
          - ${REMOTEDEBUGGER_PATH}:C:\remote_debugger:ro
        entrypoint: powershell.exe -NoLogo -NoProfile -File C:\\scripts\\Custom-Tools-Entrypoints-IIS-Development.ps1 
```

 <details>
 <summary>View docker-compose.9.3.0.xp.yml</summary>
 
    version: '2.4'

    services:

      sql:
        image: ${REGISTRY}sitecore-xp-sqldev:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - .\data\sql:C:\Data
        mem_limit: 2GB
        ports:
          - "44010:1433"
        environment:
          SA_PASSWORD: ${SQL_SA_PASSWORD}
          ACCEPT_EULA: "Y"

      solr:
        image: ${REGISTRY}sitecore-xp-solr:${SITECORE_VERSION}-nanoserver-${NANOSERVER_VERSION}
        volumes:
          - .\data\solr:C:\Data
        mem_limit: 1GB
        ports:
          - "44011:8983"

      xconnect:
        image: ${REGISTRY}sitecore-xp-xconnect:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - .\data\xconnect:C:\inetpub\wwwroot\App_Data\logs
        mem_limit: 1GB
        environment:
          SITECORE_LICENSE: ${SITECORE_LICENSE}
          SITECORE_SITECORE:XCONNECT:COLLECTIONSEARCH:SERVICES:SOLR.SOLRREADERSETTINGS:OPTIONS:REQUIREHTTPS: 'false'
          SITECORE_SITECORE:XCONNECT:SEARCHINDEXER:SERVICES:SOLR.SOLRWRITERSETTINGS:OPTIONS:REQUIREHTTPS: 'false'
          SITECORE_CONNECTIONSTRINGS_MESSAGING: Data Source=sql;Database=Sitecore.Messaging;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_PROCESSING.ENGINE.STORAGE: Data Source=sql;Database=Sitecore.ProcessingEngineStorage;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_REPORTING: Data Source=sql;Database=Sitecore.Reporting;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_XDB.MARKETINGAUTOMATION: Data Source=sql;Database=Sitecore.MarketingAutomation;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_XDB.PROCESSING.POOLS: Data Source=sql;Database=Sitecore.Processing.Pools;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_XDB.REFERENCEDATA: Data Source=sql;Database=Sitecore.ReferenceData;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_COLLECTION: Data Source=sql;Database=Sitecore.Xdb.Collection.ShardMapManager;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_SOLRCORE: http://solr:8983/solr/sitecore_xdb
        depends_on:
          - sql
          - solr

      xconnect-automationengine:
        image: ${REGISTRY}sitecore-xp-xconnect-automationengine:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - .\data\xconnect-automationengine:C:\worker\App_Data\logs
        mem_limit: 500MB
        environment:
          SITECORE_LICENSE: ${SITECORE_LICENSE}
          SITECORE_CONNECTIONSTRINGS_XCONNECT.COLLECTION: http://xconnect
          SITECORE_CONNECTIONSTRINGS_XDB.MARKETINGAUTOMATION: Data Source=sql;Database=Sitecore.MarketingAutomation;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_XDB.REFERENCEDATA: Data Source=sql;Database=Sitecore.ReferenceData;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_MESSAGING: Data Source=sql;Database=Sitecore.Messaging;User ID=sa;Password=${SQL_SA_PASSWORD}
        depends_on:
          - sql
          - xconnect

      xconnect-indexworker:
        image: ${REGISTRY}sitecore-xp-xconnect-indexworker:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - .\data\xconnect-indexworker:C:\worker\App_Data\logs
        mem_limit: 500MB
        environment:
          SITECORE_LICENSE: ${SITECORE_LICENSE}
          SITECORE_CONNECTIONSTRINGS_COLLECTION: Data Source=sql;Initial Catalog=Sitecore.Xdb.Collection.ShardMapManager;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_SOLRCORE: http://solr:8983/solr/sitecore_xdb
          SITECORE_SITECORE:XCONNECT:SEARCHINDEXER:SERVICES:SOLR.SOLRREADERSETTINGS:OPTIONS:REQUIREHTTPS: 'false'
          SITECORE_SITECORE:XCONNECT:SEARCHINDEXER:SERVICES:SOLR.SOLRWRITERSETTINGS:OPTIONS:REQUIREHTTPS: 'false'
        depends_on:
          - sql
          - solr

      xconnect-processingengine:
        image: ${REGISTRY}sitecore-xp-xconnect-processingengine:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - .\data\xconnect-processingengine:C:\worker\App_Data\logs
        mem_limit: 500MB
        restart: unless-stopped
        environment:
          SITECORE_LICENSE: ${SITECORE_LICENSE}
          SITECORE_CONNECTIONSTRINGS_PROCESSING.ENGINE.STORAGE: Data Source=sql;Database=Sitecore.Processing.Engine.Storage;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_PROCESSING.ENGINE.TASKS: Data Source=sql;Database=Sitecore.Processing.Engine.Tasks;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_PROCESSING.WEBAPI.BLOB: http://xconnect
          SITECORE_CONNECTIONSTRINGS_PROCESSING.WEBAPI.TABLE: http://xconnect
          SITECORE_CONNECTIONSTRINGS_XCONNECT.COLLECTION: http://xconnect
          SITECORE_CONNECTIONSTRINGS_XCONNECT.CONFIGURATION: http://xconnect
          SITECORE_CONNECTIONSTRINGS_XCONNECT.SEARCH: http://xconnect
          SITECORE_CONNECTIONSTRINGS_MESSAGING: Data Source=sql;Database=Sitecore.Messaging;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_REPORTING: Data Source=sql;Database=Sitecore.Reporting;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_SETTINGS:SERILOG:MINIMUMLEVEL:DEFAULT: Information
        depends_on:
          - sql
          - xconnect

      cd:
        image: ${REGISTRY}sitecore-xp-cd:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - .\ContainerScripts:C:\scripts
          - .\data\cd\wwwroot:C:\src
          - ${REMOTEDEBUGGER_PATH}:C:\remote_debugger:ro
        entrypoint: powershell.exe -NoLogo -NoProfile -File C:\\tools\\entrypoints\\iis\\Development.ps1
        ports:
          - "44002:80"
        environment:
          SITECORE_LICENSE: ${SITECORE_LICENSE}
          SITECORE_APPSETTINGS_ROLE:DEFINE: ContentDelivery
          SITECORE_CONNECTIONSTRINGS_SECURITY: Data Source=sql;Initial Catalog=Sitecore.Core;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_WEB: Data Source=sql;Initial Catalog=Sitecore.Web;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_EXPERIENCEFORMS: Data Source=sql;Initial Catalog=Sitecore.ExperienceForms;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_SOLR.SEARCH: http://solr:8983/solr
          SITECORE_CONNECTIONSTRINGS_MESSAGING: Data Source=sql;Database=Sitecore.Messaging;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_EXM.MASTER: Data Source=sql;Database=Sitecore.EXM.Master;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_XCONNECT.COLLECTION: http://xconnect
          SITECORE_CONNECTIONSTRINGS_XDB.MARKETINGAUTOMATION.OPERATIONS.CLIENT: http://xconnect
          SITECORE_CONNECTIONSTRINGS_SITECORE.REPORTING.CLIENT: http://xconnect
          SITECORE_CONNECTIONSTRINGS_XDB.REFERENCEDATA.CLIENT: http://xconnect
        depends_on:
          - sql
          - solr
          - xconnect

      cm:
        image: ${REGISTRY}sitecore-xp-standalone:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - .\ContainerScripts:C:\scripts
          - .\data\cm\wwwroot:C:\src
          - ${REMOTEDEBUGGER_PATH}:C:\remote_debugger:ro
        entrypoint: powershell.exe -NoLogo -NoProfile -File C:\\scripts\\Custom-Tools-Entrypoints-IIS-Development.ps1 
        ports:
          - "44001:80"
        environment:
          SITECORE_LICENSE: ${SITECORE_LICENSE}
          SITECORE_APPSETTINGS_ROLE:DEFINE: Standalone
          SITECORE_CONNECTIONSTRINGS_CORE: Data Source=sql;Initial Catalog=Sitecore.Core;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_SECURITY: Data Source=sql;Initial Catalog=Sitecore.Core;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_MASTER: Data Source=sql;Initial Catalog=Sitecore.Master;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_WEB: Data Source=sql;Initial Catalog=Sitecore.Web;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_EXPERIENCEFORMS: Data Source=sql;Initial Catalog=Sitecore.ExperienceForms;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_SOLR.SEARCH: http://solr:8983/solr
          SITECORE_CONNECTIONSTRINGS_MESSAGING: Data Source=sql;Database=Sitecore.Messaging;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_XDB.MARKETINGAUTOMATION: Data Source=sql;Database=Sitecore.MarketingAutomation;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_XDB.PROCESSING.POOLS: Data Source=sql;Database=Sitecore.Processing.Pools;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_XDB.REFERENCEDATA: Data Source=sql;Database=Sitecore.ReferenceData;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_XDB.PROCESSING.TASKS: Data Source=sql;Database=Sitecore.Processing.Tasks;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_EXM.MASTER: Data Source=sql;Database=Sitecore.EXM.Master;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_REPORTING: Data Source=sql;Database=Sitecore.Reporting;User ID=sa;Password=${SQL_SA_PASSWORD}
          SITECORE_CONNECTIONSTRINGS_SITECORE.REPORTING.CLIENT: http://xconnect
          SITECORE_CONNECTIONSTRINGS_XCONNECT.COLLECTION: http://xconnect
          SITECORE_CONNECTIONSTRINGS_XDB.MARKETINGAUTOMATION.OPERATIONS.CLIENT: http://xconnect
          SITECORE_CONNECTIONSTRINGS_XDB.MARKETINGAUTOMATION.REPORTING.CLIENT: http://xconnect
          SITECORE_CONNECTIONSTRINGS_XDB.REFERENCEDATA.CLIENT: http://xconnect
          SITECORE_APPSETTINGS_TELERIK.ASYNCUPLOAD.CONFIGURATIONENCRYPTIONKEY: ${TELERIK_ENCRYPTION_KEY}
          SITECORE_APPSETTINGS_TELERIK.UPLOAD.CONFIGURATIONHASHKEY: ${TELERIK_ENCRYPTION_KEY}
          SITECORE_APPSETTINGS_TELERIK.WEB.UI.DIALOGPARAMETERSENCRYPTIONKEY: ${TELERIK_ENCRYPTION_KEY}
        depends_on:
          - sql
          - solr
          - xconnect

 
</details>


If you have issues, please run the following command:
```
docker-compose -f docker-compose.xp.yml down
```


To clean up/remove files in data folder, run script:
```
.\Clean-Data.ps1
```
<details>
 <summary>View script:</summary>
    
    
    Get-ChildItem -Path (Join-Path $PSScriptRoot "\data") -Directory | ForEach-Object {
        $dataPath = $_.FullName
        Get-ChildItem -Path $dataPath -Exclude ".gitkeep" -Recurse | Remove-Item -Force -Recurse -Verbose
    }
    
    
</details>

#### 3. Update hosts file
We will be using whales names. 
In powershell run the follwing:
```
npx whales-names
```

You should see something like this in your hosts file:
```
# whales-names begin
172.29.130.16	89746fe3a1b8 cd docker_cd_1
172.29.135.134	2bed266603b7 docker_xconnect-processingengine_1 xconnect-processingengine
172.29.139.155	cm de191be75c99 docker_cm_1
172.29.131.131	docker_xconnect-automationengine_1 e3958cc49df3 xconnect-automationengine
172.29.140.210	4cb4854bfc7d docker_xconnect_1 xconnect
172.29.140.131	75b2fe2f3928 docker_xconnect-indexworker_1 xconnect-indexworker
172.29.130.141	5a5f504cb5f7 docker_sql_1 sql
172.29.142.253	0add1137f154 docker_solr_1 solr
# whales-names end
```

Dont forget to terminate/close when you are done.

Last but very important. You need to set "basic-company" to your favourite instance in the hosts file.
```
172.29.139.155	cm de191be75c99 docker_cm_1 basic-company
``` 

#### 4. Attach the remote debugger
Get the ip address of the instance you want to debug, here it's the CM instance:
```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' docker_cm_1
```

In VisualStudio open up your debugger:
1. Select Remote(no authentication)'
2. Set the ip-address and dont forget to set port number 4024:
```
172.21.131.199:4024
``` 

3. Select w3wp.exe


Now you can debug your stuff :-)


### Install and run Sitecore 9.2

#### 1. License file 
Place your Sitecore license file in:
```
C:\license
```
*license file is needed when docker runs the compose file
#### 2. Verify .env file
Verify and check the ".env variables". They are needed for the docker-compose file. (The .env file is located in the Docker folder)
```
REGISTRY=sitecoreimages.azurecr.io
WINDOWSSERVERCORE_VERSION=1903
NANOSERVER_VERSION=1903
SITECORE_VERSION=9.2.0
LICENSE_PATH=C:\license
```

 
#### 3. Run script:
Open windows powershell. Run it as administrator. 
Navigate to docker in the windows powershell window (e.g C:\Projects\Helix.Examples\examples\helix-basic-tds-with-a-twist\Docker) and run script:
```
.\Setup-Run-Sitecore-9.2.ps1
```
It will download images(if needed) from the repository, compose/setup a Sitecore instance. But also copy the wwwroot's (from the Sitecore images) and put them into folders:CM and CD (Located in data folder).

<details>
  <summary>Folders and files (for the Sitecore instance) are located in the data folder.</summary>
  
- cd
- cm
- commerce-authoring
- commerce-minions
- commerce-ops
- commerce-shops
- creativeexchange
- identity
- solr
- sql
- xconnect
- xconnect-automationengine
- xconnect-indexworker
- xconnect-processingengine

</details>

<details>
 <summary>View script:</summary>
    
    
    function CreateWWWrootFoldersInCMAndCD() 
    {

        $cmPath = Join-Path $PSScriptRoot "\data\cm\wwwroot"
        $cdPath = Join-Path $PSScriptRoot "\data\cd\wwwroot"

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
        $userName = "sitecoreImages"
        $password = "lGEllXfJ2/yB9q39a63tSZJ4jv9FaXj2"

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
    SetupAndRun "docker-compose.xp.yml"
    CopySitecoreFiles "docker_cm_1" "data/cm"
    CopySitecoreFiles "docker_cd_1" "data/cd"
    
    
</details>

Current script will setup a standard XP intance(docker-compose.xp.yml).

*To setup another instance, replace docker-compose.xp.yml with docker-compose.something in Setup-Run-Sitecore.ps1 

 <details>
 <summary>docker-compose.xp.yml</summary>
 
    version: '2.4'

    services:

      sql:
        image: ${REGISTRY}sitecore-xp-sqldev:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - .\data\sql:C:\Data
        mem_limit: 2GB
        ports:
          - "44010:1433"

      solr:
        image: ${REGISTRY}sitecore-xp-solr:${SITECORE_VERSION}-nanoserver-${NANOSERVER_VERSION}
        volumes:
          - .\data\solr:C:\Data
        mem_limit: 1GB
        ports:
          - "44011:8983"

      xconnect:
        image: ${REGISTRY}sitecore-xp-xconnect:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - ${LICENSE_PATH}:C:\license
          - .\data\xconnect:C:\inetpub\wwwroot\App_Data\logs
        mem_limit: 1GB
        links:
          - sql
          - solr

      xconnect-automationengine:
        image: ${REGISTRY}sitecore-xp-xconnect-automationengine:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - ${LICENSE_PATH}:C:\license
          - .\data\xconnect-automationengine:C:\AutomationEngine\App_Data\logs
        mem_limit: 500MB
        links:
          - sql
          - xconnect

      xconnect-indexworker:
        image: ${REGISTRY}sitecore-xp-xconnect-indexworker:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - ${LICENSE_PATH}:C:\license
          - .\data\xconnect-indexworker:C:\IndexWorker\App_Data\logs
        mem_limit: 500MB
        links:
          - sql
          - solr

      xconnect-processingengine:
        image: ${REGISTRY}sitecore-xp-xconnect-processingengine:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - ${LICENSE_PATH}:C:\license
          - .\data\xconnect-processingengine:C:\ProcessingEngine\App_Data\logs
        mem_limit: 500MB
        restart: unless-stopped
        links:
          - sql
          - xconnect

      cd:
        image: ${REGISTRY}sitecore-xp-cd:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - ${LICENSE_PATH}:C:\license
         - .\data\cd\wwwroot:C:\inetpub\wwwroot
        ports:
          - "44002:80"
        links:
          - sql
          - solr
          - xconnect

      cm:
        image: ${REGISTRY}sitecore-xp-standalone:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - ${LICENSE_PATH}:C:\license
          - .\data\cm\wwwroot:C:\inetpub\wwwroot
        ports:
          - "44001:80"
        links:
          - sql
          - solr
          - xconnect

      identity:
        image: ${REGISTRY}sitecore-xp-identity:${SITECORE_VERSION}-windowsservercore-${WINDOWSSERVERCORE_VERSION}
        volumes:
          - ${LICENSE_PATH}:C:\license
          - .\data\identity:C:\inetpub\wwwroot\wwwroot\logs
        ports:
          - "44005:80"
        links:
          - sql

 
</details>


If you have issues, please run the following command:
```
docker-compose -f docker-compose.xp.yml down
```


To clean up/remove files in data folder, run script:
```
.\Clean-Data.ps1
```
<details>
 <summary>View script:</summary>
    
    
    Get-ChildItem -Path (Join-Path $PSScriptRoot "\data") -Directory | ForEach-Object {
        $dataPath = $_.FullName
        Get-ChildItem -Path $dataPath -Exclude ".gitkeep" -Recurse | Remove-Item -Force -Recurse -Verbose
    }
    
    
</details>

#### 4. Update hosts file
We will be using whales names. 
In powershell run the follwing:
```
npx whales-names
```

You should see something like this in your hosts file:
```
# whales-names begin
172.29.130.16	89746fe3a1b8 cd docker_cd_1
172.29.135.134	2bed266603b7 docker_xconnect-processingengine_1 xconnect-processingengine
172.29.139.155	cm de191be75c99 docker_cm_1
172.29.131.131	docker_xconnect-automationengine_1 e3958cc49df3 xconnect-automationengine
172.29.140.210	4cb4854bfc7d docker_xconnect_1 xconnect
172.29.140.131	75b2fe2f3928 docker_xconnect-indexworker_1 xconnect-indexworker
172.29.130.141	5a5f504cb5f7 docker_sql_1 sql
172.29.142.253	0add1137f154 docker_solr_1 solr
# whales-names end
```

Dont forget to terminate/close when you are done.

Last but very important. You need to set "basic-company" to your favourite instance in the hosts file.
```
172.29.139.155	cm de191be75c99 docker_cm_1 basic-company
``` 
