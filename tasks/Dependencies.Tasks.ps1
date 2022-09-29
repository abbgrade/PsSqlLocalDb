task InstallBuildDependencies -Jobs {
    Install-Module platyPs -ErrorAction Stop
}
task InstallTestDependencies -Jobs {
    Install-Module PsSqlClient -AllowPrerelease -AllowClobber
}
task InstallReleaseDependencies -Jobs {}