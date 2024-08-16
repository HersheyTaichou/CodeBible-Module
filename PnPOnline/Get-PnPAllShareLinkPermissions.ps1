<#
.SYNOPSIS
Get all share permissions accross all sites

.DESCRIPTION
This script will connect to SharePoint online and gather all of the unique share permissions accross all sites

.PARAMETER TenantAdminUrl
The URL of the SharePoint admin site. Typically in the format of https://domain-admin.sharepoint.com/

.PARAMETER MinimumSize
This will filter the sites checked to a minimum size, to avoid checking sites that have no documents in them. 

.EXAMPLE
An example

.NOTES
This script used the following scripts as a reference:

- <https://www.sharepointdiary.com/2020/11/generate-shared-links-permission-report-in-sharepoint-online.html>
- <https://www.sharepointdiary.com/2017/04/sharepoint-online-get-storage-size-quota-report-using-powershell.html>
#>
function Get-PnPAllShareLinkPermissions {
    [CmdletBinding()]
    param (
        # The SharePoint admin portal URL
        [Parameter(Mandatory)]
        [string]
        $TenantAdminUrl,
        # The SharePoint admin portal URL
        [Parameter()]
        [int]
        $MinimumSize
    )
    
    begin {
        Write-Verbose "Please login to Office 365 with a SharePoint admin account."
        #$Connection = Get-PnPOnlineConnection -Url $Url -TenantAdminUrl $TenantAdminUrl
        $Connection = Connect-PnPOnline -TenantAdminUrl $TenantAdminUrl -Url $Url -Interactive -ReturnConnection
        if ($MinimumSize) {
            $Sites = Get-PnPTenantSite -Connection $Connection | Where-Object {$_.StorageUsageCurrent -ge $MinimumSize}
        } else {
            $Sites = Get-PnPTenantSite -Connection $Connection
        }
    }
    
    process {
        $CounterA = 1
        $ShareLinks  = 0
        $Results = foreach ($Site in $Sites) {
            Write-Progress -PercentComplete ($CounterA / ($Sites.Count) * 100) -Activity "Reviewing Site: '$($Site.Url)'" -Status "Processing Site $CounterA of $($Sites.Count)" -Id 0
            Write-Verbose "Site: $($Site.Url)"
            $PnPShareLinkPermissions = Get-PnPShareLinkPermissions -Url $Site.Url -TenantAdminUrl $TenantAdminUrl
            $ShareLinks += $PnPShareLinkPermissions.Count
            $PnPShareLinkPermissions
            $CounterA++
        }
    }
    
    end {
        return $Results
    }
}
