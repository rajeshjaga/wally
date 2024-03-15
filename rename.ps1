$something=Get-ChildItem -Path .\ | Select-Object -ExpandProperty Name

$something | ForEach-Object {
    $fName=$PSItem
    $replaceName = $fname.Replace('(', '').Replace(')','').Replace(' ','')
    Move-Item $fName $replaceName -Verbose 
}
