function Test-Utility {

    <#

    .SYNOPSIS
    Tests whether the SqlLocalDB utility is available.

    .DESCRIPTION
    Runs the SqlLocalDB versions command and returns $true if it succeeds,
    otherwise returns $false. Requires SQL Server LocalDB to be installed.

    .EXAMPLE
    PS> Import-Module PsSqlLocalDb
    PS> Test-LocalDbUtility

    Tests whether the LocalDB utility is available. The output is True when the
    utility runs successfully and False otherwise; the result depends on the
    machine configuration.

    True

    .OUTPUTS
    bool

    .LINK
    https://abbgrade.github.io/PsSqlLocalDb/docs/Test-LocalDbUtility.html

    .LINK
    https://learn.microsoft.com/en-us/sql/tools/sqllocaldb-utility
    #>

    [CmdletBinding()]
    param ()

    process {
        $result = Invoke-SqlLocalDb -ArgumentList @('versions')
        $result.Output | Where-Object { "$_".Trim() } | Write-Verbose
        return [bool] $result.Succeeded
    }
}
