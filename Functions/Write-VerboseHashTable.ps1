function Write-VerboseHashTable
{
    <#
    .Synopsis
       Generate verbose output for a hashtable
    .DESCRIPTION
       Long description
    .EXAMPLE
       @{
        foo     = '10'
        bar     = '2'
        fitzbar = '300000','20000'
        baz     = '400'
    } | Write-VerboseHashTable -Verbose
    .EXAMPLE
    @{
        foo     = '10'
        bar     = '2'
        fitzbar = '300000','20000'
        baz     = '400'
    } | Write-VerboseHashTable -Indent 10 -Verbose
    #>
    [CmdletBinding()]
    Param
    (
        # the hashtable to produce verbose output for
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [HashTable]
        $HashTable,

        # number of spaces to indent
        [int]
        $Indent = 0
    )
    ### Find the longest Key to determine the column width
    $cloumnWidth = $HashTable.Keys.length | Sort-Object| Select-Object -Last 1

    ### Output the HashTable using the column width
    $HashTable.GetEnumerator() | ForEach-Object {
        if ($_.Value -is [array])
        {
            $valueString = "{$($_.Value -join ',')}"
        }
        else
        {
            $valueString = $_.Value
        }
        Write-Verbose ("{0,-$cloumnWidth} : {1}" -F $_.Key.ToString().PadLeft($Indent), $valueString) -Verbose
    }
}