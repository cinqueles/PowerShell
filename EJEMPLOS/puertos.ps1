<#
SCRIPT DE EJEMPLO
AUTOR: ISMAEL MORILLA
FECHA: 3/2/2021
DESCRIPCIÓN: SCRIPT QUE TE PIDE UN PUERTO LOCAL IDENTIFICANDO EL PROCESO AL QUE PERTENECE.
#>

Clear-Host

#MOSTRAR LOS PUERTOS
Get-NetTCPConnection | ft LocalPort, State 

#Petición del puerto a identificar
$localp = Read-Host 'Indique el puerto local que quiere identificar:' 

#Identificación de la ID del proceso propietario
$id = (Get-NetTCPConnection | Where-Object {$_.LocalPort -eq $localp}).OwningProcess | Get-Unique

#Identificación del proceso
$proces =(Get-Process | Where-Object {$_.Id -eq $id})

Write-Host 'El puerto ' $localp ' está asignado al servicio/proceso' $proces