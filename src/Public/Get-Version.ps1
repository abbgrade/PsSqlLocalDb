function Get-Version {

    <#

    .SYNOPSIS
    Return localdb versions

    .DESCRIPTION
    Selects the installed localdb versions, that can be used to create new instances.

    .EXAMPLE

    PS> Get-LocalDbVersion

    Name                      Version
    ----                      -------
    Microsoft SQL Server 2016 13.1.4001.0
    Microsoft SQL Server 2019 15.0.4153.1

    #>

    [CmdletBinding()]
    param (
    )

    Write-Verbose 'Get sqllocaldb versions.'
    $result = Invoke-SqlLocalDb -ArgumentList @('versions')
    if (-not $result.Succeeded) {
        Write-SqlLocalDbError -Message 'Failed to get LocalDB versions.' -Details $result.Error
        return
    }

    foreach ($line in $result.Output) {
        $line = "$line".Trim()
        if (-not $line) {
            continue
        }

        $parsedVersion = $null
        if ($line -match '^(?<Name>.+?)\s+\((?<Version>\d+(?:\.\d+){1,3})\)$' -and
            [version]::TryParse($matches.Version, [ref]$parsedVersion)) {
            $version = [PSCustomObject] @{
                Name = $matches.Name
                Version = $parsedVersion
            }
            $version
        }
        else {
            Write-Warning "Unexpected output from 'sqllocaldb versions': $line"
        }
    }
}
