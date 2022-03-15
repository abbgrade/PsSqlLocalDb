function Get-Instance {

    <#

    .SYNOPSIS
    Returns connection parameters to a available localDb.

    .DESCRIPTION
    Uses [SqlLocalDB Utility](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15) to get info about the available local db.

    .EXAMPLE
    PS> Get-LocalDbInstance

    [PSCustomObject]

    Name                           Value
    ----                           -----
    Name                           MSSQLLocalDB
    Version                        v11.0

    #>

    [CmdletBinding()]
    param ()

    $name, $version = sqllocaldb info

    if ( -Not $name ) {
        Write-Error "'sqllocaldb info' did not return a instance name"
    }
    else {
        Write-Verbose "Found LocalDb instance $name."
    }

    if ( -Not $version ) {
        Write-Warning "'sqllocaldb info' did not return a instance version"
    }
    else {
        Write-Verbose "Found LocalDb version $version."
    }

    [PSCustomObject] @{
        Name    = $Name
        Version = $version
    } | Write-Output
}
