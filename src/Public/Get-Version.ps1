function Get-Version {

    <#

    .SYNOPSIS
    Return localdb versions

    .DESCRIPTION
    Selects the installed localdb versions, that can be used to create new instances.

    .EXAMPLE

    PS> Get-LocalDbVersion

    Name                      Version
    ----                      -------
    Microsoft SQL Server 2016 13.1.4001.0
    Microsoft SQL Server 2019 15.0.4153.1

    #>

    [CmdletBinding()]
    param (
    )

    Write-Verbose "Get sqllocaldb instances."
    $response = sqllocaldb versions

    $response | Where-Object { $_ } | Write-Verbose
    if ( -not $? ) {
        Write-Error "Failed to get info sqllocaldb for instance $Name."
    }

    $response | ForEach-Object {
        if ( $_ -match '(.*) \((.*)\)' ) {
            $version = [PSCustomObject] @{
                Name = $matches[1]
                Version = New-Object System.Version $matches[2]
            }
            $version | Write-Output
        } else {
            Write-Warning "unexpected output $_"
        }
    }
}
