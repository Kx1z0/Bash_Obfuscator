#!/bin/bash

### Renovar variables y strings
function renw_obfuscation(){
	OLDIFS=$IFS
	echo""
	echo -e "[*]Obfuscation[*]"

	#Declaramos el diccionario para almacenar letra y payload
	declare -A diccionario_ofuscado
	IFS=$'\n'
	for path_sin_ofuscar in "${paths_finales[@]}"; do
		only_path_tmp=$(echo "$path_sin_ofuscar" | awk -F':' '{out=""; for(i=2;i<=NF;i++){out=out":"$i}; print out}')
		only_path=$(echo "$only_path_tmp" | sed 's/^:\(.*\)/\1/' )
		char_to_find=$(echo "$path_sin_ofuscar" | awk -F':' '{print $1}')
		position=$(awk -v a="$only_path" -v b="$char_to_find" 'BEGIN{print index(a,b)}')

		index_substr=$( expr $position - 1 )
		obfuscated_payload=$(echo -e "Char: $char_to_find --> Char Ofuscado: \${$(echo \"$only_path\"):$index_substr:1}")
		echo "$obfuscated_payload"

	# Se mete en diccionario
		diccionario_ofuscado["$char_to_find"]="\${$(echo $only_path):$index_substr:1}"


	done
	IFS=$OLDIFS
	renw_payload_generation

}


function renw_payload_generation(){
	contador=0

	while [[ $comando != "exit" ]];do
		echo ""
		if [[ contador -le 2 ]]; then
			read -p "Command: " comando


	#Bucle for para el valor de comando, e ir imprimiendo el valor de cada caracter
	output_ofuscado=$(for (( i=0; i<${#comando}; i++ )); do

		echo ${diccionario_ofuscado[$(echo "${comando:$i:1}")]} | awk -F ":" '{print $1}' | tr -d '{' | tr -d '$'

	done)

	output_ofuscado_sin_espacio=$(echo "$output_ofuscado" | tr -d '\n')


	#Sacamos la posicion numerica de cada caracter
	output_ofuscado_numero=$(for (( k=0; k<${#comando}; k++ )); do

		echo ${diccionario_ofuscado[$(echo "${comando:$k:1}")]} | awk -F ":" '{print $2}' | tr -d '{' | tr -d '$'
		
	done)


	cont_posicion=0
	cont_long_string=1

	posiciones_char=$(for j in $output_ofuscado_numero; do 
		if [[  $cont_posicion == 0 ]]; then
			echo "$j " | tr -d '\n'
			actual=$(echo "$j " | tr -d '\n')
			cont_posicion=1
		else
			let actual=$j+cont_long_string*35
			echo "$actual " | tr -d '\n'
			let cont_long_string=$cont_long_string+1
		fi
		
	done)

	cadena_sin_ofuscar=$(echo "$output_ofuscado_sin_espacio-$posiciones_char")
	read -p "Encryption key: " clave
	encriptado=$(echo "$output_ofuscado_sin_espacio-$posiciones_char" | openssl enc -e -aes-256-cbc -salt -pass "pass:$(echo -n $clave)" -pbkdf2 | base64 -w0)

	#Nombre variable
	random_not_var=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w ${1:-6} | head -n1 | base64 | tr -d "=")



	# echo final
	random_decrypt=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w ${1:-6} | head -n1 | base64 | tr -d "=")

	echo -n " read -p \"Key: \" $random_decrypt ;" "$random_not_var=\"\$(echo $encriptado | base64 -d | openssl enc -in - -d -aes-256-cbc -pass pass:$(echo \$$random_decrypt) -pbkdf2)\" ; bash -c \"\$(for $random_iter in \$(echo \$$random_not_var | awk -F\"$random_sep\" '{print \$2}') ; do echo -n \"\${$random_not_var:$random_iter:1}\"; done)"\" "; unset $random_decrypt $random_not_var $random_iter"

	echo -n " read -p \"Key: \" $random_decrypt ;" "$random_not_var=\"\$(echo $encriptado | base64 -d | openssl enc -in - -d -aes-256-cbc -pass pass:$(echo \$$random_decrypt) -pbkdf2)\" ; bash -c \"\$(for $random_iter in \$(echo \$$random_not_var | awk -F\"$random_sep\" '{print \$2}') ; do echo -n \"\${$random_not_var:$random_iter:1}\"; done)"\" "; unset $random_decrypt $random_not_var $random_iter"| xclip -sel clip

	let contador=$contador+1


		else
			renw_main
		fi
	done

}


function renw_main(){

abecedario=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w ${1:-35} | head -n 300)

paths=()
paths_finales=()

lineas=$(echo "$abecedario" | wc -l | awk '{print $1}')

for k in $(echo "$abecedario"); do

	paths+=( $k )

done

# We chose a random path for a letter and we grep for it
for letra in $(echo {a..z} {A..Z} {0..9}); do

	rand=$[ $RANDOM % $lineas ]

	if [[ $(echo ${paths[$rand]} | grep -oc "$letra") -ge 1 ]]; then

		letra_ruta=$(echo ${paths[$rand]})
		#echo $letra":"$letra_ruta
		letra_mas_ruta="$letra:$letra_ruta"
		paths_finales+=( $letra_mas_ruta )
		echo "$letra_mas_ruta"

#If the char innit in the path, we chose another random path, up to 40 (which is why there is a counter)
	elif [[ $(echo ${paths[$rand]} | grep -oc "$letra") == 0 ]]; then
		contador_intentos=0
		while [[ $(echo ${paths[$rand]} | grep -oc "$letra") == 0 ]]; do

			if [[ $contador_intentos == 40 ]]; then
				break
			fi

			let contador_intentos=$contador_intentos+1
			rand=$[ $RANDOM % $lineas ]

			if [[ $(echo ${paths[$rand]} | grep -oc "$letra") -ge 1 ]]; then

        		        letra_ruta=$(echo ${paths[$rand]})
				letra_mas_ruta="$letra:$letra_ruta"
		                paths_finales+=( $letra_mas_ruta )
		                echo "$letra_mas_ruta"
			fi

		done
	
	
	contador_intentos=0
	rand=$[ $RANDOM % $lineas ]

	fi

done

# Metemos el espacio
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][= =]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc " ") == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][= =]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta=" :$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"

# Metemos char .
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=.=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc '\.') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=.=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta=".:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"

