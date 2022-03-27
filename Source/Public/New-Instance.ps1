function New-Instance {

    <#

    .SYNOPSIS
    Creates a new sqllocaldb instance.

    .EXAMPLE
    PS> New-LocalDbInstance -Name 'foobar'

    [PSCustomObject]

    Name                           Value
    ----                           -----
    Name                           foobar
    Version                        15.0.4153.1

    #>

    [CmdletBinding()]
    param (
        # Specifies the name of the instance to create.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name = ( [string](New-Guid) ).Substring(0, 8),

        # Specifies the sql server version to use.
        [Parameter( )]
        [ValidateNotNullOrEmpty()]
        [string] $Version
    )

    $response = sqllocaldb create $Name $Version -s

    $response | Where-Object { $_ } | Write-Verbose
    if ( -not $? ) {
        Write-Error "Failed to create sqllocaldb instance $Name."
    }

    Get-Instance -Name $Name
}
