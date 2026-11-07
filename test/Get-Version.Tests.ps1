#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Get-Version {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    It 'parses installed versions into named, typed results' -Tag UnitTest {
        # Arrange
        $utilityOutput = @(
            'Microsoft SQL Server 2019 (15.0.4153.1)'
            'Microsoft SQL Server 2022 (16.0.1000.6)'
        )
        Mock -CommandName sqllocaldb -MockWith {
            $global:LASTEXITCODE = 0
            $utilityOutput
        } -ModuleName PsSqlLocalDb

        # Act
        $result = Get-LocalDbVersion

        # Assert
        $result.Count | Should -Be 2
        $result[0].Name | Should -Be 'Microsoft SQL Server 2019'
        $result[0].Version | Should -Be ([version]'15.0.4153.1')
        $result[1].Name | Should -Be 'Microsoft SQL Server 2022'
        $result[1].Version | Should -Be ([version]'16.0.1000.6')
        foreach ($versionInfo in $result) {
            $versionInfo.Version | Should -BeOfType ([version])
        }
        Should -Invoke -CommandName sqllocaldb -ModuleName PsSqlLocalDb -Times 1 -Exactly
    }

    It 'warns about malformed output and reports nonzero exit codes' -Tag UnitTest {
        Mock -CommandName sqllocaldb -MockWith {
            $global:LASTEXITCODE = 0
            @('not a version', 'Microsoft SQL Server 2022 (16.0.1000.6)')
        } -ModuleName PsSqlLocalDb

        $result = Get-LocalDbVersion -WarningVariable warnings

        $result.Count | Should -Be 1
        $warnings | Should -Not -BeNullOrEmpty

        Mock -CommandName sqllocaldb -MockWith {
            $global:LASTEXITCODE = 2
            'utility failed'
        } -ModuleName PsSqlLocalDb

        $result = Get-LocalDbVersion -ErrorAction SilentlyContinue

        $result | Should -BeNullOrEmpty
    }

    It 'returns the versions installed by LocalDB' -Tag IntegrationTest {
        # Act
        $result = Get-LocalDbVersion

        # Assert
        $result | Should -Not -BeNullOrEmpty
        foreach ($versionInfo in $result) {
            $versionInfo.Name | Should -Not -BeNullOrEmpty
            $versionInfo.Version | Should -BeOfType ([version])
        }
    }

}
