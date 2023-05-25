function New-HomeLabVM {
    param (
        [Parameter(Mandatory=$true)]
        [string]$VMName,
        
        [Parameter(Mandatory=$true)]
        [int]$MemoryGB,
        
        [Parameter(Mandatory=$true)]
        [int]$CPUCount
    )

    # Check if running as administrator
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        throw "You need to run this script as an Administrator."
    }

    # Check if a virtual switch exists
    if ((Get-VMSwitch).count -eq 0) {
        throw "No virtual switch found. Please create a virtual switch in Hyper-V Manager."
    }

    # Check if VM already exists
    $existingVM = Get-VM -Name $VMName -ErrorAction SilentlyContinue
    if ($null -eq $existingVM) {
        # Create the VM with the given name and memory
        $newVM = New-VM -Name $VMName -MemoryStartupBytes ($MemoryGB * 1GB) -NewVHDPath "$env:USERPROFILE\HyperV\$VMName\$VMName.vhdx" -NewVHDSizeBytes 50GB -Generation 2 -Switch (Get-VMSwitch)[0].Name

        # Enable nested virtualization
        #Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true -Verbose
        
        # Set the number of CPU cores
        Set-VMProcessor -VMName $VMName -Count $CPUCount
    } else {
        Write-Output "VM with name $VMName already exists."
    }

    # Path to the ISO file
    $isoPath = "D:\Dev\ISO\2019.iso"

    # Check if the ISO file exists
    if (-not (Test-Path $isoPath)) {
        throw "ISO file not found at $isoPath. Please check the path and try again."
    }

    # Attach the ISO to the VM's DVD drive only if the drive doesn't exist
    $existingDVDDrive = Get-VMDvdDrive -VMName $VMName -ErrorAction SilentlyContinue
    if ($null -eq $existingDVDDrive) {
        Add-VMDvdDrive -VMName $VMName -Path $isoPath
        # Change the boot order
        $firmware = Get-VMFirmware -VMName $VMName
        $bootOrder = $firmware.BootOrder
        $dvddriveRow = $firmware.BootOrder | Where-Object { $_.Device -like 'DvdDrive*' }
        Set-VMFirmware -VMName $VMName -FirstBootDevice $dvddriveRow

    } else {
        Write-Output "DVD Drive already exists on VM $VMName."
    }

    # Check if the VM is running
    if ((Get-VM -Name $VMName).State -ne "Running") {
        # Start the VM
        Start-VM -Name $VMName
    } else {
        Write-Output "VM $VMName is already running."
    }
}