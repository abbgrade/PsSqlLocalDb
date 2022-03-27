function Remove-Instance {

    <#

    .SYNOPSIS
    Removes a sqllocaldb instance.

    .EXAMPLE
    PS> $instance = New-LocalDbInstance
    PS> $instance | Remove-LocalDbInstance

    #>

    [CmdletBinding()]
    param (
        # Specifies the name of the instance to remove.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    process {
        Write-Verbose "Remove sqllocaldb instance $Name."
        Stop-Instance -Name $Name

        $response = sqllocaldb delete $Name

        $response | Where-Object { $_ } | Write-Verbose
        if ( -not $? ) {
            Write-Error "Failed to delete sqllocaldb instance $Name."
        }

    }
}
