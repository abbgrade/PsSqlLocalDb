
param(
	[string] $NuGetApiKey = $env:nuget_apikey,

	# Overwrite published versions
	[switch] $ForcePublish,

    # Add doc templates for new command.
	[switch] $ForceDocInit,

	# Version suffix to prereleases
	[int] $BuildNumber
)

$ModuleName = 'PsSqlLocalDb'

. $PSScriptRoot\tasks\Build.Tasks.ps1
. $PSScriptRoot\tasks\Dependencies.Tasks.ps1
. $PSScriptRoot\tasks\PsBuild.Tasks.ps1
