<# Azure MFA Report Generation Script V0.1(Silent Mode)
.SYNOPSIS
    Generate MFA Report for Azure AD
.DESCRIPTION
    This script generates an MFA (Multi-Factor Authentication) report for Azure Active Directory users.
.NOTES
    File Name      : Generate-MfaReport.ps1
    Author         : Anand P
    Prerequisite   : MsIdentityTools module
#>
# Define the path for the report file
$reportPath = "C:\MFA_Report.xlsx"

# Suppress verbose output
#$VerbosePreference = 'SilentlyContinue'

# Install the MsIdentityTools module if not already installed
if (-not (Get-Module -ListAvailable -Name MsIdentityTools)) {
    Install-Module MsIdentityTools -Scope CurrentUser -Force -ErrorAction SilentlyContinue
}

# Import the MsIdentityTools module
Import-Module MsIdentityTools -ErrorAction SilentlyContinue

# Connect to Microsoft Graph with required permissions
try {
    Connect-MgGraph -Scopes Directory.Read.All, AuditLog.Read.All, UserAuthenticationMethod.Read.All -NoWelcome -ErrorAction Stop
} catch {
    Write-Error "Failed to connect to Microsoft Graph. Error: $_"
    exit
}

# Generate and export the MFA report
try {
    Export-MsIdAzureMfaReport -ExcelWorkbookPath $reportPath -ErrorAction Stop
    Write-Host "MFA report successfully generated and saved to $reportPath"
} catch {
    Write-Error "Failed to generate MFA report. Error: $_"
} finally {
    # Disconnect from Microsoft Graph silently
    $null = Disconnect-MgGraph -ErrorAction SilentlyContinue
}