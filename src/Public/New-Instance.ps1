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
    Creates a new sqllocaldb instance.

    .EXAMPLE
    PS> New-LocalDbInstance -Name 'foobar'

    [PSCustomObject]

    Name                           Value
    ----                           -----
    Name                           foobar
    Version                        15.0.4153.1

    #>

    [CmdletBinding()]
    param (
        # Specifies the name of the instance to create.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name = ( [string](New-Guid) ).Substring(0, 8),

        # Specifies the sql server version to use.
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
