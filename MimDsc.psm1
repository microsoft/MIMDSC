
#Get function definition files.
$Public = @(Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 -ErrorAction SilentlyContinue)

#Dot source the files
Foreach ($import in @($Public))
{
	Try {
		. $import.fullname
	} Catch {
		Write-Error -Message "Failed to import function $($import.fullname): $_"
	}
}

# Export all the functions
Export-ModuleMember -Function $Public.Basename -Alias *