function Test-RegistryEntry {
    <#
    .SYNOPSIS
    Tests a registry entry for a desired value.
    
    .DESCRIPTION
    Tests a registry entry for a desired value and returns a boolean response, if the registry path or item does not exist it will return false in the output.
    
    .PARAMETER Path
    The full registry path

    .PARAMETER Item
    The registry item

    .PARAMETER Value
    The desired value of the registry item
        
    .EXAMPLE
    Test-RegistryEntry -path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" -Item install -Value 1

    Checks if the Install entry under "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" equals 1, if it does it will return $True if not it will return $False.

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
        [String]$Item,

        [parameter(Position=2,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ParameterSetName='Default')]
        [String]$Value

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