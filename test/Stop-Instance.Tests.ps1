#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Stop-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context 'UnitTests' {
        It 'reports a failed stop command' -Tag UnitTest {
            # Arrange
            Mock -CommandName sqllocaldb -MockWith {
                $global:LASTEXITCODE = 1
                'stop failed'
            } -ModuleName PsSqlLocalDb

            # Act
            $action = { Stop-LocalDbInstance -Name 'TestInstance' -ErrorAction Stop }

            # Assert
            $action | Should -Throw '*stop failed*'
        }

        It 'does not stop an instance when WhatIf is specified' -Tag UnitTest {
            # Arrange
            Mock -CommandName sqllocaldb -MockWith {
                throw 'sqllocaldb should not be invoked'
            } -ModuleName PsSqlLocalDb

            # Act
            Stop-LocalDbInstance -Name 'TestInstance' -WhatIf

            # Assert
            Should -Invoke -CommandName sqllocaldb -ModuleName PsSqlLocalDb -Times 0 -Exactly
        }
    }

    Context 'IntegrationTests' {
        BeforeEach {
            $Instance = New-LocalDbInstance
        }

        AfterEach {
            $Instance | Remove-LocalDbInstance
        }

        BeforeDiscovery {
            $PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context 'PsSqlClient' -Skip:( -Not $PsSqlClient ) {
            It 'stops the instance' -Tag IntegrationTest {
                # Arrange
                $instanceName = $Instance.Name

                # Act
                $Instance | Stop-LocalDbInstance

                # Assert
                Connect-TSqlInstance -DataSource "(LocalDb)\$( $instanceName )"
            }

            It 'stops a used instance' -Tag IntegrationTest {
                # Arrange
                $instanceName = $Instance.Name
                Connect-TSqlInstance -DataSource "(LocalDb)\$( $instanceName )"

                # Act
                $Instance | Stop-LocalDbInstance -Force

                # Assert
                $true | Should -BeTrue
            }
        }
    }
}
