# Device_Info_Scripts

This repository contains PowerShell scripts designed to collect and display essential system information from Windows machines. The scripts generate detailed reports in either HTML or plain text formats, making it easier for users to understand their system’s hardware specifications.
Features

    Detailed System Information:
        Processor details (name, cores, logical processors).
        RAM details (type, capacity, and number of slots).
        Storage information (SSD/HDD, capacity).
        Motherboard information (manufacturer, product).
        Graphics card details.
    Processor Generation Detection:
        Automatically detects your CPU generation and lists compatible motherboards based on the detected generation.
    Report Generation:
        Device_info_html.ps1: Generates an HTML report with modern styling, colors, animations, and branding.
        Device_Info_Notepad.ps1: Outputs the system information in a simple text file format.

Usage

    Clone or download the repository to your local machine.
    Open PowerShell with administrative privileges.
    Run the desired script:
        HTML Report: Device_info_html.ps1 - Outputs a styled HTML report (SystemInfo.html).
        Text Report: Device_Info_Notepad.ps1 - Outputs a plain text report (SystemInfo.txt).
    The reports will be saved to your desktop by default.

Output Formats

    HTML Report: A well-formatted, colorful report with animations and a branded footer ("Developed by Vohala"). Perfect for a more polished presentation of system details.
    Plain Text Report: A simple, clean text-based report providing the same detailed system information, ideal for quick diagnostics.
