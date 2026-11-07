#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Test-Utility {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    It 'returns true when the utility runs' -Tag UnitTest {
        # Arrange
        Mock -CommandName sqllocaldb -MockWith {
            $global:LASTEXITCODE = 0
            'LocalDB utility output'
        } -ModuleName PsSqlLocalDb

        # Act
        $result = Test-LocalDbUtility

        # Assert
        $result | Should -BeTrue
        Should -Invoke -CommandName sqllocaldb -ModuleName PsSqlLocalDb -Times 1 -Exactly
    }

    It 'returns false when the utility cannot run' -Tag UnitTest {
        # Arrange
        Mock -CommandName sqllocaldb -MockWith { throw 'utility unavailable' } -ModuleName PsSqlLocalDb

        # Act
        $result = Test-LocalDbUtility

        # Assert
        $result | Should -BeFalse
        Should -Invoke -CommandName sqllocaldb -ModuleName PsSqlLocalDb -Times 1 -Exactly
    }

    It 'returns false when the utility exits unsuccessfully' -Tag UnitTest {
        Mock -CommandName sqllocaldb -MockWith {
            $global:LASTEXITCODE = 1
            'utility failed'
        } -ModuleName PsSqlLocalDb

        Test-LocalDbUtility | Should -BeFalse
    }

    It 'detects the installed LocalDB utility' -Tag IntegrationTest {
        # Act
        $result = Test-LocalDbUtility

        # Assert
        $result | Should -BeTrue
    }

}
