<#SCRIPT INFORME EQUIPO
 AUTOR: ISMAEL MORILLA
 VERSION: 1.0 
 FECHA: 2/3/2021
 DESCRIPCIÓN: ESTE SCRIPT TE SACARÁ POR PANTALLA TODA LA INFORMACIÓN NECESARIA 
              SOBRE EL EQUIPO WINDOWS EN EL QUE SE ESTÁ TRABAJANDO
              RED, HARDWARE, SOFTWARE, ETC... 
#>

<#ESTRUCTURA DE LOS FUNCTIONS
    Write-host '@@@@@ APARTADO:'
    $= ().

    `n
    Write-Host '##################################################################'
    `n
#>


############## funciones
$nombre= (Get-WmiObject -Class win32_computersystem).Name



function red {
    Clear-Host
    write-host '########### Análisis de red:' $nombre '#################' `n `n -ForegroundColor Yellow

    ## CONECTIVIDAD DE RED
    Write-Host '## Conectividad:' -ForegroundColor Yellow
    $conex= Test-Connection 8.8.8.8 -Quiet
    if ($conex -eq 'True'){
        Write-Host 'OK' `n -BackgroundColor Green 
    }
    else {
        Write-Host 'No Ping' `n -BackgroundColor Red
    }

    ## MOSTRAR LISTADO DE TARJETAS DE RED 
    Write-Host '## Listado de tarjetas de red' -ForegroundColor Yellow
    Get-NetAdapter | fl Name, ifOperStatus, MacAddress, DriverInformation, InterfaceDescription

    ## INDEX DE LAS INTERFACES PRINCIPALES (WIFI, ETHERNET)
    $ether = (Get-NetAdapter | Where-Object {$_.Name -like "Ethernet"}).ifIndex
    $wifi = (Get-NetAdapter | Where-Object {$_.Name -like "Wi-Fi"}).ifIndex


    #TABLA DE RUTA

    ## ETHERNET
    Write-Host '## Tabla de enrutamiento' `n -ForegroundColor Yellow 

    Write-Host 'ETHERNET' -ForegroundColor Yellow
    Get-NetRoute -InterfaceIndex $ether | ft DestinationPrefix, NextHop

    ## WIFI
    Write-Host 'WI-FI' -ForegroundColor Yellow
    Get-NetRoute -InterfaceIndex $wifi | ft DestinationPrefix, NextHop



}

function equipo {
    clear-host
   
   
    # datos del equipo 
    $archi= (Get-WmiObject -Class win32_operatingsystem).OSArchitecture
    $modelo= (Get-CimInstance -ClassName win32_computersystemproduct).Version
    $marca= (Get-WmiObject -Class win32_computersystem).Manufacturer
    $version= (Get-WmiObject -Class win32_operatingsystem).Version
    
    write-host '########### Análisis del equipo:' $nombre '#################' `n `n -ForegroundColor Yellow
    write-host ' ## Equipo' -ForegroundColor Yellow
    Write-Host 'Marca            :' $marca
    Write-Host 'Modelo           :' $modelo
    Write-Host 'Arquitectura     :' $archi
    write-host 'Version SO       :' $version `n
    
    
    
    #datos del disco duro
    Write-Host '## Disco duro '`n -ForegroundColor Yellow
    $estado= (Get-CimInstance -ClassName Win32_DiskDrive).Status
    $conex= (Get-CimInstance -ClassName Win32_DiskDrive).InterfaceType
    $model= (Get-CimInstance -ClassName Win32_DiskDrive).Model
    $sn= (Get-CimInstance -ClassName Win32_DiskDrive).SerialNumber

    
    if( $estado -eq 'OK' ){
        Write-Host 'Estado    :' $estado -BackgroundColor Green
    }
    else{
        Write-Host 'Estado    :' $estado -BackgroundColor Red
    }

    

    Write-Host 'Interface :' $conex
    Write-Host 'Modelo    :' $model
    Write-Host 'S/N       :' $sn `n


    #datos del procesador
    write-host '## Procesador:' -ForegroundColor Yellow
    Write-Host (Get-CimInstance -ClassName Win32_Processor).Name `n 

   
    # datos físicos de las tarjetas de red
    
    #ETHERNET
    $nombreE= (Get-NetAdapter | Where-Object {$_.Name -like 'Ethernet'}).Name
    $descripE= (Get-NetAdapter | Where-Object {$_.Name -like 'Ethernet'}).InterfaceDescription
    $macE= (Get-NetAdapter | Where-Object {$_.Name -like 'Ethernet'}).MacAddress
    #WIFI
    $nombreW= (Get-NetAdapter | Where-Object {$_.Name -like 'Wi-Fi'}).Name
    $descripW= (Get-NetAdapter | Where-Object {$_.Name -like 'Wi-Fi'}).InterfaceDescription
    $macW= (Get-NetAdapter | Where-Object {$_.Name -like 'Wi-Fi'}).MacAddress

    
    #MOSTRAR POR PANTALLA LOS DATOS  
    Write-Host '## Tarjetas de red:' -ForegroundColor Yellow `n
    Write-Host 'Tarjeta       :' $nombreE
    Write-Host 'Descripción   :' $descripE
    Write-Host 'MAC           :' $macE `n 

    Write-Host 'Tarjeta       :' $nombreW
    Write-Host 'Descripción   :' $descripW
    Write-Host 'MAC           :' $macW `n

     
    #último reinicio
    Write-Host '## Fecha del último reinicio del equipo:'  -ForegroundColor Yellow
    (Get-CimInstance -ClassName win32_operatingsystem).LastBootUpTime
    
    Write-Host `n
    Write-Host '##################################################################' -ForegroundColor Yellow
    Write-Host `n
}

function menu {
    Clear-Host
    write-host '##################################################################' `n
    Write-Host '                   SCRIPT DE INFORMACIÓN                     '
    Write-Host `n
    Write-Host '                  © Ismael Morilla - 2021'
    write-host '##################################################################'

    Write-Host '1. Información del equipo' 
    Write-Host '2. Información de la red'
    Write-Host '3. Información de los usuarios/grupos'
    Write-Host '4. Revisar logs del sistema'
    Write-Host '5. Recursos compartidos' 
    Write-Host 'q. Salir' `n

    $opcion = Read-Host '¿Qué desea realizar?'



    if ($opcion -eq 'q'){
        Clear-Host
        break
    }
    elseif ( $opcion -le 5 ) {
        #SWITCH PARA OPCIONES DEL MENÚ
        switch ( $opcion ) {
            1 {equipo}
            2 {red}
            3 {usu}
            4 {log}
            5 {recursos}
        }

    }
    else{
        while ( $opcion -gt 5 ) {
            Write-Host 'Opción incorrecta, por favor, introduzca una válida' -BackgroundColor Red -ForegroundColor White
            $opcion= Read-Host 'Opciones válidas {1-5}'

            # para ver si es menor o igual que 5
            # SWTICH PARA OPCIONES DEL MENÚ
            if  ( $opcion -le 5 ) {
                switch ( $opcion ) {
                    1 {equipo}
                    2 {red}
                    3 {usu}
                    4 {log}
                    5 {recursos}
                }
            }
        }

    }
}



############# Ejecución de las funciones

# Posible prueba de paginación una vez que se tengan más datos.
#ejecucion | Out-Host -Paging

menu


Read-Host -Prompt 'Pulse cualquier tecla para salir'