#!/bin/bash

rm gabarito input output exec* 2> /dev/null

criarSumario=false
declare -A sumarioAcertos
declare -A sumarioTotal
declare -A sumarioStatus
vermelho='\033[0;31m'
verde='\033[0;32m'
normal='\033[0m'
azul='\033[0;36m'
amarelo='\033[46m'

args=("$@")
avaliar () {
	file=$1
	if [ ! -z ${args[0]} ] && [ ! ${args[0]} == $1 ]; then
		return 1
	fi
	if ! [ -n "${sumarioTotal[$1]}" ]; then
		echo -e "${amarelo}              problema $1            ${normal}"
	fi
	sumarioTotal[$1]=$((sumarioTotal[$1]+1))
	if ! [ -n "${sumarioAcertos[$1]}" ]; then
		sumarioAcertos[$1]=0
	fi
	if [ -f $file.c ]; then
		if [ ! -f exec$file ]; then
			charset="$(file -bi "$file.c" | awk -F "=" '{print $2}')"
			arq=$file.c
			if [ "$charset" != utf-8 ]; then
				iconv -f "$charset" -t utf8 "$file.c" -o tmp.c
				arq=tmp.c
			fi
			if ! gcc $arq -o exec$file -lm  2> /dev/null; then
				sumarioStatus[$1]='código '$file.c' não compila'
			fi
		fi
		echo -e "$2" > input
		echo -e "$3" > gabarito
		if [ -f exec$file ]; then
			timeout 2 ./exec$file < input > output
			printf 'Teste %d: ' ${sumarioTotal[$1]}
			if ! diff -wB output gabarito > /dev/null; then
				echo -e "${vermelho} [x]${normal}"
				echo -e '\tEntrada:' "${azul} $2 ${normal}"
				echo -e '\tSaída do seu programa:' "${azul} $(cat output) ${normal}"
				echo -e '\tSaída esperada:' "${azul} $3 ${normal}"
			else
				echo -e "${verde} [ok] ${normal}"
				sumarioAcertos[$1]=$((sumarioAcertos[$1]+1))
			fi
		fi
	else
		sumarioStatus[$1]='código '$file.c' não existe'
	fi
}

avaliar 'q1' '1573' '16'
avaliar 'q1' '-157' '13'
avaliar 'q1' '-15' '6'
avaliar 'q1' '-5827559' '41'
avaliar 'q1' '5827559' '41'

avaliar 'q2' '2 3' '8'
avaliar 'q2' '3 5' '243'
avaliar 'q2' '3 0' '1'
avaliar 'q2' '135 1' '135'
avaliar 'q2' '7 9' '40353607'

avaliar 'q3' '' '1.6180339887'

avaliar 'q4' '3 1 8 9 8' '1'
avaliar 'q4' '8 -2 3 4 2 1 9 2 3 3' '2'
avaliar 'q4' '10 1 1 4 1 10 322 23 5 1 2 1' '4'
avaliar 'q4' '5 2 2 2 2 2 2' '5'
avaliar 'q4' '0 1' '0'
avaliar 'q4' '1 1 2' '0'

avaliar 'q5' '############\n#  #  #  # #\n#     #2 #3#\n#1 #  #  # #\n####  #  # #\n#@    #@ # #\n############\nFIM' '1 2'
avaliar 'q5' '#################\n#               #\n#       1       #\n#               #\n#               #\n#               #\n#    2          #\n#           @   #\n#               #\n#               #\n#               #\n#              3#\n#################\nFIM' '1 2 3'

avaliar 'q5' '#################\n#    @          #\n#       1       #\n#################\n#       #       #\n#       #       #\n#    2  #       #\n#       #   @   #\n#       #       #\n#       #       #\n#       #       #\n#       #      3#\n#################\nFIM' '1 3'

avaliar 'q5' '#################\n#               #\n#       1       #\n#### ############\n#       #       #\n#       #       #\n#    2  #       #\n#           @   #\n#       #       #\n#       #       #\n#       #       #\n#       #      3#\n#################\nFIM' '1 2 3'

avaliar 'q5' '########\n#@     #\n###### #\n#      #\n# ######\n#      #\n###### #\n#      #\n# ######\n#      #\n###### #\n#      #\n#3######\n#      #\n###### #\n#      #\n# ######\n#      #\n###### #\n#      #\n# ######\n#      #\n###### #\n#      #\n# ######\n#     2#\n#     1#\n########\nFIM' '1 2 3'

avaliar 'q5' '################\n#     #1       #\n#     ######## #\n#     #        #\n#     # ########\n# 3   #        #\n#     ##### #  #\n#     #   # #  #\n#     # #@#    #\n####### # ###  #\n#     # #      #\n#   #   ########\n#   # #     #  #\n#   # #  #@ #  #\n#   #    #     #\n#2  # #     # @#\n#   # #  #@ #  #\n################\nFIM' '1 2'

