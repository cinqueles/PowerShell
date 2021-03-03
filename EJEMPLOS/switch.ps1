<#
SCRIPT DE EJEMPLO
AUTOR: ISMAEL MORILLA
FECHA: 3/2/2021
DESCRIPCIÓN: EJEMPLO DE ESTRUCTRUAS SWITCH.
#>

Clear-Host
Write-Host 'Introduce un nº del 1 al 5 para saber tu futuro' `n
$opcion = Read-Host 'Hoy vas a ... {1-5}'

Write-Host `n

switch ($opcion){

    1 {'Comer zanahorias'}
    2 {'Ir al futbol'}
    3 {'Hacer la cena'}
    4 {'Llorar'}
    5 {'Viajar'}
}