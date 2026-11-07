#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context LocalDb {

        It 'Returns values' {
            # Act
            $Instance = New-LocalDbInstance

            # Assert
            $Instance | Should -Not -BeNullOrEmpty
            $Instance.Name | Should -Not -BeNullOrEmpty
            $Instance.Version | Should -Not -BeNullOrEmpty
        }

        It 'Returns values with null version' {
            # Act
            $Instance = New-LocalDbInstance -Version:$null

            # Assert
            $Instance | Should -Not -BeNullOrEmpty
            $Instance.Name | Should -Not -BeNullOrEmpty
            $Instance.Version | Should -Not -BeNullOrEmpty
        }

        Context Version {

            BeforeAll {
                $Version = Get-LocalDbVersion | Select-Object -First 1 -ExpandProperty Version
            }

            It 'Creates with specified full version' {
                # Arrange
                $expectedVersion = $Version

                # Act
                $Instance = New-LocalDbInstance -Version $expectedVersion

                # Assert
                $Instance | Should -Not -BeNullOrEmpty
                $Instance.Name | Should -Not -BeNullOrEmpty
                $Instance.Version | Should -Be $expectedVersion
            }

            It 'Creates with specified major.minor version' {
                # Arrange
                $versionInput = "$( $Version.Major ).$( $Version.Minor )"

                # Act
                $Instance = New-LocalDbInstance -Version $versionInput

                # Assert
                $Instance | Should -Not -BeNullOrEmpty
                $Instance.Name | Should -Not -BeNullOrEmpty
                $Instance.Version | Should -Be $Version
            }

            It 'Creates with specified major.minor.build version' {
                # Arrange
                $versionInput = "$( $Version.Major ).$( $Version.Minor ).$( $Version.Build )"

                # Act
                $Instance = New-LocalDbInstance -Version $versionInput

                # Assert
                $Instance | Should -Not -BeNullOrEmpty
                $Instance.Name | Should -Not -BeNullOrEmpty
                $Instance.Version | Should -Be $Version
            }
        }

        Context EmptyVersion {
            It works {
                # Arrange
                [System.Version] $Version = $null

                # Act
                $Instance = New-LocalDbInstance -Version:$Version

                # Assert
            }
        }

        It 'Throws with unavailable version' {
            # Act
            $action = {
                New-LocalDbInstance -Version 47.11
            }

            # Assert
            $action | Should -Throw
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
                # Arrange
                $instanceName = $Instance.Name

                # Act
                $SqlConnection = Connect-TSqlInstance -DataSource "(LocalDb)\$( $instanceName )" -ConnectTimeout 30

                # Assert
            }

            AfterEach {
                if ( $SqlConnection ) {
                    Disconnect-TSqlInstance -Connection $SqlConnection
                }
            }
        }
    }
}
