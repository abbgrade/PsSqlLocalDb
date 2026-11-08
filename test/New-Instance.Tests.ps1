#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context 'UnitTests' {
        It 'does not query the instance after a failed create command' -Tag UnitTest {
            # Arrange
            Mock -CommandName sqllocaldb -MockWith {
                $global:LASTEXITCODE = 1
                'create failed'
            } -ModuleName PsSqlLocalDb

            # Act
            $result = New-LocalDbInstance -Name 'FailedCreate' -ErrorAction SilentlyContinue

            # Assert
            $result | Should -BeNullOrEmpty
            Should -Invoke -CommandName sqllocaldb -ModuleName PsSqlLocalDb -Times 1 -Exactly
        }

        It 'does not create an instance when WhatIf is specified' -Tag UnitTest {
            # Arrange
            Mock -CommandName sqllocaldb -MockWith {
                throw 'sqllocaldb should not be invoked'
            } -ModuleName PsSqlLocalDb

            # Act
            New-LocalDbInstance -Name 'WhatIfInstance' -WhatIf

            # Assert
            Should -Invoke -CommandName sqllocaldb -ModuleName PsSqlLocalDb -Times 0 -Exactly
        }
    }

    Context 'IntegrationTests' {
        It 'returns values for a new LocalDB instance' -Tag IntegrationTest {
            # Act
            $Instance = New-LocalDbInstance

            # Assert
            $Instance | Should -Not -BeNullOrEmpty
            $Instance.Name | Should -Not -BeNullOrEmpty
            $Instance.Version | Should -Not -BeNullOrEmpty
            $Instance | Remove-LocalDbInstance
        }

        It 'returns values with a null version' -Tag IntegrationTest {
            # Act
            $Instance = New-LocalDbInstance -Version:$null

            # Assert
            $Instance | Should -Not -BeNullOrEmpty
            $Instance.Name | Should -Not -BeNullOrEmpty
            $Instance.Version | Should -Not -BeNullOrEmpty
            $Instance | Remove-LocalDbInstance
        }

        Context 'Version' {
            BeforeAll {
                $Version = Get-LocalDbVersion | Select-Object -First 1 -ExpandProperty Version
            }

            It 'creates with a specified full version' -Tag IntegrationTest {
                # Arrange
                $expectedVersion = $Version

                # Act
                $Instance = New-LocalDbInstance -Version $expectedVersion

                # Assert
                $Instance | Should -Not -BeNullOrEmpty
                $Instance.Name | Should -Not -BeNullOrEmpty
                $Instance.Version | Should -Be $expectedVersion
                $Instance | Remove-LocalDbInstance
            }

            It 'creates with a specified major.minor version' -Tag IntegrationTest {
                # Arrange
                $versionInput = "$( $Version.Major ).$( $Version.Minor )"

                # Act
                $Instance = New-LocalDbInstance -Version $versionInput

                # Assert
                $Instance | Should -Not -BeNullOrEmpty
                $Instance.Name | Should -Not -BeNullOrEmpty
                $Instance.Version | Should -Be $Version
                $Instance | Remove-LocalDbInstance
            }

            It 'creates with a specified major.minor.build version' -Tag IntegrationTest {
                # Arrange
                $versionInput = "$( $Version.Major ).$( $Version.Minor ).$( $Version.Build )"

                # Act
                $Instance = New-LocalDbInstance -Version $versionInput

                # Assert
                $Instance | Should -Not -BeNullOrEmpty
                $Instance.Name | Should -Not -BeNullOrEmpty
                $Instance.Version | Should -Be $Version
                $Instance | Remove-LocalDbInstance
            }
        }

        It 'accepts a null version object' -Tag IntegrationTest {
            # Arrange
            [System.Version] $Version = $null

            # Act
            $Instance = New-LocalDbInstance -Version:$Version

            # Assert
            $Instance | Should -Not -BeNullOrEmpty
            $Instance.Name | Should -Not -BeNullOrEmpty
            $Instance | Remove-LocalDbInstance
        }

        It 'throws with an unavailable version' -Tag IntegrationTest {
            # Act
            $action = {
                New-LocalDbInstance -Version 47.11
            }

            # Assert
            $action | Should -Throw
        }

        BeforeDiscovery {
            $PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context 'PsSqlClient' -Skip:( -Not $PsSqlClient ) {
            BeforeAll {
                $Instance = New-LocalDbInstance
            }

            AfterEach {
                if ( $SqlConnection ) {
                    Disconnect-TSqlInstance -Connection $SqlConnection
                }
                if ( $Instance ) {
                    $Instance | Remove-LocalDbInstance
                }
            }

            It 'connects by DataSource' -Tag IntegrationTest {
                # Arrange
                $instanceName = $Instance.Name

                # Act
                $SqlConnection = Connect-TSqlInstance -DataSource "(LocalDb)\$( $instanceName )" -ConnectTimeout 30

                # Assert
                $SqlConnection | Should -Not -BeNullOrEmpty
            }
        }
    }
}
