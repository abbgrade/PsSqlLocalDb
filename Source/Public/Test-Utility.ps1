function Test-Utility {

    <#

    .SYNOPSIS
    Tests if a localDb-based SQL Server can be created.

    .DESCRIPTION
    Uses [SqlLocalDB Utility](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15).

    .EXAMPLE
    PS> Test-LocalDbUtility

    True

    .OUTPUTS
    bool
    #>

    [CmdletBinding()]
    param ()

    process {
        try {
            $response = sqllocaldb

            $response | Where-Object { $_ } | Write-Verbose
            if ( -not $? ) {
                Write-Error "Failed to test sqllocaldb util."
            }

            return $true
        }
        catch {
            return $false
        }
    }
}
