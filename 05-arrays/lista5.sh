#!/bin/bash

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
			timeout 20 ./exec$file < input > output
			printf 'Teste %d: ' ${sumarioTotal[$1]}
			if ! diff -wB output gabarito > /dev/null; then
				echo -e "${vermelho} [x]${normal}"
				echo -e '\tEntrada:' "${azul} $2 ${normal}"
				echo -e '\tSaída do seu programa:' "${azul} $(cat output) ${normal}"
				echo -e '\tSaída esperada       :' "${azul} $3 ${normal}"
			else
				echo -e "${verde} [ok] ${normal}"
				sumarioAcertos[$1]=$((sumarioAcertos[$1]+1))
			fi
		fi
	else
		sumarioStatus[$1]='código '$file.c' não existe'
	fi
}

avaliar 'q1' '4 1 2 3 4 1 5 3 5' '2 acertos'
avaliar 'q1' '4 1 2 3 4 1 2 3 4' '4 acertos'
avaliar 'q1' '7 1 2 3 2 1 5 4 3 3 3 3 3 3 3' '1 acerto'
avaliar 'q1' '7 1 2 3 2 1 5 4 1 2 2 2 2 5 5' '4 acertos'
avaliar 'q1' '20 4 5 3 2 1 2 5 3 2 4 1 5 4 4 4 2 3 4 2 3  4 4 2 2 2 3 5 4 2 2 1 4 1 4 4 3 3 5 2 3' '10 acertos'

avaliar 'q2' '55 6 2 47 11 5 8 46' '1 3 4 6 7 9 10 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 48 49 50 51 52 53 54 55'
avaliar 'q2' '27 22 8 11 22 17 10 14 9 27 15 18 3 21 26 25 6 19 1 20 23 16 24 2' '4 5 7 12 13'
avaliar 'q2' '56 41 26 32 30 13 52 24 7 43 21 42 38 23 53 27 25 11 54 31 45 46 34 2 19 22 40 51 44 33 18 17 50 29 1 10 12 56 41 39 37 49 15' '3 4 5 6 8 9 14 16 20 28 35 36 47 48 55'
avaliar 'q2' '82 62 6 67 77 14 53 57 11 50 60 19 66 80 44 63 3 22 23 62 59 18 64 30 24 82 32 68 7 56 12 65 38 31 41 1 54 78 72 16 39 34 79 70 40 10 26 69 74 81 35 75 51 76 9 47 52 33 58 73 21 5 71 45' '2 4 8 13 15 17 20 25 27 28 29 36 37 42 43 46 48 49 55 61'
avaliar 'q2' '44 3 22 15 3' '1 2 4 5 6 7 8 9 10 11 12 13 14 16 17 18 19 20 21 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44'
avaliar 'q2' '86 29 23 8 50 82 6 38 42 13 36 69 1 21 5 43 25 70 41 55 62 16 30 17 47 33 71 83 39 85 44' '2 3 4 7 9 10 11 12 14 15 18 19 20 22 24 26 27 28 29 31 32 34 35 37 40 45 46 48 49 51 52 53 54 56 57 58 59 60 61 63 64 65 66 67 68 72 73 74 75 76 77 78 79 80 81 84 86'
avaliar 'q2' '14 2 3 8' '1 2 4 5 6 7 9 10 11 12 13 14'
avaliar 'q2' '66 19 12 19 40 14 23 28 65 41 39 38 34 10 20 60 54 63 25 44 62' '1 2 3 4 5 6 7 8 9 11 13 15 16 17 18 21 22 24 26 27 29 30 31 32 33 35 36 37 42 43 45 46 47 48 49 50 51 52 53 55 56 57 58 59 61 64 66'
avaliar 'q2' '6 6 3 2 1 6 5 4' ''
avaliar 'q2' '83 23 29 31 25 83 17 51 57 22 54 33 18 50 4 8 75 52 26 11 78 65 16 62 14' '1 2 3 5 6 7 9 10 12 13 15 19 20 21 23 24 27 28 30 32 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 53 55 56 58 59 60 61 63 64 66 67 68 69 70 71 72 73 74 76 77 79 80 81 82'
avaliar 'q2' '22 2 13 22' '1 2 3 4 5 6 7 8 9 10 11 12 14 15 16 17 18 19 20 21'
avaliar 'q2' '4 0' '1 2 3 4'
avaliar 'q2' '47 6 27 22 6 21 28 7' '1 2 3 4 5 8 9 10 11 12 13 14 15 16 17 18 19 20 23 24 25 26 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47'
avaliar 'q2' '58 28 29 34 6 36 1 39 52 28 37 54 12 41 21 35 15 40 10 50 27 51 13 14 45 55 46 53 33 38' '2 3 4 5 7 8 9 11 16 17 18 19 20 22 23 24 25 26 30 31 32 42 43 44 47 48 49 56 57 58'
avaliar 'q2' '21 18 2 16 18 21 20 10 17 8 1 3 11 13 7 4 12 14 5 19' '6 9 15'
avaliar 'q2' '25 9 6 9 12 18 2 25 10 8 11' '1 3 4 5 7 13 14 15 16 17 19 20 21 22 23 24'
avaliar 'q2' '72 51 27 33 50 57 68 19 11 1 14 58 4 70 34 3 63 18 7 30 39 56 37 43 60 20 42 51 59 54 38 72 29 25 44 35 40 48 55 13 45 12 49 53 65 41 5 2 61 8 67 32 46' '6 9 10 15 16 17 21 22 23 24 26 28 31 36 47 52 62 64 66 69 71'
avaliar 'q2' '53 0' '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53'
avaliar 'q2' '74 35 29 25 36 49 58 44 57 14 65 1 54 6 46 11 27 63 8 30 53 39 5 64 34 61 48 16 68 40 13 74 4 73 72 67 52' '2 3 7 9 10 12 15 17 18 19 20 21 22 23 24 26 28 31 32 33 35 37 38 41 42 43 45 47 50 51 55 56 59 60 62 66 69 70 71'
avaliar 'q2' '70 11 53 34 33 15 5 1 68 66 46 69 3' '2 4 6 7 8 9 10 11 12 13 14 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 35 36 37 38 39 40 41 42 43 44 45 47 48 49 50 51 52 54 55 56 57 58 59 60 61 62 63 64 65 67 70'
avaliar 'q2' '85 54 30 70 14 40 81 51 75 27 58 66 13 67 57 79 68 83 76 1 16 78 38 5 59 29 18 46 3 47 22 82 6 71 34 37 15 33 60 20 24 73 7 54 42 32 8 63 25 53 65 12 45 28 77 4' '2 9 10 11 17 19 21 23 26 31 35 36 39 41 43 44 48 49 50 52 55 56 61 62 64 69 72 74 80 84 85'

