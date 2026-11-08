function Stop-Instance {

    <#

    .SYNOPSIS
    Stops a SQL Server LocalDB instance.

    .DESCRIPTION
    Stops the specified instance using the SqlLocalDB utility. Use Force to
    terminate processes that are accessing the instance. Supports ShouldProcess,
    so use -WhatIf to preview the operation or -Confirm to be prompted before it
    runs. Requires SQL Server LocalDB to be installed.

    .EXAMPLE
    PS> Import-Module PsSqlLocalDb
    PS> $instance = New-LocalDbInstance -Name 'ExampleInstance'
    PS> $instance | Stop-LocalDbInstance
    PS> $instance | Remove-LocalDbInstance

    Creates and stops a temporary instance. Requires SQL Server LocalDB to be
    installed. The stop command produces no success output. Remove the instance
    command then deletes the stopped instance.

    .EXAMPLE
    PS> Import-Module PsSqlLocalDb
    PS> Stop-LocalDbInstance -Name 'ExampleInstance' -WhatIf

    Previews stopping the instance without stopping it. The confirmation text
    is environment-dependent.

    .LINK
    https://abbgrade.github.io/PsSqlLocalDb/docs/Stop-LocalDbInstance.html

    .LINK
    https://learn.microsoft.com/en-us/sql/tools/sqllocaldb-utility

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
