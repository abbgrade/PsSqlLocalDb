function Stop-Instance {

    <#

    .SYNOPSIS
    stops a sqllocaldb instance.

    .EXAMPLE
    PS> $instance = New-LocalDbInstance
    PS> $instance | Stop-LocalDbInstance

    #>

    [CmdletBinding()]
    param (
        # Specifies the name of the instance to stop.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [switch] $Force
    )

    if ( $Force ) {
        $response = sqllocaldb stop $Name -k
    } else {
        $response = sqllocaldb stop $Name
    }

    $response | Where-Object { $_ } | Write-Verbose
    if ( -not $? ) {
        Write-Error "Failed to stop sqllocaldb instance $Name."
    }

}
