#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-Instance {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context LocalDb -Skip:( -Not ( Test-LocalDbUtility )) {

        It 'Returns values' {
            $Instance = New-LocalDbInstance

            $Instance | Should -Not -BeNullOrEmpty
            $Instance.Name | Should -Not -BeNullOrEmpty
            $Instance.Version | Should -Not -BeNullOrEmpty
        }

        AfterEach {
            if ( $Instance ) {
                $Instance | Remove-LocalDbInstance
            }
        }

        BeforeDiscovery {
            $PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context PsSqlClient -Skip:( -Not $PsSqlClient ) {

            BeforeAll {
                $Instance = New-LocalDbInstance
            }

            It 'Connects by DataSource' {
                $SqlConnection = Connect-TSqlInstance -DataSource "(LocalDb)\$( $Instance.Name )" -ConnectTimeout 30
            }

            AfterEach {
                if ( $SqlConnection ) {
                    Disconnect-TSqlInstance -Connection $SqlConnection
                }
            }
        }
    }
}
