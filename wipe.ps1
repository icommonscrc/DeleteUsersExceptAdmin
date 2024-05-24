
# Script to wipe data from all user directories except the local administrator
 
 
# Get the local administrator's username

$adminUsername = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split("\")[1]
 
# Define directories to wipe

$usersDirectory = "C:\Users"

$directories = Get-ChildItem $usersDirectory | Where-Object { $_.Name -ne $adminUsername } | ForEach-Object { $_.FullName }
 
# Function to securely delete files

function SecureDelete {

    param (

        [string]$Path

    )

    if (Test-Path $Path) {

        Write-Host "Wiping $Path"

        $items = Get-ChildItem -Path $Path -File -Recurse

        foreach ($item in $items) {

            $item.Delete()

        }

        Remove-Item $Path -Recurse -Force

    } else {

        Write-Host "$Path does not exist"

    }

}
 
# Wipe each user directory

foreach ($dir in $directories) {

    SecureDelete $dir

}
 
Write-Host "Data wipe complete"