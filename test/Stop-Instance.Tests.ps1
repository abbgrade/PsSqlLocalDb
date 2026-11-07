#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Stop-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context LocalDb {
        BeforeEach {
            $Instance = New-LocalDbInstance
        }

        AfterEach {
            $Instance | Remove-LocalDbInstance
        }

        BeforeDiscovery {
            $PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context PsSqlClient -Skip:( -Not $PsSqlClient ) {

            It 'Stops the instance' {
                # Arrange
                $instanceName = $Instance.Name

                # Act
                $Instance | Stop-LocalDbInstance

                # Assert
                Connect-TSqlInstance -DataSource "(LocalDb)\$( $instanceName )"
            }

            It 'Stops used instance' {
                # Arrange
                $instanceName = $Instance.Name
                Connect-TSqlInstance -DataSource "(LocalDb)\$( $instanceName )"

                # Act
                $Instance | Stop-LocalDbInstance -Force
            }
        }
    }
}
