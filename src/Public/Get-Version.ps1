function Get-Version {

    Write-Verbose "Get sqllocaldb instances."
    $response = sqllocaldb versions

    $response | Where-Object { $_ } | Write-Verbose
    if ( -not $? ) {
        Write-Error "Failed to get info sqllocaldb for instance $Name."
    }

    $response | ForEach-Object {
        if ( $_ -match '(.*) \((.*)\)' ) {
            $version = [PSCustomObject] @{
                Name = $matches[1]
                Version = New-Object System.Version $matches[2]
            }
            $version | Write-Output
        } else {
            Write-Warning "unexpected output $_"
        }
    }
}