avaliar 'q5' '################\n#     #1       #\n#     ######## #\n#     #        #\n#     # ########\n# @   #        #\n#     ##### #  #\n#     #   # #  #\n#     # #3#    #\n####### # ###  #\n#     # #      #\n#   # ##########\n#   # #     #  #\n#   # #  #     #\n#   # #  #  #  #\n#2  # #     #@ #\n#   # #  #  #  #\n################\nFIM' 'salvos'

avaliar 'q6' 'ATTGCCGA 1 3' 'AAAACCGA\nAAACCCGA\nAAAGCCGA\nAAATCCGA\nAACACCGA\nAACCCCGA\nAACGCCGA\nAACTCCGA\nAAGACCGA\nAAGCCCGA\nAAGGCCGA\nAAGTCCGA\nAATACCGA\nAATCCCGA\nAATGCCGA\nAATTCCGA\nACAACCGA\nACACCCGA\nACAGCCGA\nACATCCGA\nACCACCGA\nACCCCCGA\nACCGCCGA\nACCTCCGA\nACGACCGA\nACGCCCGA\nACGGCCGA\nACGTCCGA\nACTACCGA\nACTCCCGA\nACTGCCGA\nACTTCCGA\nAGAACCGA\nAGACCCGA\nAGAGCCGA\nAGATCCGA\nAGCACCGA\nAGCCCCGA\nAGCGCCGA\nAGCTCCGA\nAGGACCGA\nAGGCCCGA\nAGGGCCGA\nAGGTCCGA\nAGTACCGA\nAGTCCCGA\nAGTGCCGA\nAGTTCCGA\nATAACCGA\nATACCCGA\nATAGCCGA\nATATCCGA\nATCACCGA\nATCCCCGA\nATCGCCGA\nATCTCCGA\nATGACCGA\nATGCCCGA\nATGGCCGA\nATGTCCGA\nATTACCGA\nATTCCCGA\nATTGCCGA\nATTTCCGA\n'
avaliar 'q6' 'TTCCGAATC 5 5' 'TTCCGAATC\nTTCCGCATC\nTTCCGGATC\nTTCCGTATC\n'
avaliar 'q6' 'CGGATCGTAGT 4 8' 'CGGAAAAAAGT\nCGGAAAAACGT\nCGGAAAAAGGT\nCGGAAAAATGT\nCGGAAAACAGT\nCGGAAAACCGT\nCGGAAAACGGT\nCGGAAAACTGT\nCGGAAAAGAGT\nCGGAAAAGCGT\nCGGAAAAGGGT\nCGGAAAAGTGT\nCGGAAAATAGT\nCGGAAAATCGT\nCGGAAAATGGT\nCGGAAAATTGT\nCGGAAACAAGT\nCGGAAACACGT\nCGGAAACAGGT\nCGGAAACATGT\nCGGAAACCAGT\nCGGAAACCCGT\nCGGAAACCGGT\nCGGAAACCTGT\nCGGAAACGAGT\nCGGAAACGCGT\nCGGAAACGGGT\nCGGAAACGTGT\nCGGAAACTAGT\nCGGAAACTCGT\nCGGAAACTGGT\nCGGAAACTTGT\nCGGAAAGAAGT\nCGGAAAGACGT\nCGGAAAGAGGT\nCGGAAAGATGT\nCGGAAAGCAGT\nCGGAAAGCCGT\nCGGAAAGCGGT\nCGGAAAGCTGT\nCGGAAAGGAGT\nCGGAAAGGCGT\nCGGAAAGGGGT\nCGGAAAGGTGT\nCGGAAAGTAGT\nCGGAAAGTCGT\nCGGAAAGTGGT\nCGGAAAGTTGT\nCGGAAATAAGT\nCGGAAATACGT\nCGGAAATAGGT\nCGGAAATATGT\nCGGAAATCAGT\nCGGAAATCCGT\nCGGAAATCGGT\nCGGAAATCTGT\nCGGAAATGAGT\nCGGAAATGCGT\nCGGAAATGGGT\nCGGAAATGTGT\nCGGAAATTAGT\nCGGAAATTCGT\nCGGAAATTGGT\nCGGAAATTTGT\nCGGAACAAAGT\nCGGAACAACGT\nCGGAACAAGGT\nCGGAACAATGT\nCGGAACACAGT\nCGGAACACCGT\nCGGAACACGGT\nCGGAACACTGT\nCGGAACAGAGT\nCGGAACAGCGT\nCGGAACAGGGT\nCGGAACAGTGT\nCGGAACATAGT\nCGGAACATCGT\nCGGAACATGGT\nCGGAACATTGT\nCGGAACCAAGT\nCGGAACCACGT\nCGGAACCAGGT\nCGGAACCATGT\nCGGAACCCAGT\nCGGAACCCCGT\nCGGAACCCGGT\nCGGAACCCTGT\nCGGAACCGAGT\nCGGAACCGCGT\nCGGAACCGGGT\nCGGAACCGTGT\nCGGAACCTAGT\nCGGAACCTCGT\nCGGAACCTGGT\nCGGAACCTTGT\nCGGAACGAAGT\nCGGAACGACGT\nCGGAACGAGGT\nCGGAACGATGT\nCGGAACGCAGT\nCGGAACGCCGT\nCGGAACGCGGT\nCGGAACGCTGT\nCGGAACGGAGT\nCGGAACGGCGT\nCGGAACGGGGT\nCGGAACGGTGT\nCGGAACGTAGT\nCGGAACGTCGT\nCGGAACGTGGT\nCGGAACGTTGT\nCGGAACTAAGT\nCGGAACTACGT\nCGGAACTAGGT\nCGGAACTATGT\nCGGAACTCAGT\nCGGAACTCCGT\nCGGAACTCGGT\nCGGAACTCTGT\nCGGAACTGAGT\nCGGAACTGCGT\nCGGAACTGGGT\nCGGAACTGTGT\nCGGAACTTAGT\nCGGAACTTCGT\nCGGAACTTGGT\nCGGAACTTTGT\nCGGAAGAAAGT\nCGGAAGAACGT\nCGGAAGAAGGT\nCGGAAGAATGT\nCGGAAGACAGT\nCGGAAGACCGT\nCGGAAGACGGT\nCGGAAGACTGT\nCGGAAGAGAGT\nCGGAAGAGCGT\nCGGAAGAGGGT\nCGGAAGAGTGT\nCGGAAGATAGT\nCGGAAGATCGT\nCGGAAGATGGT\nCGGAAGATTGT\nCGGAAGCAAGT\nCGGAAGCACGT\nCGGAAGCAGGT\nCGGAAGCATGT\nCGGAAGCCAGT\nCGGAAGCCCGT\nCGGAAGCCGGT\nCGGAAGCCTGT\nCGGAAGCGAGT\nCGGAAGCGCGT\nCGGAAGCGGGT\nCGGAAGCGTGT\nCGGAAGCTAGT\nCGGAAGCTCGT\nCGGAAGCTGGT\nCGGAAGCTTGT\nCGGAAGGAAGT\nCGGAAGGACGT\nCGGAAGGAGGT\nCGGAAGGATGT\nCGGAAGGCAGT\nCGGAAGGCCGT\nCGGAAGGCGGT\nCGGAAGGCTGT\nCGGAAGGGAGT\nCGGAAGGGCGT\nCGGAAGGGGGT\nCGGAAGGGTGT\nCGGAAGGTAGT\nCGGAAGGTCGT\nCGGAAGGTGGT\nCGGAAGGTTGT\nCGGAAGTAAGT\nCGGAAGTACGT\nCGGAAGTAGGT\nCGGAAGTATGT\nCGGAAGTCAGT\nCGGAAGTCCGT\nCGGAAGTCGGT\nCGGAAGTCTGT\nCGGAAGTGAGT\nCGGAAGTGCGT\nCGGAAGTGGGT\nCGGAAGTGTGT\nCGGAAGTTAGT\nCGGAAGTTCGT\nCGGAAGTTGGT\nCGGAAGTTTGT\nCGGAATAAAGT\nCGGAATAACGT\nCGGAATAAGGT\nCGGAATAATGT\nCGGAATACAGT\nCGGAATACCGT\nCGGAATACGGT\nCGGAATACTGT\nCGGAATAGAGT\nCGGAATAGCGT\nCGGAATAGGGT\nCGGAATAGTGT\nCGGAATATAGT\nCGGAATATCGT\nCGGAATATGGT\nCGGAATATTGT\nCGGAATCAAGT\nCGGAATCACGT\nCGGAATCAGGT\nCGGAATCATGT\nCGGAATCCAGT\nCGGAATCCCGT\nCGGAATCCGGT\nCGGAATCCTGT\nCGGAATCGAGT\nCGGAATCGCGT\nCGGAATCGGGT\nCGGAATCGTGT\nCGGAATCTAGT\nCGGAATCTCGT\nCGGAATCTGGT\nCGGAATCTTGT\nCGGAATGAAGT\nCGGAATGACGT\nCGGAATGAGGT\nCGGAATGATGT\nCGGAATGCAGT\nCGGAATGCCGT\nCGGAATGCGGT\nCGGAATGCTGT\nCGGAATGGAGT\nCGGAATGGCGT\nCGGAATGGGGT\nCGGAATGGTGT\nCGGAATGTAGT\nCGGAATGTCGT\nCGGAATGTGGT\nCGGAATGTTGT\nCGGAATTAAGT\nCGGAATTACGT\nCGGAATTAGGT\nCGGAATTATGT\nCGGAATTCAGT\nCGGAATTCCGT\nCGGAATTCGGT\nCGGAATTCTGT\nCGGAATTGAGT\nCGGAATTGCGT\nCGGAATTGGGT\nCGGAATTGTGT\nCGGAATTTAGT\nCGGAATTTCGT\nCGGAATTTGGT\nCGGAATTTTGT\nCGGACAAAAGT\nCGGACAAACGT\nCGGACAAAGGT\nCGGACAAATGT\nCGGACAACAGT\nCGGACAACCGT\nCGGACAACGGT\nCGGACAACTGT\nCGGACAAGAGT\nCGGACAAGCGT\nCGGACAAGGGT\nCGGACAAGTGT\nCGGACAATAGT\nCGGACAATCGT\nCGGACAATGGT\nCGGACAATTGT\nCGGACACAAGT\nCGGACACACGT\nCGGACACAGGT\nCGGACACATGT\nCGGACACCAGT\nCGGACACCCGT\nCGGACACCGGT\nCGGACACCTGT\nCGGACACGAGT\nCGGACACGCGT\nCGGACACGGGT\nCGGACACGTGT\nCGGACACTAGT\nCGGACACTCGT\nCGGACACTGGT\nCGGACACTTGT\nCGGACAGAAGT\nCGGACAGACGT\nCGGACAGAGGT\nCGGACAGATGT\nCGGACAGCAGT\nCGGACAGCCGT\nCGGACAGCGGT\nCGGACAGCTGT\nCGGACAGGAGT\nCGGACAGGCGT\nCGGACAGGGGT\nCGGACAGGTGT\nCGGACAGTAGT\nCGGACAGTCGT\nCGGACAGTGGT\nCGGACAGTTGT\nCGGACATAAGT\nCGGACATACGT\nCGGACATAGGT\nCGGACATATGT\nCGGACATCAGT\nCGGACATCCGT\nCGGACATCGGT\nCGGACATCTGT\nCGGACATGAGT\nCGGACATGCGT\nCGGACATGGGT\nCGGACATGTGT\nCGGACATTAGT\nCGGACATTCGT\nCGGACATTGGT\nCGGACATTTGT\nCGGACCAAAGT\nCGGACCAACGT\nCGGACCAAGGT\nCGGACCAATGT\nCGGACCACAGT\nCGGACCACCGT\nCGGACCACGGT\nCGGACCACTGT\nCGGACCAGAGT\nCGGACCAGCGT\nCGGACCAGGGT\nCGGACCAGTGT\nCGGACCATAGT\nCGGACCATCGT\nCGGACCATGGT\nCGGACCATTGT\nCGGACCCAAGT\nCGGACCCACGT\nCGGACCCAGGT\nCGGACCCATGT\nCGGACCCCAGT\nCGGACCCCCGT\nCGGACCCCGGT\nCGGACCCCTGT\nCGGACCCGAGT\nCGGACCCGCGT\nCGGACCCGGGT\nCGGACCCGTGT\nCGGACCCTAGT\nCGGACCCTCGT\nCGGACCCTGGT\nCGGACCCTTGT\nCGGACCGAAGT\nCGGACCGACGT\nCGGACCGAGGT\nCGGACCGATGT\nCGGACCGCAGT\nCGGACCGCCGT\nCGGACCGCGGT\nCGGACCGCTGT\nCGGACCGGAGT\nCGGACCGGCGT\nCGGACCGGGGT\nCGGACCGGTGT\nCGGACCGTAGT\nCGGACCGTCGT\nCGGACCGTGGT\nCGGACCGTTGT\nCGGACCTAAGT\nCGGACCTACGT\nCGGACCTAGGT\nCGGACCTATGT\nCGGACCTCAGT\nCGGACCTCCGT\nCGGACCTCGGT\nCGGACCTCTGT\nCGGACCTGAGT\nCGGACCTGCGT\nCGGACCTGGGT\nCGGACCTGTGT\nCGGACCTTAGT\nCGGACCTTCGT\nCGGACCTTGGT\nCGGACCTTTGT\nCGGACGAAAGT\nCGGACGAACGT\nCGGACGAAGGT\nCGGACGAATGT\nCGGACGACAGT\nCGGACGACCGT\nCGGACGACGGT\nCGGACGACTGT\nCGGACGAGAGT\nCGGACGAGCGT\nCGGACGAGGGT\nCGGACGAGTGT\nCGGACGATAGT\nCGGACGATCGT\nCGGACGATGGT\nCGGACGATTGT\nCGGACGCAAGT\nCGGACGCACGT\nCGGACGCAGGT\nCGGACGCATGT\nCGGACGCCAGT\nCGGACGCCCGT\nCGGACGCCGGT\nCGGACGCCTGT\nCGGACGCGAGT\nCGGACGCGCGT\nCGGACGCGGGT\nCGGACGCGTGT\nCGGACGCTAGT\nCGGACGCTCGT\nCGGACGCTGGT\nCGGACGCTTGT\nCGGACGGAAGT\nCGGACGGACGT\nCGGACGGAGGT\nCGGACGGATGT\nCGGACGGCAGT\nCGGACGGCCGT\nCGGACGGCGGT\nCGGACGGCTGT\nCGGACGGGAGT\nCGGACGGGCGT\nCGGACGGGGGT\nCGGACGGGTGT\nCGGACGGTAGT\nCGGACGGTCGT\nCGGACGGTGGT\nCGGACGGTTGT\nCGGACGTAAGT\nCGGACGTACGT\nCGGACGTAGGT\nCGGACGTATGT\nCGGACGTCAGT\nCGGACGTCCGT\nCGGACGTCGGT\nCGGACGTCTGT\nCGGACGTGAGT\nCGGACGTGCGT\nCGGACGTGGGT\nCGGACGTGTGT\nCGGACGTTAGT\nCGGACGTTCGT\nCGGACGTTGGT\nCGGACGTTTGT\nCGGACTAAAGT\nCGGACTAACGT\nCGGACTAAGGT\nCGGACTAATGT\nCGGACTACAGT\nCGGACTACCGT\nCGGACTACGGT\nCGGACTACTGT\nCGGACTAGAGT\nCGGACTAGCGT\nCGGACTAGGGT\nCGGACTAGTGT\nCGGACTATAGT\nCGGACTATCGT\nCGGACTATGGT\nCGGACTATTGT\nCGGACTCAAGT\nCGGACTCACGT\nCGGACTCAGGT\nCGGACTCATGT\nCGGACTCCAGT\nCGGACTCCCGT\nCGGACTCCGGT\nCGGACTCCTGT\nCGGACTCGAGT\nCGGACTCGCGT\nCGGACTCGGGT\nCGGACTCGTGT\nCGGACTCTAGT\nCGGACTCTCGT\nCGGACTCTGGT\nCGGACTCTTGT\nCGGACTGAAGT\nCGGACTGACGT\nCGGACTGAGGT\nCGGACTGATGT\nCGGACTGCAGT\nCGGACTGCCGT\nCGGACTGCGGT\nCGGACTGCTGT\nCGGACTGGAGT\nCGGACTGGCGT\nCGGACTGGGGT\nCGGACTGGTGT\nCGGACTGTAGT\nCGGACTGTCGT\nCGGACTGTGGT\nCGGACTGTTGT\nCGGACTTAAGT\nCGGACTTACGT\nCGGACTTAGGT\nCGGACTTATGT\nCGGACTTCAGT\nCGGACTTCCGT\nCGGACTTCGGT\nCGGACTTCTGT\nCGGACTTGAGT\nCGGACTTGCGT\nCGGACTTGGGT\nCGGACTTGTGT\nCGGACTTTAGT\nCGGACTTTCGT\nCGGACTTTGGT\nCGGACTTTTGT\nCGGAGAAAAGT\nCGGAGAAACGT\nCGGAGAAAGGT\nCGGAGAAATGT\nCGGAGAACAGT\nCGGAGAACCGT\nCGGAGAACGGT\nCGGAGAACTGT\nCGGAGAAGAGT\nCGGAGAAGCGT\nCGGAGAAGGGT\nCGGAGAAGTGT\nCGGAGAATAGT\nCGGAGAATCGT\nCGGAGAATGGT\nCGGAGAATTGT\nCGGAGACAAGT\nCGGAGACACGT\nCGGAGACAGGT\nCGGAGACATGT\nCGGAGACCAGT\nCGGAGACCCGT\nCGGAGACCGGT\nCGGAGACCTGT\nCGGAGACGAGT\nCGGAGACGCGT\nCGGAGACGGGT\nCGGAGACGTGT\nCGGAGACTAGT\nCGGAGACTCGT\nCGGAGACTGGT\nCGGAGACTTGT\nCGGAGAGAAGT\nCGGAGAGACGT\nCGGAGAGAGGT\nCGGAGAGATGT\nCGGAGAGCAGT\nCGGAGAGCCGT\nCGGAGAGCGGT\nCGGAGAGCTGT\nCGGAGAGGAGT\nCGGAGAGGCGT\nCGGAGAGGGGT\nCGGAGAGGTGT\nCGGAGAGTAGT\nCGGAGAGTCGT\nCGGAGAGTGGT\nCGGAGAGTTGT\nCGGAGATAAGT\nCGGAGATACGT\nCGGAGATAGGT\nCGGAGATATGT\nCGGAGATCAGT\nCGGAGATCCGT\nCGGAGATCGGT\nCGGAGATCTGT\nCGGAGATGAGT\nCGGAGATGCGT\nCGGAGATGGGT\nCGGAGATGTGT\nCGGAGATTAGT\nCGGAGATTCGT\nCGGAGATTGGT\nCGGAGATTTGT\nCGGAGCAAAGT\nCGGAGCAACGT\nCGGAGCAAGGT\nCGGAGCAATGT\nCGGAGCACAGT\nCGGAGCACCGT\nCGGAGCACGGT\nCGGAGCACTGT\nCGGAGCAGAGT\nCGGAGCAGCGT\nCGGAGCAGGGT\nCGGAGCAGTGT\nCGGAGCATAGT\nCGGAGCATCGT\nCGGAGCATGGT\nCGGAGCATTGT\nCGGAGCCAAGT\nCGGAGCCACGT\nCGGAGCCAGGT\nCGGAGCCATGT\nCGGAGCCCAGT\nCGGAGCCCCGT\nCGGAGCCCGGT\nCGGAGCCCTGT\nCGGAGCCGAGT\nCGGAGCCGCGT\nCGGAGCCGGGT\nCGGAGCCGTGT\nCGGAGCCTAGT\nCGGAGCCTCGT\nCGGAGCCTGGT\nCGGAGCCTTGT\nCGGAGCGAAGT\nCGGAGCGACGT\nCGGAGCGAGGT\nCGGAGCGATGT\nCGGAGCGCAGT\nCGGAGCGCCGT\nCGGAGCGCGGT\nCGGAGCGCTGT\nCGGAGCGGAGT\nCGGAGCGGCGT\nCGGAGCGGGGT\nCGGAGCGGTGT\nCGGAGCGTAGT\nCGGAGCGTCGT\nCGGAGCGTGGT\nCGGAGCGTTGT\nCGGAGCTAAGT\nCGGAGCTACGT\nCGGAGCTAGGT\nCGGAGCTATGT\nCGGAGCTCAGT\nCGGAGCTCCGT\nCGGAGCTCGGT\nCGGAGCTCTGT\nCGGAGCTGAGT\nCGGAGCTGCGT\nCGGAGCTGGGT\nCGGAGCTGTGT\nCGGAGCTTAGT\nCGGAGCTTCGT\nCGGAGCTTGGT\nCGGAGCTTTGT\nCGGAGGAAAGT\nCGGAGGAACGT\nCGGAGGAAGGT\nCGGAGGAATGT\nCGGAGGACAGT\nCGGAGGACCGT\nCGGAGGACGGT\nCGGAGGACTGT\nCGGAGGAGAGT\nCGGAGGAGCGT\nCGGAGGAGGGT\nCGGAGGAGTGT\nCGGAGGATAGT\nCGGAGGATCGT\nCGGAGGATGGT\nCGGAGGATTGT\nCGGAGGCAAGT\nCGGAGGCACGT\nCGGAGGCAGGT\nCGGAGGCATGT\nCGGAGGCCAGT\nCGGAGGCCCGT\nCGGAGGCCGGT\nCGGAGGCCTGT\nCGGAGGCGAGT\nCGGAGGCGCGT\nCGGAGGCGGGT\nCGGAGGCGTGT\nCGGAGGCTAGT\nCGGAGGCTCGT\nCGGAGGCTGGT\nCGGAGGCTTGT\nCGGAGGGAAGT\nCGGAGGGACGT\nCGGAGGGAGGT\nCGGAGGGATGT\nCGGAGGGCAGT\nCGGAGGGCCGT\nCGGAGGGCGGT\nCGGAGGGCTGT\nCGGAGGGGAGT\nCGGAGGGGCGT\nCGGAGGGGGGT\nCGGAGGGGTGT\nCGGAGGGTAGT\nCGGAGGGTCGT\nCGGAGGGTGGT\nCGGAGGGTTGT\nCGGAGGTAAGT\nCGGAGGTACGT\nCGGAGGTAGGT\nCGGAGGTATGT\nCGGAGGTCAGT\nCGGAGGTCCGT\nCGGAGGTCGGT\nCGGAGGTCTGT\nCGGAGGTGAGT\nCGGAGGTGCGT\nCGGAGGTGGGT\nCGGAGGTGTGT\nCGGAGGTTAGT\nCGGAGGTTCGT\nCGGAGGTTGGT\nCGGAGGTTTGT\nCGGAGTAAAGT\nCGGAGTAACGT\nCGGAGTAAGGT\nCGGAGTAATGT\nCGGAGTACAGT\nCGGAGTACCGT\nCGGAGTACGGT\nCGGAGTACTGT\nCGGAGTAGAGT\nCGGAGTAGCGT\nCGGAGTAGGGT\nCGGAGTAGTGT\nCGGAGTATAGT\nCGGAGTATCGT\nCGGAGTATGGT\nCGGAGTATTGT\nCGGAGTCAAGT\nCGGAGTCACGT\nCGGAGTCAGGT\nCGGAGTCATGT\nCGGAGTCCAGT\nCGGAGTCCCGT\nCGGAGTCCGGT\nCGGAGTCCTGT\nCGGAGTCGAGT\nCGGAGTCGCGT\nCGGAGTCGGGT\nCGGAGTCGTGT\nCGGAGTCTAGT\nCGGAGTCTCGT\nCGGAGTCTGGT\nCGGAGTCTTGT\nCGGAGTGAAGT\nCGGAGTGACGT\nCGGAGTGAGGT\nCGGAGTGATGT\nCGGAGTGCAGT\nCGGAGTGCCGT\nCGGAGTGCGGT\nCGGAGTGCTGT\nCGGAGTGGAGT\nCGGAGTGGCGT\nCGGAGTGGGGT\nCGGAGTGGTGT\nCGGAGTGTAGT\nCGGAGTGTCGT\nCGGAGTGTGGT\nCGGAGTGTTGT\nCGGAGTTAAGT\nCGGAGTTACGT\nCGGAGTTAGGT\nCGGAGTTATGT\nCGGAGTTCAGT\nCGGAGTTCCGT\nCGGAGTTCGGT\nCGGAGTTCTGT\nCGGAGTTGAGT\nCGGAGTTGCGT\nCGGAGTTGGGT\nCGGAGTTGTGT\nCGGAGTTTAGT\nCGGAGTTTCGT\nCGGAGTTTGGT\nCGGAGTTTTGT\nCGGATAAAAGT\nCGGATAAACGT\nCGGATAAAGGT\nCGGATAAATGT\nCGGATAACAGT\nCGGATAACCGT\nCGGATAACGGT\nCGGATAACTGT\nCGGATAAGAGT\nCGGATAAGCGT\nCGGATAAGGGT\nCGGATAAGTGT\nCGGATAATAGT\nCGGATAATCGT\nCGGATAATGGT\nCGGATAATTGT\nCGGATACAAGT\nCGGATACACGT\nCGGATACAGGT\nCGGATACATGT\nCGGATACCAGT\nCGGATACCCGT\nCGGATACCGGT\nCGGATACCTGT\nCGGATACGAGT\nCGGATACGCGT\nCGGATACGGGT\nCGGATACGTGT\nCGGATACTAGT\nCGGATACTCGT\nCGGATACTGGT\nCGGATACTTGT\nCGGATAGAAGT\nCGGATAGACGT\nCGGATAGAGGT\nCGGATAGATGT\nCGGATAGCAGT\nCGGATAGCCGT\nCGGATAGCGGT\nCGGATAGCTGT\nCGGATAGGAGT\nCGGATAGGCGT\nCGGATAGGGGT\nCGGATAGGTGT\nCGGATAGTAGT\nCGGATAGTCGT\nCGGATAGTGGT\nCGGATAGTTGT\nCGGATATAAGT\nCGGATATACGT\nCGGATATAGGT\nCGGATATATGT\nCGGATATCAGT\nCGGATATCCGT\nCGGATATCGGT\nCGGATATCTGT\nCGGATATGAGT\nCGGATATGCGT\nCGGATATGGGT\nCGGATATGTGT\nCGGATATTAGT\nCGGATATTCGT\nCGGATATTGGT\nCGGATATTTGT\nCGGATCAAAGT\nCGGATCAACGT\nCGGATCAAGGT\nCGGATCAATGT\nCGGATCACAGT\nCGGATCACCGT\nCGGATCACGGT\nCGGATCACTGT\nCGGATCAGAGT\nCGGATCAGCGT\nCGGATCAGGGT\nCGGATCAGTGT\nCGGATCATAGT\nCGGATCATCGT\nCGGATCATGGT\nCGGATCATTGT\nCGGATCCAAGT\nCGGATCCACGT\nCGGATCCAGGT\nCGGATCCATGT\nCGGATCCCAGT\nCGGATCCCCGT\nCGGATCCCGGT\nCGGATCCCTGT\nCGGATCCGAGT\nCGGATCCGCGT\nCGGATCCGGGT\nCGGATCCGTGT\nCGGATCCTAGT\nCGGATCCTCGT\nCGGATCCTGGT\nCGGATCCTTGT\nCGGATCGAAGT\nCGGATCGACGT\nCGGATCGAGGT\nCGGATCGATGT\nCGGATCGCAGT\nCGGATCGCCGT\nCGGATCGCGGT\nCGGATCGCTGT\nCGGATCGGAGT\nCGGATCGGCGT\nCGGATCGGGGT\nCGGATCGGTGT\nCGGATCGTAGT\nCGGATCGTCGT\nCGGATCGTGGT\nCGGATCGTTGT\nCGGATCTAAGT\nCGGATCTACGT\nCGGATCTAGGT\nCGGATCTATGT\nCGGATCTCAGT\nCGGATCTCCGT\nCGGATCTCGGT\nCGGATCTCTGT\nCGGATCTGAGT\nCGGATCTGCGT\nCGGATCTGGGT\nCGGATCTGTGT\nCGGATCTTAGT\nCGGATCTTCGT\nCGGATCTTGGT\nCGGATCTTTGT\nCGGATGAAAGT\nCGGATGAACGT\nCGGATGAAGGT\nCGGATGAATGT\nCGGATGACAGT\nCGGATGACCGT\nCGGATGACGGT\nCGGATGACTGT\nCGGATGAGAGT\nCGGATGAGCGT\nCGGATGAGGGT\nCGGATGAGTGT\nCGGATGATAGT\nCGGATGATCGT\nCGGATGATGGT\nCGGATGATTGT\nCGGATGCAAGT\nCGGATGCACGT\nCGGATGCAGGT\nCGGATGCATGT\nCGGATGCCAGT\nCGGATGCCCGT\nCGGATGCCGGT\nCGGATGCCTGT\nCGGATGCGAGT\nCGGATGCGCGT\nCGGATGCGGGT\nCGGATGCGTGT\nCGGATGCTAGT\nCGGATGCTCGT\nCGGATGCTGGT\nCGGATGCTTGT\nCGGATGGAAGT\nCGGATGGACGT\nCGGATGGAGGT\nCGGATGGATGT\nCGGATGGCAGT\nCGGATGGCCGT\nCGGATGGCGGT\nCGGATGGCTGT\nCGGATGGGAGT\nCGGATGGGCGT\nCGGATGGGGGT\nCGGATGGGTGT\nCGGATGGTAGT\nCGGATGGTCGT\nCGGATGGTGGT\nCGGATGGTTGT\nCGGATGTAAGT\nCGGATGTACGT\nCGGATGTAGGT\nCGGATGTATGT\nCGGATGTCAGT\nCGGATGTCCGT\nCGGATGTCGGT\nCGGATGTCTGT\nCGGATGTGAGT\nCGGATGTGCGT\nCGGATGTGGGT\nCGGATGTGTGT\nCGGATGTTAGT\nCGGATGTTCGT\nCGGATGTTGGT\nCGGATGTTTGT\nCGGATTAAAGT\nCGGATTAACGT\nCGGATTAAGGT\nCGGATTAATGT\nCGGATTACAGT\nCGGATTACCGT\nCGGATTACGGT\nCGGATTACTGT\nCGGATTAGAGT\nCGGATTAGCGT\nCGGATTAGGGT\nCGGATTAGTGT\nCGGATTATAGT\nCGGATTATCGT\nCGGATTATGGT\nCGGATTATTGT\nCGGATTCAAGT\nCGGATTCACGT\nCGGATTCAGGT\nCGGATTCATGT\nCGGATTCCAGT\nCGGATTCCCGT\nCGGATTCCGGT\nCGGATTCCTGT\nCGGATTCGAGT\nCGGATTCGCGT\nCGGATTCGGGT\nCGGATTCGTGT\nCGGATTCTAGT\nCGGATTCTCGT\nCGGATTCTGGT\nCGGATTCTTGT\nCGGATTGAAGT\nCGGATTGACGT\nCGGATTGAGGT\nCGGATTGATGT\nCGGATTGCAGT\nCGGATTGCCGT\nCGGATTGCGGT\nCGGATTGCTGT\nCGGATTGGAGT\nCGGATTGGCGT\nCGGATTGGGGT\nCGGATTGGTGT\nCGGATTGTAGT\nCGGATTGTCGT\nCGGATTGTGGT\nCGGATTGTTGT\nCGGATTTAAGT\nCGGATTTACGT\nCGGATTTAGGT\nCGGATTTATGT\nCGGATTTCAGT\nCGGATTTCCGT\nCGGATTTCGGT\nCGGATTTCTGT\nCGGATTTGAGT\nCGGATTTGCGT\nCGGATTTGGGT\nCGGATTTGTGT\nCGGATTTTAGT\nCGGATTTTCGT\nCGGATTTTGGT\nCGGATTTTTGT\n'

