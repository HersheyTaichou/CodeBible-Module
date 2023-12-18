<#
.SYNOPSIS
Run a repair of Windows

.DESCRIPTION
Uses DISM, SFC and CHKDSK to check for issues in Windows and repair them, if possible.

.EXAMPLE
Repair-WindowsInstall

.NOTES
General notes
#>
function Repair-WindowsInstall {
    [CmdletBinding()]
    param ()

    process {
        # Remove any unneeded files from the local component store
        ## Same as "DISM /online /Cleanup-Image /StartComponentCleanup"
        Repair-WindowsImage -Online -StartComponentCleanup
        # Restores health of the windows image and component store
        ## Same as "DISM /Online /Cleanup-Image /RestoreHealth"
        Repair-WindowsImage -Online -RestoreHealth
        # Checks for other issues now that DISM is done
        sfc /scannow
        # Runs an online scan for issues with CHKDSK 
        ## Same as chkdsk /scan C:
        Repair-Volume -DriveLetter C -Scan
    }

}

# Repair-WindowsInstall