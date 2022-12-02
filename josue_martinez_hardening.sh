#!/bin/bash
# Lo primero que se hace es verificar si estamos usando CentOS, ya que con esta distro trabajamos todo el semestre
#Se hace mediante un cat al release, filtramos el ID y obtenemos solo la palabra centos
distro=$(cat /etc/*release | grep -i 'ID="centos"' | awk '{ print substr( $0, 5) }' | awk '{ print substr( $0, 1, length($0)-1 ) }')
#Despues esa palabra la metemos a la condicional para verificar que si sea centos
if [ "$distro" == "centos" ]
then
        echo "Tienes CentOS"
        echo "Se instalará EPEL asi como la actualizacion de todos los paquetes disponibles"
#Para proceder a instalar los servidores de EPEL asi como actualizar todo lo disponible        
        sudo yum -y install epel-release
        sudo yum update
#Verificamos tambien si cuenta con una sintalacion de Clamav
        echo "Ahora se verificará si cuenta con una instalacion de Clamav"
#Esto mediante un filtro al listado de aplicaciones instaladas
        program=$(sudo yum list installed | grep clamav | head -n 1 | cut -c 1-6)
        echo "$program"
        if [ "$program" == "clamav" ]; then
#Si detectamos un Clamav procedemos con su reinstalacion
                echo "Se detectó una instalacion de Clamav, se procederá con su reinstalacion"
                sudo yum -y remove clamav
                sudo yum -y install clamav
        else
#En caso de que no lo instalamos
                echo "No se detectó una instalacion de Clamav, se procederá con su instalacion"
                sudo yum -y install clamav
        fi
else
#En caso de que se ejecute en una distro a Centos, buscamos si es ubuntu
        echo "Tienes una distribucion diferente a CentOS"
        distro=$(cat /etc/*release | grep -i 'DISTRIB_ID=ubuntu'| awk '{ print substr( $0, 12) }')

        if [ "$distro" == "Ubuntu" ]
        then
#Al mismo tiempo que repetimos el proceso de Clamav
                program=(sudo apt list --installed | grep clamav | cut -c 1-6)
                if [ "$program" == "clamav" ]; then
                        echo "Se detectó una instalacion de Clamav, se procederá con su reinstalacion"
                        sudo apt-get remove clamav
                        sudo apt-get install clamav
                else
                        echo "No se detectó una instalacion de Clamav, se procederá con su instalacion"
                        sudo apt-get install clamav
                fi
fi
#En caso de que el codigo se ejecute en Centos arrojara errores en la parte de Ubuntu pero funcionara
#En caso de que el codigo se ejecute en Ubuntu arrojara errores en la parte de Centos pero funcionara