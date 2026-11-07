#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Get-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context 'UnitTests' {
        It 'parses fields by label and matches version components exactly' -Tag UnitTest {
            # Arrange
            Mock -CommandName sqllocaldb -MockWith {
                $global:LASTEXITCODE = 0
                if ($args.Count -eq 1) {
                    'TestInstance'
                    return
                }

                @(
                    'State: Stopped'
                    'Instance pipe name: np:\\.\pipe\LOCALDB#123\tsql\query'
                    'Version: 15.0.4153.1'
                    'Name: TestInstance'
                )
            } -ModuleName PsSqlLocalDb

            # Act
            $result = @(Get-LocalDbInstance -Version '15.0')

            # Assert
            $result.Count | Should -Be 1
            $result[0].Name | Should -Be 'TestInstance'
            $result[0].Version | Should -Be ([version]'15.0.4153.1')
            $result[0].NamedPipe | Should -Be 'np:\\.\pipe\LOCALDB#123\tsql\query'
            @(Get-LocalDbInstance -Version '15.0.41530').Count | Should -Be 0
        }

        It 'reports a failed utility command' -Tag UnitTest {
            # Arrange
            Mock -CommandName sqllocaldb -MockWith {
                $global:LASTEXITCODE = 1
                'utility failed'
            } -ModuleName PsSqlLocalDb

            # Act
            $result = Get-LocalDbInstance -ErrorAction SilentlyContinue

            # Assert
            $result | Should -BeNullOrEmpty
            Should -Invoke -CommandName sqllocaldb -ModuleName PsSqlLocalDb -Times 1 -Exactly
        }
    }

    Context 'IntegrationTests' {
        BeforeAll {
            $FirstInstance = New-LocalDbInstance
        }

        AfterAll {
            $FirstInstance | Remove-LocalDbInstance
        }

        It 'returns values for all available instances' -Tag IntegrationTest {
            # Act
            $result = Get-LocalDbInstance

            # Assert
            $result | Should -Not -BeNullOrEmpty
            $result.Name | Should -Not -BeNullOrEmpty
        }

        It 'returns a specific instance' -Tag IntegrationTest {
            # Arrange
            $instanceName = $FirstInstance.Name

            # Act
            $result = Get-LocalDbInstance -Name $instanceName

            # Assert
            $result.Count | Should -Be 1
            $result.Name | Should -Be $instanceName
            $result.Version | Should -Not -BeNullOrEmpty
            $result.Version | Should -BeOfType System.Version
        }
    }
}
