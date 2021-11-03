function Get-DCBadPasswords {
    param (
        [string]$DC   
    )
    
    Get-WinEvent -ComputerName $DC -FilterHashtable @{Logname='Security'; id=4740} | Select-Object TimeCreated,@{ Label="User"; Expression={$_.Properties[0].value} },@{ Label="Origin"; Expression={$_.Properties[1].value}}

}