# This script converts raw fortigate logs to a cleaner format, adding headers and arranging fields to a more human-readable format.
# It prompts the user for the filename to convert, defaulting to "fortigate.csv" if it exists, or "logs.csv" if either exists.
# It then outputs the converted logs to a new file with "-converted" appended to the filename.

# Default filenames
$defaultFiles = @("logs.csv", "fortigate.csv")
$sourcePath = ""

# Determine the default if it exists
$suggestedDefault = ""
foreach ($df in $defaultFiles) {
    if (Test-Path $df) {
        $suggestedDefault = $df
        break
    }
}

# Determine the default
$displayDefault = if ($suggestedDefault) { $suggestedDefault } else { "fortigate.csv" }

# Prompt user
$userInput = Read-Host "Enter the filename to convert (default: $displayDefault)"
$sourcePath = if ([string]::IsNullOrWhiteSpace($userInput)) { $displayDefault } else { $userInput }


# Validate source exists
if (-not (Test-Path $sourcePath)) {
    Write-Error "File not found: $sourcePath"
    exit
}

# Determine output path: append "-converted" before extension
$sourceFile = Get-Item $sourcePath
$outputPath = Join-Path $sourceFile.DirectoryName "$($sourceFile.BaseName)-converted$($sourceFile.Extension)"

# Header exactly as seen in fgt-revised.csv (with Service added)
$headerRow = "Date,Time,Fortigate Policy ID,Action,Application,Src. Country,Dst. Country,Src. Interface,Dst. Interface,Src. IP,Dst. IP,Src. Port,Dst. Port,Service,Rcvd Bytes,Sent Bytes"

$lines = Get-Content $sourcePath
Write-Host "Reading $sourcePath ($($lines.Count) lines)..."


$outputLines = New-Object System.Collections.Generic.List[string]
$outputLines.Add($headerRow)

foreach ($line in $lines) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    # Use regex to extract key=value pairs (handles spaces/quotes in values)
    $allMatches = [regex]::Matches($line, '(\w+)=(""*[^""]*""*|[^",]*)')
    
    $data = @{}
    foreach ($m in $allMatches) {
        $k = $m.Groups[1].Value
        $v = $m.Groups[2].Value

        # Strip all surrounding quotes
        $v = $v -replace '^"+|"+$', ''
        
        $data[$k] = $v
    }

    if ($data.Count -eq 0) { continue }

    # Date transformation
    $rawDate = $data["date"]
    $formattedDate = $rawDate
    if ($rawDate -match '^\d{4}-\d{2}-\d{2}$') {
        try {
            # Manual split to avoid Get-Date locale issues
            $parts = $rawDate -split '-'
            $formattedDate = "$([int]$parts[1])/$([int]$parts[2])/$($parts[0])"
        }
        catch {}
    }

    # Time transformation
    $formattedTime = $data["time"] -replace '^0', ''

    # Construct format order:
    # Date,Time,Fortigate Policy ID,Action,Application,Src. Country,Dst. Country, Src. Interface,Dst. Interface,Src. IP,Dst. IP,Src. Port,Dst. Port,Service,Rcvd Bytes,Sent Bytes
    
    $row = @(
        $formattedDate,
        $formattedTime,
        $data["policyid"],
        $data["action"],
        $data["app"],
        $data["srccountry"],
        $data["dstcountry"],
        $data["srcintf"],
        $data["dstintf"],
        $data["srcip"],
        $data["dstip"],
        $data["srcport"],
        $data["dstport"],
        $data["service"],
        $data["rcvdbyte"],
        $data["sentbyte"]
    ) -join ","

    
    $outputLines.Add($row)
}

$outputLines | Set-Content -Path $outputPath -Encoding utf8
Write-Host "Processed $($outputLines.Count - 1) records. Output saved to $outputPath"
