$outputFile = "$env:USERPROFILE\Desktop\SystemInfo.html"

Add-Content -Path $outputFile -Value "<html>" -Force
Add-Content -Path $outputFile -Value "<head>"
Add-Content -Path $outputFile -Value "<style>"
Add-Content -Path $outputFile -Value "body { font-family: Arial, sans-serif; background-color: #f0f2f5; color: #333; }"
Add-Content -Path $outputFile -Value "h1 { text-align: center; color: #f25f5c; font-size: 3em; text-shadow: 2px 2px 5px #555; }"
Add-Content -Path $outputFile -Value "h2 { color: #fff; background-color: #242582; padding: 10px; font-size: 1.8em; border-radius: 8px; }"
Add-Content -Path $outputFile -Value "p, table { font-size: 1.2em; margin: 15px; }"
Add-Content -Path $outputFile -Value "table { width: 100%; border-collapse: collapse; }"
Add-Content -Path $outputFile -Value "td, th { padding: 10px; border: 1px solid #ddd; text-align: left; }"
Add-Content -Path $outputFile -Value "th { background-color: #f25f5c; color: white; }"
Add-Content -Path $outputFile -Value ".branding { text-align: center; padding: 20px; margin-top: 30px; }"
Add-Content -Path $outputFile -Value ".branding span { font-size: 1.8em; background: linear-gradient(90deg, #f25f5c, #f9a828, #5d50fe); padding: 10px; border-radius: 10px; color: white; box-shadow: 0 4px 10px rgba(0,0,0,0.3); animation: glow 2s infinite alternate; }"
Add-Content -Path $outputFile -Value "@keyframes glow { from { text-shadow: 0 0 10px #fff, 0 0 20px #ff9, 0 0 30px #f25f5c; } to { text-shadow: 0 0 20px #5d50fe, 0 0 30px #f9a828, 0 0 40px #ff9; } }"
Add-Content -Path $outputFile -Value "</style>"
Add-Content -Path $outputFile -Value "</head>"
Add-Content -Path $outputFile -Value "<body>"

Add-Content -Path $outputFile -Value "<h1>System Information Report</h1>"
Add-Content -Path $outputFile -Value "<hr>"

$processor = Get-WmiObject Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, Manufacturer
Add-Content -Path $outputFile -Value "<h2>Processor Information</h2>"
$processor | ForEach-Object {
    Add-Content -Path $outputFile -Value "<p><strong>Name:</strong> $($_.Name)</p>"
    Add-Content -Path $outputFile -Value "<p><strong>Manufacturer:</strong> $($_.Manufacturer)</p>"
    Add-Content -Path $outputFile -Value "<p><strong>Cores:</strong> $($_.NumberOfCores)</p>"
    Add-Content -Path $outputFile -Value "<p><strong>Logical Processors:</strong> $($_.NumberOfLogicalProcessors)</p>"
}

$cpuGen = ($processor.Name -replace '[^0-9]', '')[0..1] -join '' 
$cpuGenNumber = [int]$cpuGen

Add-Content -Path $outputFile -Value "<h2>Detected CPU Generation: $cpuGen</h2>"

switch ($cpuGenNumber) {
    {$_ -eq 2 -or $_ -eq 3} { 
        Add-Content -Path $outputFile -Value "<p><strong>Compatible Motherboards:</strong> H61, Z77 (Supports LGA 1155 Socket, DDR3 RAM)</p>"
    }
    {$_ -eq 6 -or $_ -eq 7} { 
        Add-Content -Path $outputFile -Value "<p><strong>Compatible Motherboards:</strong> Z170, Z270 (Supports LGA 1151 Socket, DDR4 RAM)</p>"
    }
    {$_ -eq 8 -or $_ -eq 9} { 
        Add-Content -Path $outputFile -Value "<p><strong>Compatible Motherboards:</strong> Z370, Z390 (Supports LGA 1151 Socket, DDR4 RAM)</p>"
    }
    {$_ -eq 10 -or $_ -eq 11} {
        Add-Content -Path $outputFile -Value "<p><strong>Compatible Motherboards:</strong> Z490, Z590 (Supports LGA 1200 Socket, DDR4 RAM)</p>"
    }
    {$_ -eq 12 -or $_ -eq 13} { 
        Add-Content -Path $outputFile -Value "<p><strong>Compatible Motherboards:</strong> Z690, Z790 (Supports LGA 1700 Socket, DDR4 or DDR5 RAM)</p>"
    }
    default {
        Add-Content -Path $outputFile -Value "<p><strong>Compatible Motherboards:</strong> Could not determine compatible motherboard.</p>"
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

Add-Content -Path $outputFile -Value "<h2>RAM Information (per slot)</h2>"
Add-Content -Path $outputFile -Value "<table><tr><th>Slot</th><th>Capacity (GB)</th><th>Type</th></tr>"
foreach ($module in $ram) {
    $ramType = $ramTypeMap[$module.MemoryType]
    $capacityGB = [math]::round(($module.Capacity / 1GB), 2)
    Add-Content -Path $outputFile -Value "<tr><td>$($module.DeviceLocator)</td><td>$capacityGB GB</td><td>$ramType</td></tr>"
}
Add-Content -Path $outputFile -Value "</table>"

$baseboard = Get-WmiObject Win32_BaseBoard | Select-Object Product, Manufacturer
$totalSlots = (Get-WmiObject Win32_PhysicalMemoryArray).MemoryDevices
Add-Content -Path $outputFile -Value "<h2>Motherboard Information</h2>"
Add-Content -Path $outputFile -Value "<p><strong>Motherboard:</strong> $($baseboard.Manufacturer) - $($baseboard.Product)</p>"
Add-Content -Path $outputFile -Value "<p><strong>Total RAM slots available:</strong> $totalSlots</p>"

$storageDevices = Get-PhysicalDisk | Select-Object DeviceID, MediaType, Size
Add-Content -Path $outputFile -Value "<h2>Storage Information</h2>"
Add-Content -Path $outputFile -Value "<table><tr><th>DeviceID</th><th>Type</th><th>Size (GB)</th></tr>"
$storageDevices | ForEach-Object {
    $sizeGB = [math]::round($_.Size / 1GB, 2)
    Add-Content -Path $outputFile -Value "<tr><td>$($_.DeviceID)</td><td>$($_.MediaType)</td><td>$sizeGB GB</td></tr>"
}
Add-Content -Path $outputFile -Value "</table>"

$gpu = Get-WmiObject Win32_VideoController | Select-Object Name, AdapterRAM, VideoProcessor
Add-Content -Path $outputFile -Value "<h2>Graphics Card Information</h2>"
$gpu | ForEach-Object {
    $adapterRAMGB = [math]::round($_.AdapterRAM / 1GB, 2)
    Add-Content -Path $outputFile -Value "<p><strong>Name:</strong> $($_.Name)</p>"
    Add-Content -Path $outputFile -Value "<p><strong>Video Processor:</strong> $($_.VideoProcessor)</p>"
    Add-Content -Path $outputFile -Value "<p><strong>RAM:</strong> $adapterRAMGB GB</p>"
}

Add-Content -Path $outputFile -Value "<div class='branding'>"
Add-Content -Path $outputFile -Value "<span>Developed by Vohala</span>"

Add-Content -Path $outputFile -Value "</body>"
Add-Content -Path $outputFile -Value "</html>"

Write-Host "System information saved to $outputFile"
