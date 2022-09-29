#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context LocalDb {

        It 'Returns values' {
            $Instance = New-LocalDbInstance

            $Instance | Should -Not -BeNullOrEmpty
            $Instance.Name | Should -Not -BeNullOrEmpty
            $Instance.Version | Should -Not -BeNullOrEmpty
        }

        It 'Creates with specified version' {
            $Instance = New-LocalDbInstance -Version 13.1.4001.0

            $Instance | Should -Not -BeNullOrEmpty
            $Instance.Name | Should -Not -BeNullOrEmpty
            $Instance.Version | Should -Be 13.1.4001.0
        }

        It 'Throws with unavailable version' {
            {
                New-LocalDbInstance -Version 47.11
            } | Should -Throw 'Cannot validate argument on parameter ''Version'''
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
