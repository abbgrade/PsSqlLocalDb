#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-Instance' {
    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context 'LocalDb' -Skip:( -Not ( Test-LocalDbUtility )) {

        It 'Returns values' {
            $Script:Instance = New-LocalDbInstance

            $Script:Instance | Should -Not -BeNullOrEmpty
            $Script:Instance.Name | Should -Not -BeNullOrEmpty
            $Script:Instance.Version | Should -Not -BeNullOrEmpty
        }

        AfterEach {
            if ( $Script:Instance ) {
                $Script:Instance | Remove-LocalDbInstance
            }
        }

        BeforeDiscovery {
            $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context 'PsSqlClient' -Skip:( -Not $Script:PsSqlClient ) {

            BeforeAll {
                $Script:Instance = New-LocalDbInstance
            }

            It 'Connects by DataSource' {
                $Script:SqlConnection = Connect-TSqlInstance -DataSource "(LocalDb)\$( $Script:Instance.Name )" -ConnectTimeout 30
            }

            AfterEach {
                if ( $Script:SqlConnection ) {
                    Disconnect-TSqlInstance -Connection $Script:SqlConnection
                }
            }
        }
    }
}