totalQuestoes=0
notaTotal=0
sumario=$(basename "$PWD")
echo ''
echo -e "${amarelo}              sumário $1            ${normal}"
echo '----------------------'
echo -e 'problema\tacertos / número de testes'
for i in ${!sumarioTotal[@]}; do
	if ! [ -n "${sumarioStatus[$i]}" ]; then
		echo -e $i '\t' ${sumarioAcertos[$i]} / ${sumarioTotal[$i]}
		acertos=${sumarioAcertos[$i]}
		total=${sumarioTotal[$i]}
		sumario=$sumario,$acertos
		if [[ $acertos == $total ]]; then
			notaQuestao=$(echo "$acertos/$total" | bc -l)
		else
			notaQuestao=0
		fi
		notaTotal=$(echo "$notaTotal+$notaQuestao" | bc -l)
	else
		sumario=$sumario,0
		echo -e $i '\t' 'Erro:' ${sumarioStatus[$i]}
	fi
	totalQuestoes=$((totalQuestoes+1))
done
if [ $totalQuestoes -ne 0 ]; then
	echo '----------------------'
	echo 'Nota: ' $(echo "$notaTotal/$totalQuestoes" | bc -l)
fi

#cria um arquivo csv no diretorio superior (interessante para montar uma planilha)
if [ "$criarSumario" = true ]; then
	echo $sumario >> ../sumario.csv
fi

rm gabarito input output exec*

