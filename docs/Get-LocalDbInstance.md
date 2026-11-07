---
external help file: PsSqlLocalDb-help.xml
Module Name: PsSqlLocalDb
online version:
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
Each result includes the instance name and SQL Server version, and the named
pipe used to connect when available.
Use Version to filter by a version
prefix.

## EXAMPLES

### EXAMPLE 1
```
Get-LocalDbInstance
```

\[PSCustomObject\]

Name                           Value
----                           -----
Name                           MSSQLLocalDB
Version                        v11.0

Lists all available instances.

### EXAMPLE 2
```
Get-LocalDbInstance -Name 'MSSQLLocalDB'
```

Gets details for the MSSQLLocalDB instance.

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

## NOTES

## RELATED LINKS
