#!/bin/bash
# Este script despliega un menú con varias opciones para obtener información del sistema.

while true; do
    # Desplegar el menú de opciones
    echo "Seleccione una opción:"
    echo "1. Desplegar los cinco procesos que más CPU estén consumiendo en ese momento."
    echo "2. Desplegar los filesystems o discos conectados a la máquina."
    echo "3. Desplegar el nombre y el tamaño del archivo más grande almacenado en un disco o filesystem específico."
    echo "4. Cantidad de memoria libre y cantidad del espacio de swap en uso (en bytes y porcentaje)."
    echo "5. Número de conexiones de red activas actualmente (en estado ESTABLISHED)."
    echo "0. Salir"
    
    # Leer la elección del usuario
    read -p "Ingrese su elección: " choice

    case $choice in
        1)
            # Opción 1: Desplegar los cinco procesos que más CPU están consumiendo
            echo "Los cinco procesos que más CPU están consumiendo:"
            # `ps` lista los procesos, `-eo` especifica el formato de salida, y `--sort=-%cpu` ordena por uso de CPU
            # `head -n 6` muestra las primeras seis líneas (una para la cabecera y cinco para los procesos)
            ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
            ;;
        2)
            # Opción 2: Desplegar los filesystems o discos conectados
            echo "Filesystems o discos conectados a la máquina:"
            # `df -B1` muestra el uso de espacio en los filesystems en formato de bloques de bytes
            # `awk` filtra las líneas para mostrar solo los filesystems con sus tamaños y espacio libre
            df -B1 | awk '{print $1, $2, $4}'
            ;;
        3)
            # Opción 3: Desplegar el archivo más grande en un disco o filesystem específico
            read -p "Ingrese el path del disco o filesystem: " path
            if [ -d "$path" ]; then
                echo "El archivo más grande en $path es:"
                # `find` busca archivos en el path especificado, `du -b` obtiene el tamaño en bytes
                # `sort -nr` ordena los archivos por tamaño de mayor a menor
                # `head -n 1` muestra solo el archivo más grande
                find "$path" -type f -exec du -b {} + | sort -nr | head -n 1 | awk '{print $2, $1 " bytes"}'
            else
                echo "El path especificado no es válido o no es un directorio."
            fi
            ;;
        4)
            # Opción 4: Desplegar la cantidad de memoria libre y espacio de swap en uso
            echo "Memoria libre y espacio de swap en uso:"
            # `free -b` muestra la memoria y swap en bytes
            # `awk` extrae y le da formato a la información relevante 
            free -b | awk '/Mem/ {print "Memoria libre: " $4 " bytes"} /Swap/ {used=$3; total=$2; percent=used*100/total; print "Swap en uso: " used " bytes (" percent "%)"}'
            ;;
        5)
            # Opción 5: Desplegar el número de conexiones de red activas en estado ESTABLISHED
            echo "Número de conexiones de red activas en estado ESTABLISHED:"
            # `netstat -an` muestra todas las conexiones de red
            # `grep ESTABLISHED` filtra solo las establecidas
            # `wc -l` cuenta el número de líneas
            netstat -an | grep ESTABLISHED | wc -l
            ;;
        0)
            # Opción 0: Salir del script
            echo "Saliendo..."
            break
            ;;
        *)
            # Manejo de opción no válida
            echo "Opción no válida. Por favor, intente nuevamente."
            ;;
    esac

    echo ""
done
