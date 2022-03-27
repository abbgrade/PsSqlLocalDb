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
        # Specifies the name of the instance.
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

            $responseIndex = 0
            $instance = New-Object PSCustomObject
            $response |
            Where-Object { $_ } |
            ForEach-Object {
                $item = $_ -split ':', 2
                $key = $item[0]
                $value = $item[1]
                if ( $value ) {
                    $value = $value.Trim()
                }
                Write-Verbose "$key=$value"

                switch ( $responseIndex ) {
                    0 { $instance | Add-Member Name $value }
                    1 { $instance | Add-Member Version $value }
                    # 2 { $instance | Add-Member strongName $value }
                    # 3 { $instance | Add-Member owner $value }
                    # 4 { $instance | Add-Member autoCreate $value }
                    # 5 { $instance | Add-Member state $value }
                    # 6 { $instance | Add-Member lastStart $value }
                    7 { $instance | Add-Member NamedPipe $value }
                }

                $responseIndex += 1
            }

            if ( -Not $instance.Name ) {
                Write-Error "'sqllocaldb info' did not return a instance name"
            }
            else {
                Write-Verbose "Found LocalDb instance $name."
            }

            if ( -Not $instance.Version ) {
                Write-Warning "'sqllocaldb info' did not return a instance version"
            }
            else {
                Write-Verbose "Found LocalDb version $version."
            }

            $instance | Write-Output
        }
        default {
            Write-Error "ParameterSet $PSItem is not supported"
        }
    }
}
