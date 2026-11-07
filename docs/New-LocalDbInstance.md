---
external help file: PsSqlLocalDb-help.xml
Module Name: PsSqlLocalDb
online version:
schema: 2.0.0
---

# New-LocalDbInstance

## SYNOPSIS
Creates and starts a SQL Server LocalDB instance.

## SYNTAX

```
New-LocalDbInstance [[-Name] <String>] [[-Version] <String>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a LocalDB instance, starts it, and returns its instance details.
If no name is specified, a random name is generated.
Use Get-LocalDbVersion
to see the installed versions that can be used with the Version parameter.
Supports ShouldProcess, so use -WhatIf to preview the operation or
-Confirm to be prompted before it runs.

## EXAMPLES

### EXAMPLE 1
```
New-LocalDbInstance -Name 'foobar'
```

Creates and starts an instance named 'foobar', then returns its details.

### EXAMPLE 2
```
New-LocalDbInstance -Name 'foobar' -WhatIf
```

Shows the create operation without creating or starting the instance.

## PARAMETERS

### -Name
Name for the new instance; defaults to a random eight-character name.

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
Installed SQL Server LocalDB version to use; defaults to SqlLocalDB's version.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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
