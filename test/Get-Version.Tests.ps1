#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Get-Version {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    It 'Returns values' {
        $result = Get-LocalDbVersion

        $result | Should -Not -BeNullOrEmpty
        $result | ForEach-Object {
            $result.Name | Should -Not -BeNullOrEmpty
            $result.Version | Should -Not -BeNullOrEmpty
            $result.Version | Should -BeOfType System.Version
        }
    }

}
