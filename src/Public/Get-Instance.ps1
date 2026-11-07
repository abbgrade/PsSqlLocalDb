function Get-Instance {

    <#

    .SYNOPSIS
    Returns connection parameters to a available localDb.

    .DESCRIPTION
    Uses [SqlLocalDB Utility](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15) to get info about the available local db.

    .EXAMPLE
    PS> Get-LocalDbInstance

    [PSCustomObject]

    Name                           Value
    ----                           -----
    Name                           MSSQLLocalDB
    Version                        v11.0

    #>

    [CmdletBinding( DefaultParameterSetName = 'All' )]
    param (
        # Filters by name of the sql server instance.
        [Parameter( ParameterSetName = 'Single' )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        # Filters by version of the sql server instance.
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

        $instanceData = @{}
        foreach ($line in $result.Output | ForEach-Object { "$_".Trim() } | Where-Object { $_ }) {
            $field = $line -split ':', 2
            if ($field.Count -ne 2) {
                continue
            }

            $key = $field[0].Trim()
            $value = $field[1].Trim()
            Write-Verbose "$key=$value"

            switch -Regex ($key) {
                '^Name$' { $instanceData.Name = $value; break }
                '^Version$' { $instanceData.Version = $value; break }
                '^Instance pipe name$' { $instanceData.NamedPipe = $value; break }
            }
        }

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
