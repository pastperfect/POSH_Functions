function Write-Log {
    <#
    .SYNOPSIS
    Writes a message with a timestamp to a log file.
    
    .DESCRIPTION
    Writes a message with a timestamp to a log file. Mainly used by powershell backed SCCM install scripts
    
    .PARAMETER Path
    Full path to log file, defaults to C:\ProgramData\%Scriptname%.log

    .PARAMETER Message
    The message to write to the log

    .PARAMETER NoTimeStamp
    Removed the timestamp from the log entry 
    
    .PARAMETER Overwrite
    Removed the timestamp from the log entry   
        
    .EXAMPLE
    Write-Log -Path C:\ProgramData\SoftwareInstall.log -Message "Install was successful"

    Writes the current date-time then the message to SoftwareInstall.log file in C:\ProgramData

    #>
    [CmdletBinding(DefaultParameterSetName='Default')]
    param (
        [parameter(Position=0,
        Mandatory=$False,
        ValueFromPipeline=$true,
        ParameterSetName='Default')]
        [string]$Path = "C:\ProgramData\" + (split-path $MyInvocation.PSCommandPath -Leaf) + ".log",

        [parameter(Position=1,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ParameterSetName='Default')]
        [String]$Message,

        [parameter(Position=2,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ParameterSetName='Default')]
        [Switch]$NoTimestamp,

        [parameter(Position=2,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ParameterSetName='Default')]
        [Switch]$Overwrite

    )

    begin {   
        $RegPath = "Registry::$Path"
    }
    process {
        $Entry_Value = (Get-ItemProperty -Path $RegPath -ErrorAction SilentlyContinue).$Item

        if ($Entry_Value -eq $Value) { 
            $Output = $true        
        } else {
            $Output = $false
        }

    }
    end {
        $Output
    }
}