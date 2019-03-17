function Import-FimAutomation
{
    ###
    ### Load the FIMAutomation Snap-In
    ###
    if(Get-PSSnapin | Where-Object {$_.Name -eq 'FIMAutomation'})
    {
        Write-Verbose "FIMAutomation Snap-In already loaded"
    }
    else
    {
        Write-Verbose "Loading FIMAutomation Snap-In"
	    try 
	    {        
		    Add-PSSnapin FIMAutomation -ErrorAction SilentlyContinue -ErrorVariable err		
	    }
	    catch 
	    {
	    }

	    if ($err) 
        {
    	    if($err[0].ToString() -imatch "has already been added") 
		    {
			    Write-Verbose "FIMAutomation snap-in has already been loaded." 
		    }
		    else
		    {
			    Write-Error "FIMAutomation snap-in could not be loaded." 
		    }
	    }
	    else
	    {
		    Write-Verbose "FIMAutomation snap-in loaded successfully." 
	    }
    }
}