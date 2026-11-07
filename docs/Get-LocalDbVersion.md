---
external help file: PsSqlLocalDb-help.xml
Module Name: PsSqlLocalDb
online version:
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

## EXAMPLES

### EXAMPLE 1
```
Get-LocalDbVersion
```

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

## NOTES

## RELATED LINKS
