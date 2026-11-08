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
    -Confirm to be prompted before it runs. Requires SQL Server LocalDB to be
    installed.

    .EXAMPLE
    PS> Import-Module PsSqlLocalDb
    PS> $instance = New-LocalDbInstance -Name 'ExampleInstance'
    PS> $instance
    PS> $instance | Remove-LocalDbInstance

    Creates and starts the named instance, then displays its details. Requires
    SQL Server LocalDB to be installed. Example output is abbreviated and
    illustrative; version and named pipe vary by machine. The example removes
    the temporary instance.

    Name            Version    NamedPipe
    ----            -------    ---------
    ExampleInstance 15.0.4153.1 machine-specific

    .EXAMPLE
    PS> Import-Module PsSqlLocalDb
    PS> New-LocalDbInstance -Name 'ExampleInstance' -WhatIf

    Previews creating the instance without creating or starting it. The
    confirmation text is environment-dependent.

    .OUTPUTS
    PSCustomObject
    The created instance with Name, Version, and NamedPipe properties.

    .LINK
    https://abbgrade.github.io/PsSqlLocalDb/docs/New-LocalDbInstance.html

    .LINK
    https://learn.microsoft.com/en-us/sql/tools/sqllocaldb-utility

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
