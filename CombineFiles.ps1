$outfile = "DapperExtensions.Combined.cs"
$namespace = "DapperExtensions"
$usingStatements = New-Object "system.collections.generic.list[string]"
$files = New-Object "system.collections.generic.list[string]"
$files.Add("DapperExtensions\ClassMapper.cs")
$files.Add("DapperExtensions\DapperExtensions.cs")
$files.Add("DapperExtensions\DapperFormatter.cs")
$files.Add("DapperExtensions\Predicates.cs")
$files.Add("DapperExtensions\PropertyMap.cs")
$files.Add("DapperExtensions\ReflectionHelper.cs")
$files | ForEach-Object { 
		Write-Host "Extracting usings from" $_ 
		$contents = Get-Content $_
		$contents | ForEach-Object {
			if($_.trim().StartsWith("using") -and !$usingStatements.Contains($_)) {
				$usingStatements.Add($_);
			}
		}
}

$usingStatements.Sort() 
Remove-Item $outfile
Add-Content $outfile $usingStatements

Add-Content $outfile ""
Add-Content $outfile "// Dapper Extensions"
Add-Content $outfile "// Extensions for Dapper to handle basic CRUD operations"
Add-Content $outfile ""
$date = Get-Date
Add-Content $outfile "// Generated: ${date}"
Add-Content $outfile "// Website: https://github.com/tmsmith/Dapper-Extensions"
Add-Content $outfile "// License: http://www.apache.org/licenses/LICENSE-2.0"
Add-Content $outfile ""

Add-Content $outfile "namespace ${namespace}"
Add-Content $outfile "{"
$skipNext = $false
$files | ForEach-Object { 
		Add-Content $outfile "    // Begin ${_}"
		$contents = Get-Content $_
		for ($i=0; $i -lt $contents.Length - 1; $i++) {
			$l = $contents[$i]
			if($skipNext) {
				$skipNext = $false
				continue
			}
			
			$line = $l.trim();
			
			if($line.StartsWith("namespace")) {
				$skipNext = $true
				continue
			}
				
			if(!$line.StartsWith("using")) {
				Add-Content $outfile $l			
			}
		}
		Add-Content $outfile "    // End ${_}"
}
Add-Content $outfile "}"