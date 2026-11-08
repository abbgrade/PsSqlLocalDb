---
external help file: PsSqlLocalDb-help.xml
Module Name: PsSqlLocalDb
online version: https://abbgrade.github.io/PsSqlLocalDb/docs/Get-LocalDbVersion.html
schema: 2.0.0
---

# Get-LocalDbVersion

## SYNOPSIS
Gets installed SQL Server LocalDB versions.

## SYNTAX

```
Get-LocalDbVersion [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns the names and version numbers of SQL Server LocalDB versions
installed on the computer.
These versions can be used when creating
instances with New-LocalDbInstance.
Requires SQL Server LocalDB to be
installed.

## EXAMPLES

### EXAMPLE 1
```
Import-Module PsSqlLocalDb
PS> Get-LocalDbVersion
```

Lists the LocalDB versions installed on this computer.
The following output
is illustrative; installed versions vary by machine.

Name                      Version
----                      -------
Microsoft SQL Server 2016 13.1.4001.0
Microsoft SQL Server 2019 15.0.4153.1

## PARAMETERS

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
### An installed LocalDB version with Name and Version properties.
## NOTES

## RELATED LINKS

[https://abbgrade.github.io/PsSqlLocalDb/docs/Get-LocalDbVersion.html](https://abbgrade.github.io/PsSqlLocalDb/docs/Get-LocalDbVersion.html)

[https://learn.microsoft.com/en-us/sql/tools/sqllocaldb-utility](https://learn.microsoft.com/en-us/sql/tools/sqllocaldb-utility)

