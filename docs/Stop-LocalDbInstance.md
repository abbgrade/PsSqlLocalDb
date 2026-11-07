---
external help file: PsSqlLocalDb-help.xml
Module Name: PsSqlLocalDb
online version:
schema: 2.0.0
---

# Stop-LocalDbInstance

## SYNOPSIS
Stops a SQL Server LocalDB instance.

## SYNTAX

```
Stop-LocalDbInstance [-Name] <String> [-Force] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Stops the specified instance using the SqlLocalDB utility.
Use Force to
terminate processes that are accessing the instance.
Supports ShouldProcess,
so use -WhatIf to preview the operation or -Confirm to be prompted before it
runs.

## EXAMPLES

### EXAMPLE 1
```
$instance = New-LocalDbInstance
PS> $instance | Stop-LocalDbInstance
```

Stops the instance represented by the object.

### EXAMPLE 2
```
Stop-LocalDbInstance -Name 'foobar' -WhatIf
```

Shows the stop operation without stopping the instance.

## PARAMETERS

### -Name
Name of the LocalDB instance to stop; accepts instance objects by Name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force
Terminates processes accessing the instance so it can be stopped.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