#Metemos char /
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=/=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc "/") == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=/=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta="/:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"


#Metemos char &
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=&=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc "&") == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=&=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta="&:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"


#Metemos char "
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][="=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc '"') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][="=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta="\":$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"


#Metemos char ;
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=;=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc ';') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=;=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta=";:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"


#Metemos char -
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=-=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc '-') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=-=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta="-:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"

#Metemos char | 
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=|=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc '|') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=|=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta="|:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"


#Metemos char >
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=>=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc '>') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=>=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta=">:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"


	renw_obfuscation
}



function obfuscation(){
	OLDIFS=$IFS
	echo""
	echo -e "[*]Obfuscation[*]"

	#Declaramos el diccionario para almacenar letra y payload
	declare -A diccionario_ofuscado
	IFS=$'\n'
	for path_sin_ofuscar in "${paths_finales[@]}"; do
		only_path_tmp=$(echo "$path_sin_ofuscar" | awk -F':' '{out=""; for(i=2;i<=NF;i++){out=out":"$i}; print out}')
		only_path=$(echo "$only_path_tmp" | sed 's/^:\(.*\)/\1/' )
		char_to_find=$(echo "$path_sin_ofuscar" | awk -F':' '{print $1}')
		position=$(awk -v a="$only_path" -v b="$char_to_find" 'BEGIN{print index(a,b)}')

		index_substr=$( expr $position - 1 )
		obfuscated_payload=$(echo -e "Char: $char_to_find --> Char Ofuscado: \${$(echo \"$only_path\"):$index_substr:1}")
		echo "$obfuscated_payload"


	#Se mete en diccionario
		diccionario_ofuscado["$char_to_find"]="\${$(echo $only_path):$index_substr:1}"


	done
	IFS=$OLDIFS


	OLDIFS=$IFS
	IFS=$'\n'
	encriptar_esto=$(for i in "${!diccionario_ofuscado[@]}"; do
		echo $i:"${diccionario_ofuscado[$i]}"
	done)
	IFS=$OLDIFS

	payload_generation

}


