function Test-Utility {

    <#

    .SYNOPSIS
    Tests whether the SqlLocalDB utility is available.

    .DESCRIPTION
    Runs the SqlLocalDB versions command and returns $true if it succeeds,
    otherwise returns $false.

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
