<#
SCRIPT DE EJEMPLO
AUTOR: ISMAEL MORILLA
FECHA: 3/2/2021
DESCRIPCIÓN: EJEMPLO DE ESTRUCTRUAS IF.
#>
clear-host
Write-Host 'Introduce un número y te indicará si es grande o chico'
$num = Read-Host 'Introduce un número'

if ( $num -gt 5 ){
    Write-Host 'El número introducido es grande' -ForegroundColor Green
}
else {
    Write-Host 'El número introducido es pequeño' -ForegroundColor Red
}