#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Get-Instance' {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context 'First Instance' {
        BeforeAll {
            $Script:FirstInstance = New-LocalDbInstance
        }

        AfterAll {
            $Script:FirstInstance | Remove-LocalDbInstance
        }

        Context 'LocalDb' -Skip:( -Not ( Test-LocalDbUtility )) {

            It 'Returns values' {
                $result = Get-LocalDbInstance

                $result | Should -Not -BeNullOrEmpty
                $result.Name | Should -Not -BeNullOrEmpty
            }

            Context 'New Instance' {
                BeforeAll {
                    $Script:Instance = New-LocalDbInstance
                }

                AfterAll {
                    $Script:Instance | Remove-LocalDbInstance
                }

                It 'Returns a specific instance' {
                    $result = Get-LocalDbInstance -Name $Script:Instance.Name
                    $result.Count | Should -Be 1
                    $result.Name | Should -Be $Script:Instance.Name
                    $result.Version | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}
