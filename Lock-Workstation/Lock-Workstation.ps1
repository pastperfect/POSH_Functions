Function Lock-Workstation {
    <#
    .SYNOPSIS
    Locks the local windows workstation
    
    .DESCRIPTION
    Locks the local windows workstation
        
    .EXAMPLE
    Lock-Workstation
    Locks the windows workstation

    #>
    $signature = @"  
       [DllImport("user32.dll", SetLastError = true)]  
       public static extern bool LockWorkStation();  
"@  
       $LockWorkStation = Add-Type -memberDefinition $signature -name "Win32LockWorkStation" -namespace Win32Functions -passthru  
   
       $LockWorkStation::LockWorkStation()|Out-Null
   }