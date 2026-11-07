class SqlServerVersion : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return (
            @() + ( Get-Version |
            Select-Object -ExpandProperty Version |
            ForEach-Object {
                $_ | Write-Output
                New-Object System.Version $_.Major, $_.Minor | Write-Output
                New-Object System.Version $_.Major, $_.Minor, $_.Build | Write-Output
            }) + ( $null | Write-Output )
        )
    }
}

function New-Instance {

    <#

    .SYNOPSIS
    Creates and starts a SQL Server LocalDB instance.

    .DESCRIPTION
    Creates a LocalDB instance, starts it, and returns its instance details.
    If no name is specified, a random name is generated. Use Get-LocalDbVersion
    to see the installed versions that can be used with the Version parameter.
    Supports ShouldProcess, so use -WhatIf to preview the operation or
    -Confirm to be prompted before it runs.

    .EXAMPLE
    PS> New-LocalDbInstance -Name 'foobar'

    Creates and starts an instance named 'foobar', then returns its details.

    .EXAMPLE
    PS> New-LocalDbInstance -Name 'foobar' -WhatIf

    Shows the create operation without creating or starting the instance.

    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Name for the new instance; defaults to a random eight-character name.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name = ( [string](New-Guid) ).Substring(0, 8),

        # Installed SQL Server LocalDB version to use; defaults to SqlLocalDB's version.
        [Parameter()]
        [ValidateSet([SqlServerVersion])]
        [string] $Version
    )

    process {
        Write-Verbose "Create sqllocaldb instance $Name."
        $arguments = @('create', $Name)
        if ($Version) {
            $arguments += $Version
        }
        $arguments += '-s'

        if (-not $PSCmdlet.ShouldProcess($Name, 'Create LocalDB instance')) {
            return
        }

        $result = Invoke-SqlLocalDb -ArgumentList $arguments
        $result.Output | Where-Object { "$_".Trim() } | Write-Verbose
        if (-not $result.Succeeded) {
            Write-SqlLocalDbError -Message "Failed to create LocalDB instance '$Name'." -Details $result.Error
            return
        }

        $instance = Get-Instance -Name $Name
        if ($null -eq $instance) {
            Write-SqlLocalDbError -Message "Created LocalDB instance '$Name', but could not retrieve its details."
            return
        }

        $instance
    }
}
