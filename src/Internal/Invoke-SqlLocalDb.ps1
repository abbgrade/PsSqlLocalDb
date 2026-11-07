function Invoke-SqlLocalDb {
    <#
    .SYNOPSIS
    Runs the SqlLocalDB utility and captures its result.

    .DESCRIPTION
    Invokes `sqllocaldb` with the supplied arguments, captures standard output
    and standard error, and records the native exit code. The returned result
    indicates whether the command succeeded and includes an error message on
    failure. An invocation exception is also represented as a failed result.

    .PARAMETER ArgumentList
    Arguments passed to `sqllocaldb`. An empty list invokes the utility without
    arguments.

    .OUTPUTS
    PSCustomObject
    A result with Succeeded, Output, ExitCode, and Error properties.

    .EXAMPLE
    $result = Invoke-SqlLocalDb -ArgumentList @('versions')
    if ($result.Succeeded) {
        $result.Output
    }

    .NOTES
    Internal helper; not exported from the module.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $ArgumentList
    )

    try {
        $output = @(& sqllocaldb @ArgumentList 2>&1)
        $exitCode = $LASTEXITCODE
        $succeeded = $null -eq $exitCode -or $exitCode -eq 0
        $errorMessage = $null

        if (-not $succeeded) {
            $errorMessage = "SqlLocalDB exited with code $exitCode."
            $details = ($output | ForEach-Object { "$_" } | Where-Object { $_ }) -join [Environment]::NewLine
            if ($details) {
                $errorMessage = "$errorMessage $details"
            }
        }

        [PSCustomObject]@{
            Succeeded = $succeeded
            Output    = $output
            ExitCode  = $exitCode
            Error     = $errorMessage
        }
    }
    catch {
        [PSCustomObject]@{
            Succeeded = $false
            Output    = @()
            ExitCode  = $null
            Error     = $_.Exception.Message
        }
    }
}
