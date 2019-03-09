function Format-XML($xmlFile, $indent=2)
{
	<#
   	.SYNOPSIS 
   	Formats an XML file
	#>
    $StringWriter = New-Object System.IO.StringWriter
    $XmlWriter = New-Object System.Xml.XmlTextWriter $StringWriter
    $xmlWriter.Formatting = "indented"
    $xmlWriter.Indentation = 4

    [XML]$xml = Get-Content $xmlFile
    $xml.WriteContentTo($XmlWriter)
    $XmlWriter.Flush()
    $StringWriter.Flush()
    $StringWriter.ToString()  | Out-File -Encoding "UTF8" -FilePath $xmlFile
}