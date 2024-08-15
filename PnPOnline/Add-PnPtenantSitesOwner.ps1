<#
.SYNOPSIS
Add an account as an admin on all sites

.DESCRIPTION
This script will log into the SharePoint admin center, gather a list of all the sites under the account, and then add the listed user as an admin to each site.

.PARAMETER Owner
The email address of the user to add as an admin

.PARAMETER TenantAdminUrl
The URL of the SharePoint admin site. Typically in the format of https://domain-admin.sharepoint.com/

.EXAMPLE
Add-PnPtenantSitesOwner -Owner admin@domain.com -TenantAdminUrl https://domain-admin.sharepoint.com/

.NOTES
General notes
#>
function Add-PnPtenantSitesOwner {
    [CmdletBinding()]
    param (
        # User to add as an admin
        [Parameter()]
        [string]
        $Owner,
        # The SharePoint admin portal URL
        [Parameter()]
        [string]
        $TenantAdminUrl
    )
    
    begin {
        Write-Verbose "Please login to Office 365 with a SharePoint admin account."
        $Connection = Connect-PnPOnline -TenantAdminUrl $TenantAdminUrl -Url $TenantAdminUrl -Interactive -ReturnConnection
        $Sites = Get-PnPTenantSite -Connection $Connection 
    }
    
    process {
        $CounterA = 1
        foreach ($Site in $Sites) {
            Write-Progress -PercentComplete ($CounterA / ($Sites.Count) * 100) -Activity "Adding owner to: '$($Site.Url)'" -Status "Processing Site $CounterA of $($Sites.Count)" -Id 0
            Set-PnPTenantSite -Identity $Site.Url -Owners $Owner -Connection $Connection
            $CounterA++
        }
    }
    
    end {
        
    }
}