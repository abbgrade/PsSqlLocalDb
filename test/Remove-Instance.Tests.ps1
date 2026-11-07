#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context LocalDb {
        AfterEach {
            if ($Instance -and (Get-LocalDbInstance | Where-Object Name -EQ $Instance.Name)) {
                $Instance | Remove-LocalDbInstance -ErrorAction Stop
            }
        }

        It 'removes a <State> instance' -TestCases @(
            @{ State = 'running'; StopBeforeRemoval = $false }
            @{ State = 'stopped'; StopBeforeRemoval = $true }
        ) {
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
