#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context LocalDb {
        BeforeEach {
            $Instance = New-LocalDbInstance
        }

        It 'removes a running instance' {
            # Arrange
            $instanceName = $Instance.Name

            # Act
            $Instance | Remove-LocalDbInstance

            # Assert
            $remainingInstances = @(Get-LocalDbInstance | Where-Object Name -EQ $instanceName)
            $remainingInstances | Should -BeNullOrEmpty
        }

        It 'removes a stopped instance' {
            # Arrange
            $instanceName = $Instance.Name

            # Act
            $Instance | Stop-LocalDbInstance
            $Instance | Remove-LocalDbInstance

            # Assert
            $remainingInstances = @(Get-LocalDbInstance | Where-Object Name -EQ $instanceName)
            $remainingInstances | Should -BeNullOrEmpty
        }
    }
}
