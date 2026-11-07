function Stop-Instance {

    <#

    .SYNOPSIS
    stops a sqllocaldb instance.

    .EXAMPLE
    PS> $instance = New-LocalDbInstance
    PS> $instance | Stop-LocalDbInstance

    .EXAMPLE
    PS> Stop-LocalDbInstance -Name 'foobar' -WhatIf

    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Specifies the name of the instance to stop.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [switch] $Force
    )

    process {
        Write-Verbose "Stop sqllocaldb instance $Name."

        $arguments = @('stop', $Name)
        if ($Force) {
            $arguments += '-k'
        }

        if ($PSCmdlet.ShouldProcess($Name, 'Stop LocalDB instance')) {
            $result = Invoke-SqlLocalDb -ArgumentList $arguments
            $result.Output | Where-Object { "$_".Trim() } | Write-Verbose
            if (-not $result.Succeeded) {
                Write-SqlLocalDbError -Message "Failed to stop LocalDB instance '$Name'." -Details $result.Error
            }
        }
    }
}
