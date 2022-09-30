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
            $Instance | Remove-LocalDbInstance
            {
                Connect-TSqlInstance -DataSource "(LocalDb)\$( $Instance.Name )"
            } | Should -Throw -Because 'a removed instance should not be used for connections'
        }

        It 'removes a stopped instance' {

            $Instance | Stop-LocalDbInstance
            $Instance | Remove-LocalDbInstance
            {
                Connect-TSqlInstance -DataSource "(LocalDb)\$( $Instance.Name )"
            } | Should -Throw -Because 'a removed instance should not be used for connections'
        }
    }
}
