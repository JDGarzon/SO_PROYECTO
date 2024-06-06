do {
    # Mostrar el menú de opciones
    Write-Host "Seleccione una opción:"
    Write-Host "1. Desplegar los cinco procesos que más CPU estén consumiendo en ese momento."
    Write-Host "2. Desplegar los filesystems o discos conectados a la máquina."
    Write-Host "3. Desplegar el nombre y el tamaño del archivo más grande almacenado en un disco o filesystem."
    Write-Host "4. Cantidad de memoria libre y cantidad del espacio de swap en uso."
    Write-Host "5. Número de conexiones de red activas actualmente (en estado ESTABLISHED)."
    Write-Host "0. Salir."
    
    # Leer la elección del usuario
    $choice = Read-Host "Ingrese su opción"

    # Evaluar la elección del usuario
    switch ($choice) {
        1 {
            # Opción 1: Desplegar los cinco procesos que más CPU están consumiendo en ese momento
            Write-Host "Los cinco procesos que más CPU están consumiendo:"
            # Obtener los procesos ordenados por uso de CPU descendente y mostrar los cinco primeros
            Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | Format-Table Id, ProcessName, CPU -AutoSize | ft
        }
        2 {
            # Opción 2: Desplegar los filesystems o discos conectados a la máquina
            Write-Host "Filesystems o discos conectados a la máquina:"
            # Obtener los drives del sistema de archivos y mostrar su nombre, tamaño usado y espacio libre
            Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name="Size(Byte)"; Expression={$_.Used}}, @{Name="FreeSpace(Byte)"; Expression={$_.Free}} | ft
        }
        3 {
            # Opción 3: Desplegar el archivo más grande en un filesystem especificado
            $path = Read-Host "Ingrese la ruta del disco o filesystem"
            
            if (Test-Path $path) {
                Write-Host "El archivo más grande en $path es:"
                # Buscar archivos en el path especificado y ordenarlos por tamaño descendente, mostrando el archivo más grande
                Get-ChildItem -Path $path -Recurse -File | Sort-Object Length -Descending | Select-Object -First 1 | Select-Object FullName, @{Name="Size(Byte)"; Expression={$_.Length}} | ft
            } else {
                Write-Host "El camino especificado no es válido."
            }
        }
        4 {
            # Opción 4: Desplegar la cantidad de memoria libre y espacio de swap en uso
            $memory = Get-WmiObject -Class Win32_OperatingSystem
            $totalMemory = $memory.TotalVisibleMemorySize * 1KB
            $freeMemory = $memory.FreePhysicalMemory * 1KB
            $swapUsage = $memory.TotalVirtualMemorySize * 1KB - $memory.FreeVirtualMemory * 1KB
            $swapUsagePercent = [math]::round((($memory.TotalVirtualMemorySize - $memory.FreeVirtualMemory) / $memory.TotalVirtualMemorySize) * 100, 2)
            
            Write-Host "Cantidad de memoria libre y espacio de swap en uso:"
            # Mostrar la infromación
	    Write-Host "Free Memory (Bytes)" = $freeMemory
	    Write-Host "Swap Usage (Bytes)" = $swapUsage
            Write-Host "Swap Usage (%)" = $swapUsagePercent
        }
        5 {
            # Opción 5: Desplegar el número de conexiones de red activas en estado ESTABLISHED
            Write-Host "Número de conexiones de red activas en estado ESTABLISHED:"
            # Obtener y contar las conexiones TCP en estado ESTABLISHED
            Write-Host "Conexiones de red activas (ESTABLISHED):" ((Get-NetTCPConnection -State Established).Count)
        }
        0 {
            # Opción 0: Salir del script
            Write-Host "Saliendo..."
        }
        default {
            # Manejar opciones no válidas
            Write-Host "Opción no válida. Por favor intente de nuevo."
        }
    }
    
} while ($choice -ne 0)
