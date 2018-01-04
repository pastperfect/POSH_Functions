function Export-SessionHistory {
    <#
    .SYNOPSIS
    Exports Powershell Session history to a comma seperated file
    
    .DESCRIPTION
    Exports Powershell Session history to a comma seperated file
    
    .PARAMETER Path
    Folder the file should be stored in

    .PARAMETER Filename
    Name and extension of the file

    .PARAMETER Force
    Force the creation of the file, this will create the output folder if it doesnt exist.
    It will also delete an existing file if it is there.
        
    .EXAMPLE
    Export-SessionHistory -Path C:\Temp -Filename SessionHistory.txt
    Exports the session history to C:\Temp\SessionHistory.txt

    #>
    [CmdletBinding(DefaultParameterSetName='Default')]
    param (
        [parameter(Position=0,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ParameterSetName='Default')]
        [string]$Path,

        [parameter(Position=1,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ParameterSetName='Default')]
        [String]$FileName,

        [parameter(Position=3,
        ValueFromPipeline=$true,
        ParameterSetName='Default')]
        [Switch]$Force
    )

    begin {

        if ($Path -notmatch '.+?\\$') { $Path = $Path + "\" }

        $OutputFile = $Path + $FileName

        if (!(Test-Path $Path)) {

            if ($Force.IsPresent) {
                New-Item -ItemType Directory -Path $Path | Out-Null
                New-Item -ItemType File -Path $Path -Name $FileName | Out-Null
            } else {
                throw "Path not found" 
            }       

        } else {
            
            if (!(Test-Path $OutputFile)) {
                New-Item -ItemType File -Path $Path -Name $FileName | Out-Null           
            } else {
                if ($Force.IsPresent) {
                    Remove-Item $OutputFile -Force | Out-Null
                    New-Item -ItemType File -Path $Path -Name $FileName | Out-Null
                } else {
                    throw "File already exists" 
                }       
            }
        }       
        
    }
    process {

       $SessionHistory = Get-History | Select-Object * 

    }
    end {

        $SessionHistory | Export-Csv -Path $OutputFile -NoTypeInformation

    }
}