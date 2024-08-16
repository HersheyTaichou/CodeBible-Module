# This is the master file for the module. Currently all commands are all in dedicated files.

function Get-PnPOnlineConnection {
    [CmdletBinding()]
    param (
        # URL to the SharePoint admin site.
        [Parameter()]
        [string]
        $TenantAdminUrl,
        # URL to the SharePoint site to connect to.
        [Parameter(Mandatory)]
        [string]
        $Url
    )
    
    begin {
        
    }
    
    process {
        $Parameters = @{
            'Url' = $Url
            'Interactive' = $true 
            'ReturnConnection' = $true
        }
        if ($TenantAdminUrl) {
            $Parameters += @{
                "TenantAdminUrl" = $TenantAdminUrl
            }
        }
        $Connection = Connect-PnPOnline @Parameters
    }
    
    end {
        return $Connection
    }
}