$source = "C:\inetpub\wwwroot"
$destination = "C:\wwwroot.zip"
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($Source, $destination)