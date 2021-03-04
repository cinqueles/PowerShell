<#SCRIPT INFORME EQUIPO
 AUTOR: ISMAEL MORILLA
 VERSION: 1.0 
 FECHA: 3/3/2021
 DESCRIPCIÓN: SCRIPT DE ADMINISTRACIÓN DE EQUIPOS WINDOWS
    - CREACIÓN DE USUARIOS/GRUPOS
    - ADMINISTRACIÓN DE PROCESOS
    - REVISIÓN DE LOGS
    - RECURSOS COMPARTIDOS
    - TAREAS PROGRAMADAS
    - ETC
#>

####### FUNCIONES DE USUARIOS/GRUPOS

function creaUsu {
    Write-Host '1. Uno'
    Write-Host '2. Varios' `n
    $cant = Read-Host 'Cantidad de usuarios a crear'

    switch ($cant){
        1 {
            $nombre = Read-Host 'Nombre del usuario'
            $pass = Read-Host 'Contraseña' -AsSecureString

            New-LocalUser $nombre -Password $pass
            Add-LocalGroupMember usuarios -Member $nombre

            Write-Host 'USUARIO CREADO CON EXITO' -BackgroundColor Green  
            Write-Host `n
        }
        2 {
            $ruta = Read-Host 'Indica la ruta donde se encuentra el fichero CSV'
            $usuarios= Import-Csv -Path $ruta


            foreach ($i in $usuarios){
                $clave = ConvertTo-SecureString $i.contra -AsPlainText -Force
                New-LocalUser $i.nombre -Password $clave -AccountNeverExpires -PasswordNeverExpires
                Add-LocalGroupMember -Group Usuarios -Member $i.nombre

            }

            Write-Host 'USUARIOS CORRECTAMENTE CREADOS' -BackgroundColor Green            
        }
    }
}

function delUsu {
    Write-Host '1. Uno'
    Write-Host '2. Varios' `n
    $cant = Read-Host 'Cantidad de usuarios a eliminar'

    switch ($cant){
        1 {
            $nombre = Read-Host 'Nombre del usuario'
            
            Remove-LocalUser -Confirm $nombre 

            Write-Host `n

            Write-Host 'USUARIO ELIMINADO CON EXITO' -BackgroundColor Green  
        }
        2 {
            $ruta = Read-Host 'Indica la ruta donde se encuentra el fichero CSV'
            $usuarios= Import-Csv -Path $ruta


            foreach ($i in $usuarios){
                Remove-LocalUser $i.nombre 

            }

            Write-Host 'USUARIOS CORRECTAMENTE ELIMINADOS' -BackgroundColor Green
        }
    }
}

function creaGru {
    
    $nombre = Read-Host 'Introduce el nombre del grupo a crear'

    New-LocalGroup -Name $nombre

    Write-Host 'GRUPO CREADO CORRECTAMENTE' `n -BackgroundColor Green
    
}

function delGru {
    #Listar los grupos que se pueden borrar

    (Get-LocalGroup | Where-Object {$_.PrincipalSource -eq 'Local' } | Where-Object {$_.SID -match 'S-1-5-21'}).Name

    $nombre = Read-Host 'Introduce el nombre del grupo a eliminar'

    Remove-LocalGroup -Name $nombre

    Write-Host 'GRUPO ELIMINADO CORRECTAMENTE' `n -BackgroundColor Green
}

function addMember {
  $nombre = Read-Host 'Introduce el nombre del usuario a añadir'
  $grupo = Read-Host 'Introduce el nombre del grupo deseado'

  Add-LocalGroupMember $grupo -Member $nombre

}

function ModMember {
    Write-Host 'Modificación ha realizar'
    Write-Host '1. Renombrar usuario'
    Write-Host '2. Renombrar grupo'
    Write-Host '3. Activar usuario'
    Write-Host '4. Desactivar usuario'
    Write-Host '5. Eliminar miembros'
    Write-Host `n 
    $OP= Read-Host 'Introduzca opción'

    switch ($OP){
        1 {
            $nombre= Read-Host 'Indique nombre del usuario'
            $new= Read-Host 'Indique el nuevo nombre de usuario'

            Rename-LocalUser $nombre -NewName $new

            Write-Host 'RENOMBRADO REALIZADO DE FORMA CORRECTA' -BackgroundColor Green

        }
        2 {
            $nombre= Read-Host 'Indique nombre del grupo'
            $new= Read-Host 'Indique el nuevo nombre del grupo'

            Rename-LocalGroup $nombre -NewName $new

            Write-Host 'RENOMBRADO REALIZADO DE FORMA CORRECTA' -BackgroundColor Green
        }
        3 {
            $nombre = Read-Host 'Indica el nombre del usuario a activar'
            Enable-LocalUser $nombre

            Write-Host 'USUARIO ACTIVADO' -BackgroundColor Green
        }
        4 {
            $nombre = Read-Host 'Indique el nombre de usuario a desactivar'
            Disable-LocalUser $nombre

            Write-Host 'USUARIO DESACTIVADO'
        }
        5 {
            $usuario = Read-Host 'Indique miembro a eliminar'
            $grupo = Read-Host 'Indique grupo del que se quiere eliminar'

            Remove-LocalGroupMember $grupo -Member $usuario

            Write-Host 'USUARIO $usuario ELIMINADO CORRECTAMENTE DE $grupo'
        }
    }


}



# MENÚ ESPECÍFICOS

function usuarios{
    Clear-Host
    ### MENU PARA LOS USUARIOS/GRUPOS

    Write-Host '######### MENU USUARIOS/GRUPOS #########' -ForegroundColor Yellow
    Write-Host '1. Listar usuarios'
    Write-Host '2. Listar grupos'
    Write-Host '3. Listar miembros'
    Write-Host '4. Crear usuarios'
    Write-Host '5. Crear grupos'
    Write-Host '6. Eliminar usuarios'
    Write-Host '7. Eliminar grupos'
    Write-Host '8. Añadir miembros'
    Write-Host '9. Modificar usuario/grupo'
    Write-host '########################################'`n -ForegroundColor Yellow

    $OP = Read-Host 'Introduzca opción'

    
    switch ($OP) {
        1 {Get-LocalUser | ft Name, Enabled}
        2 {Get-LocalGroup | ft Name}
        3 {$member = Read-Host 'Nombre del grupo a listar'
            Get-LocalGroupMember $member            
             }
        4 {creaUsu}
        5 {creaGru}
        6 {delUsu}
        7 {delGru}
        8 {addMember}
        9 {ModMember}

    
    
    
    }


}


# EJECUCIÓN DEL SCRIPT
usuarios