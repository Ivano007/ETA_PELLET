#!/bin/bash

#rEMPLACER LES xxX PAR ip DE LA CHAUDIERE
IP_CHAUDIERE=XXX.XXX.XXX.XXX

#LE SCRIPT conso.sh DOIT SE TROUVER DANS CE REPERTOIRE
cd /ETA


#
#Récupération du contenu du Silo a pellet
#
SILO_STOCK=`wget -qO- stdout $IP_CHAUDIERE:8080/user/var/40/10201/0/0/12015|grep "/user/var/40/10201/0/0/12015"|awk '{print $3}'|sed -e "s/strValue=\"//"|sed -e "s/\"//"`

#
# Recuperation Temperature exterieure
#
TEMP_EXT=`wget -qO- stdout $IP_CHAUDIERE:8080/user/var/120/10101/12095/0/1071|grep "/user/var/120/10101/12095/0/1071"|awk '{print $3}'|sed -e "s/strValue=\"//"|sed -e "s/\"//"`

DATE_JOUR=`date +"%d-%m-%Y"`

#
# Recuperer silo jour precedent
#
SILO_STOCK_PREVIOUS=`cat SILO_PREVIOUS.DAT`


if [ $SILO_STOCK -gt $SILO_STOCK_PREVIOUS ]
then
#
# Le silo a ete remplis
#
        SILO_USAGE="-1"

else
#
# Calcul utilisation journaliere
#
        SILO_USAGE=$(( SILO_STOCK_PREVIOUS-SILO_STOCK ))

fi

#
# Ecrire les datas dans fichiers
#

echo $SILO_STOCK>SILO_PREVIOUS.DAT
echo "$DATE_JOUR        $SILO_USAGE     $TEMP_EXT">>CONSO_JOUNALIERE.DAT
