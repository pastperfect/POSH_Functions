<#
    Script Name:        UpdateOlgaLicence.ps1
    Current Revision:	1.0.0
    Description:		Update OLGA License environmental variables after the loss of the Glasgow license server, as the exact variables are unknown its a bit of a 
                        scattergun approach. Not the greatest script and could definitely be improved with more time to work on it!

        1.0 :	Initial script creation

            Author: 	Ricky Burgess
            Company:	Xodus Group
            Date: 		30/05/2019

#>

$OldServer = "XLICENSE-GLA"
$NewServer = "XLICENSE2"

#* System Variables

$System_Variables = Get-ItemProperty "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment"
$System_ApplicableKeys = $System_Variables.PSObject.Properties | Where membertype -eq "NoteProperty" | where value -like "*$OldServer*" | Select-Object Name,Value

Foreach ( $key in $System_ApplicableKeys ) {

	$NewValue = $Key.Value -Replace "$OldServer","$NewServer"
	
	Set-Itemproperty -path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name $Key.Name -value $NewValue

}

#* User Variables

$User_Variables = (Get-ChildItem "Registry::HKEY_USERS\" | Where-Object {($_.Name.Length -gt 20) -and ($_.Name -notlike "*_Classes")}).Name

foreach ($User in $User_Variables) {
    
    $User_Key = "Registry::$user\Environment"

    $Environment_Details = Get-ItemProperty $User_Key

    $User_ApplicableKeys = $Environment_Details.PSObject.Properties | Where membertype -eq "NoteProperty" | where value -like "*$OldServer*" | Select-Object Name,Value

    Foreach ( $key in $User_ApplicableKeys ) {

        $NewValue = $Key.Value -Replace "$OldServer","$NewServer"
        
        Set-Itemproperty -path $User_Key -Name $Key.Name -value $NewValue
    
    }

}

if (!(Test-Path 'HKLM:\Software\XodusIT')) {
    New-Item 'HKLM:\Software\XodusIT' -Force | Out-Null
}
New-ItemProperty -Path 'HKLM:\Software\XodusIT' -Name "Olga-LicenseUpdate" -Value 1 -PropertyType String -Force | Out-Null