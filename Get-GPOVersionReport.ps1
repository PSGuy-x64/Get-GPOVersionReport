<#
.SYNOPSIS
    GPO Version report

.DESCRIPTION
    Export GPO version report from all DCs.

.PARAMETER Param1
    guid.

.EXAMPLE
    PS .\Get-GPOVersionReport.ps1 - guid 'b789c396-0ae1-4cf6-8cf4-80e9e7065037'

.INPUTS
    NA

.OUTPUTS
    'GpoReport.csv'

.NOTES
    Author            : Ahmed Samir.
    Owner Contact     : ahmedsamir_x64@outlook.com.
    Version           : 1.0
    Script send mail  : False.
    Script export csv : true.
    Script Nick Name  : GPV

    Version 1.0 - 2023/01/01 by Ahmed Samir, initial release.
#>


#---------------------------------------------------------[      Parameters   ]--------------------------------------------------------
[cmdletbinding()]
Param (
[Parameter(Mandatory=$true)]
[string]$guid
)

#---------------------------------------------------------[   Initialisations  ]--------------------------------------------------------
 $results = New-Object System.Collections.ArrayList

 $i       = 1
#---------------------------------------------------------[     Functions      ]--------------------------------------------------------
 function main {
  foreach ($dc in (Get-ADDomainController -Filter * | select)) {
  Write-Host [$i] $DC.Name -f Green
  $Var1  = Get-GPO -GUID $guid -Server $dc.Name | select @{N='DomainController' ; E={$dc.Name}},
                                                         @{N='ADSite'           ; E={$dc.Site}},
                                                         @{N='userVersion'      ; E={$_.user.DSVersion}},
                                                         @{N='ComputerVersion'  ; E={$_.Computer.DSVersion}},
                                                         @{N='WmiFilter'        ; E={$_.WmiFilter.Description }},
                                                          CreationTime, ModificationTime,DisplayName, GpoStatus

   $properties = [ordered]@{
       I                = $i
       Policy           = $Var1.DisplayName
       DomainController = $Var1.DomainController
       Site             = $Var1.ADSite
       ComputerVersion  = $Var1.ComputerVersion
       UserVersion      = $Var1.UserVersion
       CreationTime     = $Var1.CreationTime
       ModificationTime = $Var1.ModificationTime
       GpoStatus        = $Var1.GpoStatus
       WmiFilter        = $Var1.WmiFilter }

   $results.add( (New-Object psobject -Property $properties) ) | Out-Null
   $i++}
   $results | ft      i, Policy, DomainController, Site, ComputerVersion, UserVersion, CreationTime, ModificationTime, GpoStatus, WmiFilter
   $results | select  i, Policy, DomainController, Site, ComputerVersion, UserVersion, CreationTime, ModificationTime, GpoStatus, WmiFilter | Export-Csv -NoTypeInformation GpoReport.csv -Force
 }

#---------------------------------------------------------[      Execution     ]--------------------------------------------------------
 main

 
#---------------------------------------------------------[      Notfication   ]--------------------------------------------------------


#---------------------------------------------------------[      Finish UP     ]--------------------------------------------------------
