#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Stop-Instance' {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context 'LocalDb' -Skip:( -Not ( Test-LocalDbUtility )) {
        BeforeEach {
            $Script:Instance = New-LocalDbInstance
        }

        AfterEach {
            $Script:Instance | Remove-LocalDbInstance
        }

        It 'Stops the instance' {
            $Script:Instance | Stop-LocalDbInstance

            Connect-TSqlInstance -DataSource "(LocalDb)\$( $Script:Instance.Name )"
        }

        It 'Stops used instance' {
            Connect-TSqlInstance -DataSource "(LocalDb)\$( $Script:Instance.Name )"

            $Script:Instance | Stop-LocalDbInstance -Force
        }
    }
}