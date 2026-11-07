function Stop-Instance {

    <#

    .SYNOPSIS
    Stops a SQL Server LocalDB instance.

    .DESCRIPTION
    Stops the specified instance using the SqlLocalDB utility. Use Force to
    terminate processes that are accessing the instance. Supports ShouldProcess,
    so use -WhatIf to preview the operation or -Confirm to be prompted before it
    runs.

    .EXAMPLE
    PS> $instance = New-LocalDbInstance
    PS> $instance | Stop-LocalDbInstance

    Stops the instance represented by the object.

    .EXAMPLE
    PS> Stop-LocalDbInstance -Name 'foobar' -WhatIf

    Shows the stop operation without stopping the instance.

    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Name of the LocalDB instance to stop; accepts instance objects by Name.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        # Terminates processes accessing the instance so it can be stopped.
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
