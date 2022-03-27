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

    [CmdletBinding( DefaultParameterSetName = 'All' )]
    param (
        # Specifies the name of the instance to create.
        [Parameter( ParameterSetName = 'Single' )]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    switch ($PSCmdlet.ParameterSetName) {
        All {
            $response = sqllocaldb info

            $response | Where-Object { $_ } | Write-Verbose
            if ( -not $? ) {
                Write-Error "Failed to get info sqllocaldb for instance $Name."
            }

            $response | ForEach-Object {
                Get-Instance -Name $PSItem
            }
        }
        Single {
            $response = sqllocaldb info $Name

            $response | Where-Object { $_ } | Write-Verbose
            if ( -not $? ) {
                Write-Error "Failed to get info from sqllocaldb."
            }

            $processedResponse = $response |
            Where-Object { $_ } |
            ForEach-Object {
                $Local:item = $_ -split ':', 2
                $Local:key = $Local:item[0]
                $Local:value = $Local:item[1].Trim()
                Write-Verbose "$Local:key=$Local:value"
                Write-Output $Local:value
            }
            $name, $version, $strongName, $owner, $autoCreate, $state, $lastStart, $namedPipe = $processedResponse

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
                Name    = $name
                Version = $version
                NamedPipe = $namedPipe
            } | Write-Output
        }
        default {
            Write-Error "ParameterSet $PSItem is not supported"
        }
    }
}
