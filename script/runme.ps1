function Show-MainMenu {
    Write-Host "--- Vivado TCL脚本工具 ---" -ForegroundColor Cyan
    Write-Host "1. 生成比特流"
    Write-Host "2. 下载比特流"
    Write-Host "3. coe文件转换csv"
    Write-Host "4. 在线更新bram"
    Write-Host "5. 在线回读bram"
    Write-Host "--------------------------"
}

function Build-All {
    # vivado -mode tcl -source tcl\build.tcl
    vivado -mode batch -source script\build.batch.tcl
}

function Prog-Bits {
    vivado -mode batch -source script\prog.batch.tcl
}

function Convert-Coe {
    $coePath = Read-Host "请输入路径或拖入coe文件"
    .\script\coe2csv.ps1 -i $coePath -o .\script\temp\coe_out.csv
}

function Update-Bram {
    vivado -mode batch -source script\vio.bram.w.batch.tcl
}

function ReadBack-Bram {
    vivado -mode batch -source script\vio.bram.r.batch.tcl
}

while($true) {
    Show-MainMenu
    $choice = Read-Host "请选择功能"
    switch ($choice) {
        '1' { Build-All }
        '2' { Prog-Bits }
        '3' { Convert-Coe }
        '4' { Update-Bram }
        '5' { ReadBack-Bram }
        default { Write-Host "无效选项" -ForegroundColor Red }
    }
}

