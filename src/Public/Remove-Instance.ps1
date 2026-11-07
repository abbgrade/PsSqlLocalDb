function Remove-Instance {

    <#

    .SYNOPSIS
    Removes a sqllocaldb instance.

    .EXAMPLE
    PS> $instance = New-LocalDbInstance
    PS> $instance | Remove-LocalDbInstance

    .EXAMPLE
    PS> Remove-LocalDbInstance -Name 'foobar' -WhatIf

    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Specifies the name of the instance to remove.
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
