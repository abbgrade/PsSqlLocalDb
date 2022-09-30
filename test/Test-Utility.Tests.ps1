#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Test-Utility {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    It works {
        Test-LocalDbUtility | Should -BeIn $true, $false
    }

}
