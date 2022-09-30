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

        Context Version {

            BeforeAll {
                $Version = Get-LocalDbVersion | Select-Object -First 1 -ExpandProperty Version
            }

            It 'Creates with specified full version' {
                $Instance = New-LocalDbInstance -Version $Version

                $Instance | Should -Not -BeNullOrEmpty
                $Instance.Name | Should -Not -BeNullOrEmpty
                $Instance.Version | Should -Be $Version
            }

            It 'Creates with specified major.minor version' {
                $Instance = New-LocalDbInstance -Version "$( $Version.Major ).$( $Version.Minor )"

                $Instance | Should -Not -BeNullOrEmpty
                $Instance.Name | Should -Not -BeNullOrEmpty
                $Instance.Version | Should -Be $Version
            }

            It 'Creates with specified major.minor.build version' {
                $Instance = New-LocalDbInstance -Version "$( $Version.Major ).$( $Version.Minor ).$( $Version.Build )"

                $Instance | Should -Not -BeNullOrEmpty
                $Instance.Name | Should -Not -BeNullOrEmpty
                $Instance.Version | Should -Be $Version
            }
        }

        It 'Throws with unavailable version' {
            {
                New-LocalDbInstance -Version 47.11
            } | Should -Throw
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
