---
external help file: PsSqlLocalDb-help.xml
Module Name: PsSqlLocalDb
online version: https://abbgrade.github.io/PsSqlLocalDb/docs/Get-LocalDbInstance.html
schema: 2.0.0
---

# Get-LocalDbInstance

## SYNOPSIS
Gets SQL Server LocalDB instance details.

## SYNTAX

### All (Default)
```
Get-LocalDbInstance [-Version <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Single
```
Get-LocalDbInstance [-Name <String>] [-Version <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Lists available LocalDB instances or gets details for one named instance.
Each result contains the instance name, SQL Server version as a System.Version
value when available, and the named pipe when available.
Use Version to
filter by a version prefix.
Requires SQL Server LocalDB to be installed.

## EXAMPLES

### EXAMPLE 1
```
Import-Module PsSqlLocalDb
PS> Get-LocalDbInstance -Name 'MSSQLLocalDB'
```

Gets details for the MSSQLLocalDB instance.
Requires SQL Server LocalDB to
be installed.
Example output is abbreviated and illustrative; the version and pipe name
vary by machine.

Name         Version    NamedPipe
----         -------    ---------
MSSQLLocalDB 15.0.4153.1 machine-specific

## PARAMETERS

### -Name
Gets details for this named instance.
If omitted, lists all instances.

```yaml
Type: String
Parameter Sets: Single
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Filters results by a SQL Server version prefix, such as '15.0'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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
### An instance with Name, Version, and NamedPipe properties.
## NOTES

## RELATED LINKS

[https://abbgrade.github.io/PsSqlLocalDb/docs/Get-LocalDbInstance.html](https://abbgrade.github.io/PsSqlLocalDb/docs/Get-LocalDbInstance.html)

[https://learn.microsoft.com/en-us/sql/tools/sqllocaldb-utility](https://learn.microsoft.com/en-us/sql/tools/sqllocaldb-utility)

