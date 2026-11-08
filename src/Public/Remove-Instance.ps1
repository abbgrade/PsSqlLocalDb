function Remove-Instance {

    <#

    .SYNOPSIS
    Stops and removes a SQL Server LocalDB instance.

    .DESCRIPTION
    Stops the specified instance, then deletes it using the
    SqlLocalDB utility. Supports ShouldProcess, so use -WhatIf to preview
    the operation or -Confirm to be prompted before it runs. Requires SQL
    Server LocalDB to be installed.

    .EXAMPLE
    PS> Import-Module PsSqlLocalDb
    PS> $instance = New-LocalDbInstance -Name 'ExampleInstance'
    PS> $instance | Remove-LocalDbInstance

    Creates, then removes the temporary instance. Requires SQL Server LocalDB
    to be installed. The removal command produces no success output.

    .EXAMPLE
    PS> Import-Module PsSqlLocalDb
    PS> Remove-LocalDbInstance -Name 'ExampleInstance' -WhatIf

    Previews removing the instance without stopping or deleting it. The
    confirmation text is environment-dependent.

    .LINK
    https://abbgrade.github.io/PsSqlLocalDb/docs/Remove-LocalDbInstance.html

    .LINK
    https://learn.microsoft.com/en-us/sql/tools/sqllocaldb-utility

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
