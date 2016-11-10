# Check host powershell version, script require 4 or above
$PowerVer = $PSVersionTable.PSVersion | Select -ExpandProperty Major 
if (($PowerVer -lt 4)) {
    write-warning "Powershell 4 or above required to run script"
    write-warning "Opening url for version download and update"
    # Open Powershell v4 webpage
    Start-Process -FilePath "https://www.microsoft.com/en-us/download/details.aspx?id=40855"

    # This will exit the original powershell process. This will only be done in case of Powershell less than 4.
    exit
} 

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  

$Form = New-Object System.Windows.Forms.Form    
$Form.Size = New-Object System.Drawing.Size(600,400)  

############################################## Start functions


function pingInfo {
$computer=$DropDownBox.SelectedItem.ToString() #populate the var with the value you selected

[xml]$XmlDocument1 = Get-Content -Path '<xml file path here>'

$obj1=@();

$outputBox.text="Commands available:"
$comx = $XmlDocument1.dbs.db | Where-Object {$_.type -eq $computer} | %{$_.commands}
$arrx = $comx -split ";"

foreach ($elemx in $arrx ){
    $outputBox.text+= "`r`n$elemx "
}

$outputBox.text+="`r`n"
$outputBox.text+="`r`n"
$outputBox.text+="Examples:"

$aux = $XmlDocument1.dbs.db | Where-Object {$_.type -eq $computer} | %{$_.examples}
$arr = $aux -split ";"

foreach ($elem in $arr ){
    $outputBox.text+= "`r`n$elem "
}

### end added code ###                     
                     

############################################## end functions

############################################## Start text fields

$DropDownBox = New-Object System.Windows.Forms.ComboBox #creating the dropdown list
$DropDownBox.Location = New-Object System.Drawing.Size(20,50) #location of the drop down (px) in relation to the primary window's edges (length, height)
$DropDownBox.Size = New-Object System.Drawing.Size(300,20) #the size in px of the drop down box (length, height)
$DropDownBox.DropDownHeight = 200 #the height of the pop out selection box
$Form.Controls.Add($DropDownBox) #activating the drop box inside the primary window


##added code ####

[xml]$XmlDocument = Get-Content -Path '<xml file path here>'

$obj=@();

foreach($user in $xmlDocument.dbs.db){
    $obj += $user.type 
}


### end added code ###

foreach ($wks in $obj) {
     $DropDownBox.Items.Add($wks)
} #end foreach

$outputBox = New-Object System.Windows.Forms.TextBox 
$outputBox.Location = New-Object System.Drawing.Size(10,150) 
$outputBox.Size = New-Object System.Drawing.Size(565,200) 
$outputBox.MultiLine = $True 
$outputBox.ScrollBars = "Vertical" 
$Form.Controls.Add($outputBox) 

############################################## end text fields

############################################## Start buttons

$Button = New-Object System.Windows.Forms.Button 
$Button.Location = New-Object System.Drawing.Size(400,30) 
$Button.Size = New-Object System.Drawing.Size(80,40) 
$Button.Text = "Search" 
$Button.Add_Click({pingInfo}) 
$Form.Controls.Add($Button) 

############################################## end buttons

$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()