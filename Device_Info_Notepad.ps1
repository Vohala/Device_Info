$outputFile = "$env:USERPROFILE\Desktop\SystemInfo.txt"

Add-Content -Path $outputFile -Value "`n========================================"
Add-Content -Path $outputFile -Value "      *****************************"
Add-Content -Path $outputFile -Value "      *                           *"
Add-Content -Path $outputFile -Value "      *    Developed by Vohala    *"
Add-Content -Path $outputFile -Value "      *                           *"
Add-Content -Path $outputFile -Value "      *****************************"
Add-Content -Path $outputFile -Value "========================================"
Add-Content -Path $outputFile -Value "System Information Report" -Force
Add-Content -Path $outputFile -Value "========================================"

$processor = Get-WmiObject Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, Manufacturer
Add-Content -Path $outputFile -Value "`nProcessor Information:"
$processor | ForEach-Object {
    Add-Content -Path $outputFile -Value "Name: $($_.Name)"
    Add-Content -Path $outputFile -Value "Manufacturer: $($_.Manufacturer)"
    Add-Content -Path $outputFile -Value "Cores: $($_.NumberOfCores)"
    Add-Content -Path $outputFile -Value "Logical Processors: $($_.NumberOfLogicalProcessors)"
}

$cpuGen = ($processor.Name -replace '[^0-9]', '')[0..1] -join '' 
$cpuGenNumber = [int]$cpuGen

Add-Content -Path $outputFile -Value "`nDetected CPU Generation: $cpuGen"

switch ($cpuGenNumber) {
    {$_ -eq 2 -or $_ -eq 3} { 
        Add-Content -Path $outputFile -Value "`nCompatible Motherboards: H61, Z77 (Supports LGA 1155 Socket, DDR3 RAM)"
    }
    {$_ -eq 6 -or $_ -eq 7} { 
        Add-Content -Path $outputFile -Value "`nCompatible Motherboards: Z170, Z270 (Supports LGA 1151 Socket, DDR4 RAM)"
    }
    {$_ -eq 8 -or $_ -eq 9} { 
        Add-Content -Path $outputFile -Value "`nCompatible Motherboards: Z370, Z390 (Supports LGA 1151 Socket, DDR4 RAM)"
    }
    {$_ -eq 10 -or $_ -eq 11} { 
        Add-Content -Path $outputFile -Value "`nCompatible Motherboards: Z490, Z590 (Supports LGA 1200 Socket, DDR4 RAM)"
    }
    {$_ -eq 12 -or $_ -eq 13} { 
        Add-Content -Path $outputFile -Value "`nCompatible Motherboards: Z690, Z790 (Supports LGA 1700 Socket, DDR4 or DDR5 RAM)"
    }
    default {
        Add-Content -Path $outputFile -Value "`nCould not determine compatible motherboard."
    }
}

$ram = Get-WmiObject Win32_PhysicalMemory | Select-Object Manufacturer, Capacity, MemoryType, DeviceLocator
$ramTypeMap = @{
    20 = "DDR";
    21 = "DDR2";
    22 = "DDR2 FB-DIMM";
    24 = "DDR3";
    26 = "DDR4";
    27 = "DDR5";
}

Add-Content -Path $outputFile -Value "`nRAM Information (per slot):"
foreach ($module in $ram) {
    $ramType = $ramTypeMap[$module.MemoryType]
    $capacityGB = [math]::round(($module.Capacity / 1GB), 2)
    Add-Content -Path $outputFile -Value "Slot: $($module.DeviceLocator), Capacity: $capacityGB GB, Type: $ramType"
}

$baseboard = Get-WmiObject Win32_BaseBoard | Select-Object Product, Manufacturer
$totalSlots = (Get-WmiObject Win32_PhysicalMemoryArray).MemoryDevices
Add-Content -Path $outputFile -Value "`nMotherboard: $($baseboard.Manufacturer) - $($baseboard.Product)"
Add-Content -Path $outputFile -Value "Total RAM slots available on motherboard: $totalSlots"

$storageDevices = Get-PhysicalDisk | Select-Object DeviceID, MediaType, Size
Add-Content -Path $outputFile -Value "`nStorage Information:"
$storageDevices | ForEach-Object {
    $sizeGB = [math]::round($_.Size / 1GB, 2)
    Add-Content -Path $outputFile -Value "DeviceID: $($_.DeviceID), Type: $($_.MediaType), Size: $sizeGB GB"
}

$gpu = Get-WmiObject Win32_VideoController | Select-Object Name, AdapterRAM, VideoProcessor
Add-Content -Path $outputFile -Value "`nGraphics Card Information:"
$gpu | ForEach-Object {
    $adapterRAMGB = [math]::round($_.AdapterRAM / 1GB, 2)
    Add-Content -Path $outputFile -Value "Name: $($_.Name), Video Processor: $($_.VideoProcessor), RAM: $adapterRAMGB GB"
}

Add-Content -Path $outputFile -Value "`n========================================"
Add-Content -Path $outputFile -Value "End of Report"


Write-Host "System information saved to $outputFile"
