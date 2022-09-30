class SqlServerVersion : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return (
            Get-Version |
            Select-Object -ExpandProperty Version |
            ForEach-Object {
                $_ | Write-Output
                New-Object System.Version $_.Major, $_.Minor | Write-Output
                New-Object System.Version $_.Major, $_.Minor, $_.Build | Write-Output
            }
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
        [Parameter( )]
        [ValidateNotNullOrEmpty()]
        [ValidateSet([SqlServerVersion])]
        [string] $Version
    )

    process {
        Write-Verbose "Create sqllocaldb instance $Name."
        $response = sqllocaldb create $Name $Version -s

        $response | Where-Object { $_ } | Write-Verbose
        if ( -not $? ) {
            Write-Error "Failed to create sqllocaldb instance $Name."
        }

        $instance = Get-Instance -Name $Name
        if ( $instance -and $instance.Version -ne '0.0' ) {
            $instance | Write-Output
        }
        else {
            Write-Error 'Failed to return new sqllocaldb instance.'
        }
    }
}
