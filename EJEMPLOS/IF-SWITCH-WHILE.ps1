<#
SCRIPT DE EJEMPLO
AUTOR: ISMAEL MORILLA
FECHA: 3/2/2021
DESCRIPCIÓN: EJEMPLO DE ESTRUCTRUAS IF, SWITCH Y WHILE.
#>



# PRUEBA IF
Clear-Host
[int]$opcion= Read-Host 'elige opcion {1-5}'

if ( $opcion -le 5 ) {
    #SWITCH PARA OPCIONES DEL MENÚ
    switch ( $opcion ) {
        1 {"hola"}
        2 {"adios"}
        3 {"hola"}
        4 {"adios"}
        5 {"hola"}
    }

}else{
    while ( $opcion -gt 5 ) {
        Write-Host 'incorrecto'
        [int]$opcion= Read-Host 'elige opcion {1-5}'

        # para ver si es menor o igual que 5
        # SWTICH PARA OPCIONES DEL MENÚ
        if  ( $opcion -le 5 ) {
            switch ( $opcion ) {
                1 {"hola"}
                2 {"adios"}
                3 {"hola"}
                4 {"adios"}
                5 {"hola"}
            }
        }
    }

}