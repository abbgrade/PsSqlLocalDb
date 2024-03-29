---
external help file: PsSqlLocalDb-help.xml
Module Name: PsSqlLocalDb
online version:
schema: 2.0.0
---

# Get-LocalDbInstance

## SYNOPSIS
Returns connection parameters to a available localDb.

## SYNTAX

### All (Default)
```
Get-LocalDbInstance [-Version <String>] [<CommonParameters>]
```

### Single
```
Get-LocalDbInstance [-Name <String>] [-Version <String>] [<CommonParameters>]
```

## DESCRIPTION
Uses \[SqlLocalDB Utility\](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15) to get info about the available local db.

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

## PARAMETERS

### -Name
Filters by name of the sql server instance.

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
Filters by version of the sql server instance.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
