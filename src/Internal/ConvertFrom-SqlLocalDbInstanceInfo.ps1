function ConvertFrom-SqlLocalDbInstanceInfo {
    <#
    .SYNOPSIS
    Converts SqlLocalDB instance information into labeled fields.

    .DESCRIPTION
    Reads the labeled lines returned by `sqllocaldb info <instance>` and
    returns the instance name, version, and named pipe when present. Unknown
    and malformed lines are ignored.

    .OUTPUTS
    PSCustomObject
    An object with Name, Version, and NamedPipe properties.

    .EXAMPLE
    ConvertFrom-SqlLocalDbInstanceInfo -Output @('Name: Test', 'Version: 15.0.4153.1')

    .NOTES
    Internal helper; not exported from the module.
    #>
    [CmdletBinding()]
    param (
        # Labeled output lines returned by sqllocaldb.
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string[]] $Output
    )

    $instanceData = @{}
    foreach ($line in $Output) {
        $line = "$line".Trim()
        if (-not $line) {
            continue
        }

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

    [PSCustomObject]@{
        Name      = $instanceData.Name
        Version   = $instanceData.Version
        NamedPipe = $instanceData.NamedPipe
    }
}