avaliar 'q3' ' 18 3 4 1 3 1 10 10 2 10 4 1 12 7 12 4 5 2 9 ' ' 1 '
avaliar 'q3' ' 14 4 1 2 13 10 8 9 1 5 8 13 7 5 1 ' ' 6 '
avaliar 'q3' ' 28 13 10 24 12 1 5 21 15 19 24 22 10 19 4 10 18 5 15 2 21 8 8 13 21 6 13 2 6 ' ' 6 '
avaliar 'q3' ' 18 9 12 6 11 3 7 15 13 15 2 4 10 13 10 1 12 11 9 ' ' 1 '
avaliar 'q3' ' 27 3 1 13 4 4 12 13 2 17 7 11 2 6 15 13 5 5 10 6 15 5 14 11 17 11 2 9 ' ' 14 '
avaliar 'q3' ' 18 1 12 12 3 9 1 16 1 7 16 8 2 10 4 7 7 13 1 ' ' 2 '
avaliar 'q3' ' 24 13 9 15 9 8 9 1 3 7 5 7 2 2 7 15 4 7 12 3 7 6 3 10 12 ' ' 11 '
avaliar 'q3' ' 27 6 8 10 8 2 6 12 11 4 17 5 7 11 3 2 17 11 12 12 6 15 13 1 14 13 4 14 ' ' 5 '
avaliar 'q3' ' 13 5 6 2 6 7 9 2 4 9 2 4 2 1 ' ' 2 '
avaliar 'q3' ' 17 8 5 10 12 8 16 10 7 8 11 7 16 3 7 8 5 5 ' ' 5 '
avaliar 'q3' ' 12 12 4 7 2 8 7 10 6 2 12 1 9 ' ' 8 '
avaliar 'q3' ' 22 2 9 12 9 2 13 3 10 15 2 3 13 8 15 1 12 1 7 12 5 7 9 ' ' 4 '
avaliar 'q3' ' 28 1 17 19 16 7 23 9 15 4 7 23 12 18 11 12 10 13 2 10 4 11 10 6 13 14 9 17 2 ' ' 4 '
avaliar 'q3' ' 19 3 12 3 2 14 12 12 7 6 14 1 1 4 7 3 1 5 5 2 ' ' 4 '
avaliar 'q3' ' 22 5 1 4 6 14 20 10 6 11 5 12 10 20 3 3 17 8 10 13 11 8 3 ' ' 6 '
avaliar 'q3' ' 15 6 5 4 3 6 9 7 6 9 5 6 6 5 5 2 ' ' 2 '
avaliar 'q3' ' 21 14 1 4 10 18 9 7 6 5 6 18 15 15 11 9 4 15 13 11 14 4 ' ' 5 '
avaliar 'q3' ' 28 7 16 14 2 21 5 9 8 5 3 23 16 14 1 6 21 18 4 21 17 26 21 26 22 11 4 18 8 ' ' 1 '
avaliar 'q3' ' 22 14 12 14 11 17 17 19 2 1 16 16 9 2 14 6 12 6 1 19 12 4 3 ' ' 11 '
avaliar 'q3' ' 25 15 14 3 3 10 13 1 6 15 13 10 18 6 7 7 4 18 11 1 8 3 16 5 1 16 ' ' 4 '

avaliar 'q4' '1 2 3 4 5 6 7 8 9 0' '0'
avaliar 'q4' '5 4 2 8 7 4 2 1 0 2' '4'
avaliar 'q4' '3 2 4 6 8 1 4 5 9 7' '4'
avaliar 'q4' '5 2 1 4 6 1 4 0 1 0' '1'
avaliar 'q4' '4 3 7 4 2 8 9 5 2 6' '2'
avaliar 'q4' '7 9 3 1 2 8 9 4 6 5' '9'
avaliar 'q4' '2 5 4 0 3 7 5 5 5 5' '0'
avaliar 'q4' '3 8 1 9 2 7 8 4 5 6' '8'
avaliar 'q4' '5 2 3 1 1 8 4 5 7 6' '5'
avaliar 'q4' '7 5 3 1 1 2 4 8 9 7' '7'



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
