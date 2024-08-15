<#
.SYNOPSIS
Get all share link permissions for a site

.DESCRIPTION
This script takes a SharePoint site url and returns all of the permissions for all the lists in that site

.PARAMETER SiteUrl
The URL of the SharePoint site to gather permissions from

.EXAMPLE
An example

.NOTES
This script used the following script as a reference:

- https://www.sharepointdiary.com/2020/11/generate-shared-links-permission-report-in-sharepoint-online.html
#>
function Get-PnPShareLinkPermissions {
    [CmdletBinding()]
    param (
        # Site URL
        [Parameter(Mandatory)]
        [string]
        $Url,
        # Tenant Admin URL
        [Parameter(Mandatory)]
        [string]
        $TenantAdminUrl
    )
    
    begin {
        #Connect to PnP Online
        $Connection = Connect-PnPOnline -Url $Url -Interactive -ReturnConnection
        # $Ctx = Get-PnPContext
        $ShareLinks = 0
    }
    
    process {
        # Get all document libraries that have items in them
        $lists = Get-PnPList -Connection $Connection | Where-Object {$_.ItemCount -gt 0 -and $_.BaseType -eq "DocumentLibrary"}
        $CounterA = 1
        $Results = foreach ($List in $Lists) {
            Write-Progress -PercentComplete ($CounterA / $Lists.Count * 100) -Activity "Reviewing list: '$($List.Title)'" -Status "Processing List $CounterA of $($Lists.Count)" -Id 1
            Write-Verbose "`tList: $($List.Title)"
            #Get all list items in batches
            $ListItems = Get-PnPListItem -List $List -PageSize 2000 -Connection $Connection
            # Get the "HasUniqueRoleAssignments" value for each list. It is automatically added back to the list when queried
            $ListItems | ForEach-Object {Get-PnPProperty -ClientObject $_ -Property "HasUniqueRoleAssignments" -Connection $Connection | Out-Null}
            # Iterate through each list item that has unique assignments
            $CounterB = 1
            ForEach($Item in $ListItems | Where-Object {$_.HasUniqueRoleAssignments -eq $true}) {
                Write-Progress -PercentComplete ($CounterB / $ListItems.Count * 100) -Activity "Getting Item from '$($Item.FieldValues["FileRef"])'" -Status "Processing Item $CounterB of $($ListItems.Count)" -Id 2 -ParentId 1
                Write-Verbose "`t`tItem: $($Item.FieldValues["FileRef"])"
                #Get Users and Assigned permissions
                $RoleAssignments = Get-PnPProperty -ClientObject $Item -Property RoleAssignments -Connection $Connection
                # Add the member details to $RoleAssignments
                $RoleAssignments | ForEach-Object {Get-PnPProperty -ClientObject $_ -Property RoleDefinitionBindings, Member}
                $CounterC = 1
                # Iterate through each $RoleAssignment sharing link
                ForEach($RoleAssignment in $RoleAssignments | Where-Object {$_.Member.Title -like "SharingLinks*"}) {
                    Write-Progress -PercentComplete ($CounterC / $RoleAssignments.Count * 100) -Activity "Getting Roles from '$RoleAssignments'" -Status "Processing Role $CounterC of $($RoleAssignments.Count)" -Id 3 -ParentId 2
                    #Get list of users 
                    $Users = Get-PnPProperty -ClientObject ($RoleAssignment.Member) -Property Users -ErrorAction SilentlyContinue -Connection $Connection
                    #Get Access type
                    $AccessType = $RoleAssignment.RoleDefinitionBindings.Name
                    If ($null -ne $Users) {
                        ForEach ($User in $Users) {
                            #Collect the data
                            $Properties = [ordered]@{ 
                                Name  = $Item.FieldValues["FileLeafRef"]            
                                RelativeURL = $Item.FieldValues["FileRef"]
                                FileType = $Item.FieldValues["File_x0020_Type"]
                                User = $user
                                Access = $AccessType
                            }
                            New-Object PSObject -Property $properties
                            $ShareLinks++
                            Write-Progress -Activity "$ShareLinks Share links found" -ParentId 3 -Id 4
                        }
                    }
                    $CounterC++
                }
                $CounterB++
            }
            $CounterA++
        }
        
    }
    
    end {
        return $Results
    }
}
