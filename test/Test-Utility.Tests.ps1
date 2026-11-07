#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Test-Utility {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    It 'returns true when the utility runs' {
        # Arrange
        Mock -CommandName sqllocaldb -MockWith { 'LocalDB utility output' } -ModuleName PsSqlLocalDb

        # Act
        $result = Test-LocalDbUtility

        # Assert
        $result | Should -BeTrue
        Should -Invoke -CommandName sqllocaldb -ModuleName PsSqlLocalDb -Times 1 -Exactly
    }

    It 'returns false when the utility cannot run' {
        # Arrange
        Mock -CommandName sqllocaldb -MockWith { throw 'utility unavailable' } -ModuleName PsSqlLocalDb

        # Act
        $result = Test-LocalDbUtility

        # Assert
        $result | Should -BeFalse
        Should -Invoke -CommandName sqllocaldb -ModuleName PsSqlLocalDb -Times 1 -Exactly
    }

    It 'detects the installed LocalDB utility' {
        # Act
        $result = Test-LocalDbUtility

        # Assert
        $result | Should -BeTrue
    }

}
