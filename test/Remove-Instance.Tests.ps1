#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Remove-Instance' {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context 'LocalDb' -Skip:( -Not ( Test-LocalDbUtility )) {
        BeforeEach {
            $Script:Instance = New-LocalDbInstance
        }

        It 'removes a running instance' {
            $Script:Instance | Remove-LocalDbInstance
            {
                Connect-TSqlInstance -DataSource "(LocalDb)\$( $Script:Instance.Name )"
            } | Should -Throw -Because 'a removed instance should not be used for connections'
        }

        It 'removes a stopped instance' {

            $Script:Instance | Stop-LocalDbInstance
            $Script:Instance | Remove-LocalDbInstance
            {
                Connect-TSqlInstance -DataSource "(LocalDb)\$( $Script:Instance.Name )"
            } | Should -Throw -Because 'a removed instance should not be used for connections'
        }
    }
}