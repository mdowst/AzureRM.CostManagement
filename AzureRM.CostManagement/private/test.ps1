$ob01 = [PSCustomObject]@{
    S = "A2"
    R = "EU"
    Q = 4
}

$ob02 = [PSCustomObject]@{
    S = "A1"
    R = "EU"
    Q = 1
}

$ob03 = [PSCustomObject]@{
    S = "A1"
    R = "EU"
    Q = 4
}

$a = @($ob01, $ob02, $ob03) | Group-Object 'S', 'R'
foreach ($g in $a) {
    $total = 0
    $g.group.q | ForEach-Object {
        $total += $_
    }
    Write-Output "Quantity for size $($g.group[0].s.ToString()) in region $($g.group[0].r.ToString()): $total"
}
