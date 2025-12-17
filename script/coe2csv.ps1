#  .\coe2csv.ps1 -i ..\fpga_verify_k7.srcs\coe\test.3x.t.coe -o .\temp\coe_out.csv

Param(
    [string]$i,
    [string]$o
)

$coeContent = Get-Content -Path $i -Raw

# get radix
if($coeContent -match "MEMORY_INITIALIZATION_RADIX\s*=\s*(\d+);") {
    $coeRadix = $matches[1]
    Write-Host "coe.radix=$($coeRadix)"
} else {
    $coeRadix = $null
    Write-Host "coe.radix=null"
}

# get vector
if($coeContent -match "MEMORY_INITIALIZATION_VECTOR\s*=\s*(?<CoeVectorString>[\s\S]*?);") {
    $coeVector = $matches.CoeVectorString.Trim() -split "[,\s\r\n]+" | Where-Object { $_ -ne ""}
    Write-Host "coe.vector.len=$($coeVector.Count)"
    Write-Host "coe.vector.first5="
    $coeVector | Select-Object -First 5 | Foreach-Object { Write-Host $_ }
} else {
    $coeVector = $null
    Write-Host "coe.vector.len=0"
}

# write file
New-Item -Path $o -ItemType File -Force | Out-Null
(0..($coeVector.Length - 1)) | ForEach-Object {
    $addr = [Convert]::ToString($_, 16).ToUpper()
    $value = [Convert]::ToString([Convert]::ToUInt64($coeVector[$_], $coeRadix), 16).ToUpper()
    "$addr,$value"
} | Out-File -FilePath $o -Encoding UTF8 -Force

Write-Host "File saved to $o"