function payload_generation(){
	contador=0
	

	while [[ $comando != "exit" ]];do
		echo ""
		if [[ contador -le 2 ]]; then
			read -p "Command: " comando


	#Bucle for para el valor de comando, e ir imprimiendo el valor de cada caracter
	output_ofuscado=$(for (( i=0; i<${#comando}; i++ )); do

		echo ${diccionario_ofuscado[$(echo "${comando:$i:1}")]} | awk -F ":" '{print $1}' | tr -d '{' | tr -d '$'

	done)

	output_ofuscado_sin_espacio=$(echo "$output_ofuscado" | tr -d '\n')
	

	#Sacamos la posicion numerica de cada caracter
	output_ofuscado_numero=$(for (( k=0; k<${#comando}; k++ )); do

		echo ${diccionario_ofuscado[$(echo "${comando:$k:1}")]} | awk -F ":" '{print $2}' | tr -d '{' | tr -d '$'
		
	done)


	cont_posicion=0
	cont_long_string=1

	posiciones_char=$(for j in $output_ofuscado_numero; do 
		if [[  $cont_posicion == 0 ]]; then
			echo "$j " | tr -d '\n'
			actual=$(echo "$j " | tr -d '\n')
			cont_posicion=1
		else
			let actual=$j+cont_long_string*35
			echo "$actual " | tr -d '\n'
			let cont_long_string=$cont_long_string+1
		fi
		
	done)

	#Variable para el separador inicial
	random_sep=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w ${1:-5} | head -n1 | base64 | tr -d "=")

	cadena_sin_ofuscar=$(echo $output_ofuscado_sin_espacio$random_sep$posiciones_char)
	read -p "Encryption key: " clave
	encriptado=$(echo $output_ofuscado_sin_espacio$random_sep$posiciones_char | openssl enc -e -aes-256-cbc -salt -pass "pass:$(echo -n $clave)" -pbkdf2 | base64 -w0)

	#Nombre variable
	random_not_var=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w ${1:-6} | head -n1 | base64 | tr -d "=")

	#Nombre iterador final
	random_iter=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w ${1:-6} | head -n1 | base64 | tr -d "=")

	# echo final
	random_decrypt=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w ${1:-6} | head -n1 | base64 | tr -d "=")


	echo -n " read -p \"Key: \" $random_decrypt ;" "$random_not_var=\"\$(echo $encriptado | base64 -d | openssl enc -in - -d -aes-256-cbc -pass pass:$(echo \$$random_decrypt) -pbkdf2)\" ; bash -c \"\$(for $random_iter in \$(echo \$$random_not_var | awk -F\"$random_sep\" '{print \$2}') ; do echo -n \"\${$random_not_var:$random_iter:1}\"; done)"\" "; unset $random_decrypt $random_not_var $random_iter"

	echo -n " read -p \"Key: \" $random_decrypt ;" "$random_not_var=\"\$(echo $encriptado | base64 -d | openssl enc -in - -d -aes-256-cbc -pass pass:$(echo \$$random_decrypt) -pbkdf2)\" ; bash -c \"\$(for $random_iter in \$(echo \$$random_not_var | awk -F\"$random_sep\" '{print \$2}') ; do echo -n \"\${$random_not_var:$random_iter:1}\"; done)"\" "; unset $random_decrypt $random_not_var $random_iter"| xclip -sel clip

## Old way
	#echo -n " read -p \"Clave: \" $random_decrypt ;" "$random_not_var=\"\$(echo $encriptado | base64 -d | openssl enc -in - -d -aes-256-cbc -pass pass:$(echo \$$random_decrypt) -pbkdf2)\" ; bash -c \"$(for i in $(echo $cadena_sin_ofuscar | awk -F"$random_sep" '{print $2}') ; do echo \${$random_not_var:$i:1} | tr -d '\n'; done)"\" "; unset $random_decrypt $random_not_var"
	
	#echo -n " read -p \"Clave: \" $random_decrypt ;" "$random_not_var=\"\$(echo $encriptado | base64 -d | openssl enc -in - -d -aes-256-cbc -pass pass:$(echo \$$random_decrypt) -pbkdf2)\" ; bash -c \"$(for i in $(echo $cadena_sin_ofuscar | awk -F"SEPARADOR_RANDOM" '{print $2}') ; do echo \${$random_not_var:$i:1} | tr -d '\n'; done)"\" "; unset $random_decrypt $random_not_var"| xclip -sel clip
##
	

	let contador=$contador+1

		else
			renw_main
		fi


	done

}


echo -e "[*]Dictionary[*]"

abecedario=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w ${1:-35} | head -n 300)

paths=()
paths_finales=()

lineas=$(echo "$abecedario" | wc -l | awk '{print $1}')

for k in $(echo "$abecedario"); do

	paths+=( $k )

done

# We chose a random path for a letter and we grep for it
for letra in $(echo {a..z} {A..Z} {0..9}); do

	rand=$[ $RANDOM % $lineas ]

	if [[ $(echo ${paths[$rand]} | grep -oc "$letra") -ge 1 ]]; then

		letra_ruta=$(echo ${paths[$rand]})
		#echo $letra":"$letra_ruta
		letra_mas_ruta="$letra:$letra_ruta"
		paths_finales+=( $letra_mas_ruta )
		echo "$letra_mas_ruta"

#If the char innit in the path, we chose another random path, up to 40 (which is why there is a counter)
	elif [[ $(echo ${paths[$rand]} | grep -oc "$letra") == 0 ]]; then
		contador_intentos=0
		while [[ $(echo ${paths[$rand]} | grep -oc "$letra") == 0 ]]; do

			if [[ $contador_intentos == 40 ]]; then
				break
			fi

			let contador_intentos=$contador_intentos+1
			rand=$[ $RANDOM % $lineas ]

			if [[ $(echo ${paths[$rand]} | grep -oc "$letra") -ge 1 ]]; then

        		        letra_ruta=$(echo ${paths[$rand]})
				letra_mas_ruta="$letra:$letra_ruta"
		                paths_finales+=( $letra_mas_ruta )
		                echo "$letra_mas_ruta"
			fi

		done
	
	
	contador_intentos=0
	rand=$[ $RANDOM % $lineas ]

	fi

done

# Metemos el char espacio
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][= =]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc " ") == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][= =]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta=" :$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"

# Metemos char .
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=.=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc '\.') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=.=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta=".:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"

#Metemos char /
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=/=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc "/") == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=/=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta="/:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"


#Metemos char &
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=&=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc "&") == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=&=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta="&:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"


#Metemos char "
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][="=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc '"') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][="=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta="\":$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"


#Metemos char ;
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=;=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc ';') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=;=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta=";:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"


#Metemos char -
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=-=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc '-') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=-=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta="-:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"

#Metemos char | 
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=|=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc '|') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=|=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta="|:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"


#Metemos char >
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=>=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc '>') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=>=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta=">:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"


obfuscation


