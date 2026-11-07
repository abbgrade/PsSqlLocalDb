function Test-SqlLocalDbVersionPrefix {
    <#
    .SYNOPSIS
    Tests whether a version begins with the requested numeric components.

    .DESCRIPTION
    Compares each component in Prefix with the corresponding component in
    Version. Prefix can contain one to four dot-separated numeric components,
    such as 15, 15.0, or 15.0.4153. Missing trailing components in Prefix do
    not affect the match. Returns false when Version is null.

    .PARAMETER Version
    Installed version to compare.

    .PARAMETER Prefix
    One to four dot-separated numeric version components.

    .OUTPUTS
    System.Boolean
    True when all specified components match; otherwise false.

    .EXAMPLE
    Test-SqlLocalDbVersionPrefix -Version ([version]'15.0.4153.1') -Prefix '15.0'
    # Returns True.

    .NOTES
    Internal helper; not exported from the module.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [version] $Version,

        [Parameter(Mandatory)]
        [ValidatePattern('^\d+(?:\.\d+){0,3}$')]
        [string] $Prefix
    )

    if ($null -eq $Version) {
        return $false
    }

    $actualParts = @($Version.Major, $Version.Minor, $Version.Build, $Version.Revision)
    $requestedParts = @($Prefix -split '\.' | ForEach-Object { [int] $_ })
    for ($index = 0; $index -lt $requestedParts.Count; $index++) {
        if ($actualParts[$index] -ne $requestedParts[$index]) {
            return $false
        }
    }

    return $true
}
