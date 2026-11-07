function Remove-Instance {

    <#

    .SYNOPSIS
    Stops and removes a SQL Server LocalDB instance.

    .DESCRIPTION
    Stops the specified instance, then deletes it using the
    SqlLocalDB utility. Supports ShouldProcess, so use -WhatIf to preview
    the operation or -Confirm to be prompted before it runs.

    .EXAMPLE
    PS> $instance = New-LocalDbInstance
    PS> $instance | Remove-LocalDbInstance

    Removes the instance represented by the object.

    .EXAMPLE
    PS> Remove-LocalDbInstance -Name 'foobar' -WhatIf

    Shows the removal operation without stopping or deleting the instance.

    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Name of the LocalDB instance to remove; accepts instance objects by Name.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    process {
        Write-Verbose "Remove sqllocaldb instance $Name."

        if ($PSCmdlet.ShouldProcess($Name, 'Remove LocalDB instance')) {
            Stop-Instance -Name $Name -Confirm:$false -ErrorAction Stop

            $result = Invoke-SqlLocalDb -ArgumentList @('delete', $Name)
            $result.Output | Where-Object { "$_".Trim() } | Write-Verbose
            if (-not $result.Succeeded) {
                Write-SqlLocalDbError -Message "Failed to delete LocalDB instance '$Name'." -Details $result.Error
            }
        }

    }
}
