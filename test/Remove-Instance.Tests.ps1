#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context 'UnitTests' {
        It 'does not delete an instance when stopping it fails' -Tag UnitTest {
            # Arrange
            Mock -CommandName sqllocaldb -MockWith {
                $global:LASTEXITCODE = 1
                'stop failed'
            } -ModuleName PsSqlLocalDb

            # Act
            $action = { Remove-LocalDbInstance -Name 'TestInstance' -ErrorAction Stop }

            # Assert
            $action | Should -Throw
            Should -Invoke -CommandName sqllocaldb -ModuleName PsSqlLocalDb -Times 1 -Exactly
        }

        It 'does not stop or delete an instance when WhatIf is specified' -Tag UnitTest {
            # Arrange
            Mock -CommandName sqllocaldb -MockWith {
                throw 'sqllocaldb should not be invoked'
            } -ModuleName PsSqlLocalDb

            # Act
            Remove-LocalDbInstance -Name 'TestInstance' -WhatIf

            # Assert
            Should -Invoke -CommandName sqllocaldb -ModuleName PsSqlLocalDb -Times 0 -Exactly
        }
    }

    Context 'IntegrationTests' {
        AfterEach {
            if ($Instance -and (Get-LocalDbInstance | Where-Object Name -EQ $Instance.Name)) {
                $Instance | Remove-LocalDbInstance -ErrorAction Stop
            }
        }

        It 'removes a <State> instance' -TestCases @(
            @{ State = 'running'; StopBeforeRemoval = $false }
            @{ State = 'stopped'; StopBeforeRemoval = $true }
        ) -Tag IntegrationTest {
            param($State, $StopBeforeRemoval)

            # Arrange
            $Instance = New-LocalDbInstance
            $instanceName = $Instance.Name
            if ($StopBeforeRemoval) {
                $Instance | Stop-LocalDbInstance -ErrorAction Stop
            }

            # Act
            $Instance | Remove-LocalDbInstance -ErrorAction Stop

            # Assert
            $remainingInstances = @(Get-LocalDbInstance | Where-Object Name -EQ $instanceName)
            $remainingInstances | Should -BeNullOrEmpty
        }
    }
}
