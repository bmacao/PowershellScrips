#Get pre-requisites from user
#Request file extension and Destination URL for upload
$listdr = @(get-psdrive –psprovider filesystem | Select-Object -ExpandProperty Root)

write-output "Discovered drives: "$listdr

$Flext = Read-Host -Prompt 'Enter file extension for search'

$DestURL = Read-Host -Prompt 'Enter destination URL'


#Run search and parallel upload - 4 jobs simultaneously 
workflow Test-Workflow{

Param (
        $driveslist,
        $filext,
        $URL
         )


foreach($drive in $driveslist){

   $filesfound = Get-ChildItem -Path $driveslist -Filter "*.$filext" -Recurse  -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
   $flscount = $filesfound.Count
   $out1 = "Sending files - count: " + $flscount + " on drive " + $drive
   Write-Output $out1
   Foreach -Parallel -throttlelimit 4($file in $filesfound){ 
    
    $upload= Invoke-RestMethod -Uri $URL -Method Post -InFile $file -ContentType 'multipart/form-data' 
  

}

}
}


Test-Workflow $listdr $Flext $DestURL