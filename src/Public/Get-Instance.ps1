function Get-Instance {

    <#

    .SYNOPSIS
    Gets SQL Server LocalDB instance details.

    .DESCRIPTION
    Lists available LocalDB instances or gets details for one named instance.
    Each result contains the instance name, SQL Server version as a System.Version
    value when available, and the named pipe when available. Use Version to
    filter by a version prefix. Requires SQL Server LocalDB to be installed.

    .EXAMPLE
    PS> Import-Module PsSqlLocalDb
    PS> Get-LocalDbInstance -Name 'MSSQLLocalDB'

    Gets details for the MSSQLLocalDB instance. Requires SQL Server LocalDB to
    be installed.
    Example output is abbreviated and illustrative; the version and pipe name
    vary by machine.

    Name         Version    NamedPipe
    ----         -------    ---------
    MSSQLLocalDB 15.0.4153.1 machine-specific

    .OUTPUTS
    PSCustomObject
    An instance with Name, Version, and NamedPipe properties.

    .LINK
    https://abbgrade.github.io/PsSqlLocalDb/docs/Get-LocalDbInstance.html

    .LINK
    https://learn.microsoft.com/en-us/sql/tools/sqllocaldb-utility

    #>

    [CmdletBinding( DefaultParameterSetName = 'All' )]
    param (
        # Gets details for this named instance. If omitted, lists all instances.
        [Parameter( ParameterSetName = 'Single' )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        # Filters results by a SQL Server version prefix, such as '15.0'.
        [Parameter()]
        [string] $Version
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'All') {
            Write-Verbose 'Get sqllocaldb instances.'
            $result = Invoke-SqlLocalDb -ArgumentList @('info')
            if (-not $result.Succeeded) {
                Write-SqlLocalDbError -Message 'Failed to list LocalDB instances.' -Details $result.Error
                return
            }

            foreach ($instanceName in $result.Output | ForEach-Object { "$_".Trim() } | Where-Object { $_ }) {
                Get-Instance -Name $instanceName -Version:$Version
            }
            return
        }

        Write-Verbose "Get sqllocaldb instance $Name."
        $result = Invoke-SqlLocalDb -ArgumentList @('info', $Name)
        if (-not $result.Succeeded) {
            Write-SqlLocalDbError -Message "Failed to get info for LocalDB instance '$Name'." -Details $result.Error
            return
        }

        $instanceData = ConvertFrom-SqlLocalDbInstanceInfo -Output $result.Output

        if (-not $instanceData.Name) {
            Write-Warning "'sqllocaldb info' did not return an instance with name $Name"
            $instanceData.Name = $Name
        }
        else {
            Write-Verbose "Found LocalDb instance $($instanceData.Name)."
        }

        $instance = [PSCustomObject]@{
            Name      = $instanceData.Name
            Version   = $null
            NamedPipe = $instanceData.NamedPipe
        }

        if ($instanceData.Version) {
            $parsedVersion = [version]::MinValue
            if ([version]::TryParse($instanceData.Version, [ref]$parsedVersion)) {
                $instance.Version = $parsedVersion
                Write-Verbose "Found LocalDb version $($instance.Version)."
            }
            else {
                Write-Warning "'sqllocaldb info' returned an invalid version '$($instanceData.Version)' for $Name"
            }
        }
        else {
            Write-Warning "'sqllocaldb info' did not return an instance version for $Name"
        }

        if (-not $Version -or (Test-SqlLocalDbVersionPrefix -Version $instance.Version -Prefix $Version)) {
            $instance
        }
    }
}
