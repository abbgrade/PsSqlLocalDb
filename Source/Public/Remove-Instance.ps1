function Remove-Instance {

    [CmdletBinding()]
    param (
        # Specifies the name of the instance to remove.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    Stop-Instance -Name $Name

    $response = sqllocaldb delete $Name

    $response | Where-Object { $_ } | Write-Verbose
    if ( -not $? ) {
        Write-Error "Failed to delete sqllocaldb instance $Name."
    }

}
