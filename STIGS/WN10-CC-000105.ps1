<#
.SYNOPSIS
    This PowerShell script ensures web publishing and online ordering wizards are prevented from downloading a list of providers.
.NOTES
    Author          : Steve Perchard
    GitHub          : github.com/steveperchard
    Last Modified   : 20/11/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000105
.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STIG-ID-WN10-CC-000105).ps1 
#>

# Define the registry path and value information
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$ValueName = "NoWebServices"
$ValueType = "DWord"
$ValueData = 1

# Check if the registry path exists, and create it if it doesn't
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
    Write-Verbose "Registry path '$RegistryPath' created." -Verbose
}

# Check if the value already exists
if (-not (Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue)) {
    # Create the registry value
    New-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ValueData -PropertyType $ValueType -Force | Out-Null
    Write-Verbose "Registry value '$ValueName' created with value '$ValueData'." -Verbose
} else {
    # Value exists, check if it is the correct value.
    $CurrentValue = (Get-ItemProperty -Path $RegistryPath -Name $ValueName).NoWebServices
    if ($CurrentValue -ne $ValueData){
        Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ValueData
        Write-Verbose "Registry value '$ValueName' updated to '$ValueData'." -Verbose
    }
    else{
        Write-Verbose "Registry value '$ValueName' already exists and is equal to '$ValueData'." -Verbose
    }

}