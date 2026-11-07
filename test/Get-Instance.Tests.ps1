#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Get-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context FirstInstance {
        BeforeAll {
            $FirstInstance = New-LocalDbInstance
        }

        AfterAll {
            $FirstInstance | Remove-LocalDbInstance
        }

        Context LocalDb {

            It 'Returns values' {
                # Act
                $result = Get-LocalDbInstance

                # Assert
                $result | Should -Not -BeNullOrEmpty
                $result.Name | Should -Not -BeNullOrEmpty
            }

            Context NewInstance {
                BeforeAll {
                    $Instance = New-LocalDbInstance
                }

                AfterAll {
                    $Instance | Remove-LocalDbInstance
                }

                It 'Returns a specific instance' {
                    # Arrange
                    $instanceName = $Instance.Name

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
    }
}
