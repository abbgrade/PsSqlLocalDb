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
        $result = Invoke-SqlLocalDb -ArgumentList @('versions')
        $result.Output | Where-Object { "$_".Trim() } | Write-Verbose
        return [bool] $result.Succeeded
    }
}
