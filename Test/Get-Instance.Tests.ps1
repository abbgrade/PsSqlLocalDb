#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Get-Instance' {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context 'LocalDb' -Skip:( -Not ( Test-LocalDbUtility )) {

        It 'Returns values' {
            $result = Get-LocalDbInstance -Verbose

            $result | Should -Not -BeNullOrEmpty
            $result.Name | Should -Not -BeNullOrEmpty
        }

        BeforeDiscovery {
            $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context 'PsSqlClient' -Skip:( -Not $Script:PsSqlClient ) {

            BeforeAll {
                $Script:LocalDb = Get-LocalDbInstance
            }

            It 'Connects by DataSource' {
                $Script:SqlConnection = Connect-TSqlInstance -DataSource "(LocalDb)\$( $Script:LocalDb.Name )"
            }

            AfterEach {
                if ( $Script:SqlConnection ) {
                    Disconnect-TSqlInstance -Connection $Script:SqlConnection
                }
            }
        }
    }
}
