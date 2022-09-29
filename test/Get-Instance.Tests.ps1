#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Get-Instance {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context FirstInstance {
        BeforeAll {
            $FirstInstance = New-LocalDbInstance
        }

        AfterAll {
            $FirstInstance | Remove-LocalDbInstance
        }

        Context LocalDb -Skip:( -Not ( Test-LocalDbUtility )) {

            It 'Returns values' {
                $result = Get-LocalDbInstance

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
                    $result = Get-LocalDbInstance -Name $Instance.Name
                    $result.Count | Should -Be 1
                    $result.Name | Should -Be $Instance.Name
                    $result.Version | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}
