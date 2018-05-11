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
    Force it to overwrite the log defined in the path  
        
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
        Mandatory=$False,
        ValueFromPipeline=$true,
        ParameterSetName='Default')]
        [Switch]$NoTimestamp,

        [parameter(Position=3,
        Mandatory=$False,
        ValueFromPipeline=$true,
        ParameterSetName='Default')]
        [Switch]$Overwrite

    )

    begin {   
        $TimeStamp = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    }
    process {
        if (!($NoTimestamp)) {
            $LogEntry = "$TimeStamp : $Message"
        } else {
            $LogEntry = $Message
        }
    }
    end {
        if (!($Overwrite)) {
            Write-Output $LogEntry | Out-File $Path -Append
        } else {
            Write-Output $LogEntry | Out-File $Path 
        }
    }
}