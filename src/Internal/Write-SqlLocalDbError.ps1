function Write-SqlLocalDbError {
    <#
    .SYNOPSIS
    Writes a structured SqlLocalDB utility error.

    .DESCRIPTION
    Combines the supplied message and optional details, then writes a
    ResourceUnavailable error identifying `sqllocaldb` as the target.

    .PARAMETER Message
    Main description of the operation that failed.

    .PARAMETER Details
    Optional diagnostic details to append to the message.

    .EXAMPLE
    Write-SqlLocalDbError -Message 'Failed to list LocalDB instances.' -Details $result.Error

    .NOTES
    Internal helper; not exported from the module. The error honors the
    caller's ErrorAction preference.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Message,

        [Parameter()]
        [string] $Details
    )

    if ($Details) {
        $Message = "$Message $Details"
    }

    $PSCmdlet.WriteError(
        [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new($Message),
            'SqlLocalDbUtilityFailed',
            [System.Management.Automation.ErrorCategory]::ResourceUnavailable,
            'sqllocaldb'
        )
    )
}
