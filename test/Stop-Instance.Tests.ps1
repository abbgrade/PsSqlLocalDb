#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Stop-Instance {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlLocalDb.psd1 -Force -ErrorAction Stop
    }

    Context LocalDb -Skip:( -Not ( Test-LocalDbUtility )) {
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
                $Instance | Stop-LocalDbInstance

                Connect-TSqlInstance -DataSource "(LocalDb)\$( $Instance.Name )"
            }

            It 'Stops used instance' {
                Connect-TSqlInstance -DataSource "(LocalDb)\$( $Instance.Name )"

                $Instance | Stop-LocalDbInstance -Force
            }
        }
    }
}
