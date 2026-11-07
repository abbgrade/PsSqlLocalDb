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
        Stop-Instance -Name $Name -ErrorAction Stop

        $result = Invoke-SqlLocalDb -ArgumentList @('delete', $Name)
        $result.Output | Where-Object { "$_".Trim() } | Write-Verbose
        if (-not $result.Succeeded) {
            Write-SqlLocalDbError -Message "Failed to delete LocalDB instance '$Name'." -Details $result.Error
        }

    }
}
