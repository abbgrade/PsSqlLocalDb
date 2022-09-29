---
external help file: PsSqlLocalDb-help.xml
Module Name: PsSqlLocalDb
online version:
schema: 2.0.0
---

# New-LocalDbInstance

## SYNOPSIS
Creates a new sqllocaldb instance.

## SYNTAX

```
New-LocalDbInstance [[-Name] <String>] [[-Version] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
New-LocalDbInstance -Name 'foobar'
```

\[PSCustomObject\]

Name                           Value
----                           -----
Name                           foobar
Version                        15.0.4153.1

## PARAMETERS

### -Name
Specifies the name of the instance to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: ( [string](New-Guid) ).Substring(0, 8)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Specifies the sql server version to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
