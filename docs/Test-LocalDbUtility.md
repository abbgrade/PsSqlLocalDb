---
external help file: PsSqlLocalDb-help.xml
Module Name: PsSqlLocalDb
online version: https://abbgrade.github.io/PsSqlLocalDb/docs/Test-LocalDbUtility.html
schema: 2.0.0
---

# Test-LocalDbUtility

## SYNOPSIS
Tests whether the SqlLocalDB utility is available.

## SYNTAX

```
Test-LocalDbUtility [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Runs the SqlLocalDB versions command and returns $true if it succeeds,
otherwise returns $false.
Requires SQL Server LocalDB to be installed.

## EXAMPLES

### EXAMPLE 1
```
Import-Module PsSqlLocalDb
PS> Test-LocalDbUtility
```

Tests whether the LocalDB utility is available.
The output is True when the
utility runs successfully and False otherwise; the result depends on the
machine configuration.

True

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

### bool
## NOTES

## RELATED LINKS

[https://abbgrade.github.io/PsSqlLocalDb/docs/Test-LocalDbUtility.html](https://abbgrade.github.io/PsSqlLocalDb/docs/Test-LocalDbUtility.html)

[https://learn.microsoft.com/en-us/sql/tools/sqllocaldb-utility](https://learn.microsoft.com/en-us/sql/tools/sqllocaldb-utility)

