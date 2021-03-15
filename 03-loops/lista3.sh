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
			timeout 2 ./exec$file < input > output
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

avaliar 'q1' '30 20 8' '3'
avaliar 'q1' '60.0 40.0 11' '4'
avaliar 'q1' '100.0 95.0 7.0' '7'
avaliar 'q1' '10 10 10' '1'
avaliar 'q1' '10 10 15' '0'
avaliar 'q2' '0.85 -4.01 6 13 6.66 -3.26 12.23 -2.66 18.11 -2.44 24.5 -3.02 30.35 -3.51 36.21 -3.62 42.51 -3.73 48.55 -3.63 54.15 -2.76 61.03 -2.66 66.7 -3.21 73.19 -3.56 78.63 -3.71' 'N'
avaliar 'q2' '2.45 -2.33 10 5 12.26 -2.81 23.31 -2.64 32.71 -3.05 42.76 -2.56 53.48 -1.74' 'S'
avaliar 'q2' '0.58 -4.42 2 15 2.75 -4.46 4.66 -4.37 6.52 -4.38 8.59 -4.32 10.63 -4.42 12.87 -4.25 14.86 -4.41 16.64 -4.3 18.78 -4.23 20.75 -4.15 22.68 -4.35 24.75 -4.35 26.63 -4.37 28.45 -4.3 30.58 -4.46' 'N'
avaliar 'q2' '1.01 -2.43 4 15 4.66 -2.67 8.23 -2.63 11.92 -2.63 16.08 -2.78 19.92 -2.93 24.25 -3.18 28.27 -3.3 32.51 -3.43 36.69 -3.15 40.5 -3.13 44.22 -2.75 48.08 -2.75 51.88 -2.72 55.71 -2.87 59.63 -3.02' 'S'
avaliar 'q2' '-1.42 -0.99 10 12 7.52 -2.73 17.9 -1.75 27.24 -3.09 37.59 -2.45 47.06 -2.31 57.89 -3.72 67.91 -3.92 78.26 -3.68 87.49 -3.59 98.0 -3.58 107.4 -3.96 118.35 -3.75' 'S'
avaliar 'q2' '-3.12 -0.0 8 15 4.98 -0.98 12.07 -0.88 19.92 -1.94 26.32 -2.42 34.68 -2.2 44.0 -2.38 52.42 -2.27 60.88 -2.64 69.54 -2.49 78.01 -3.8 85.29 -3.76 93.7 -3.25 101.17 -3.24 108.62 -2.72 116.25 -2.93' 'N'
avaliar 'q2' '-0.39 -1.21 7 9 6.12 -2.32 13.26 -2.19 20.64 -1.93 27.9 -2.53 34.47 -3.4 41.39 -3.63 47.6 -3.24 54.19 -3.28 60.64 -4.38' 'S'

avaliar 'q3' '1 2' 'S'
avaliar 'q3' '6 8' 'S'
avaliar 'q3' '66 76' 'S'
avaliar 'q3' '140 195' 'S'
avaliar 'q3' '440 638' 'S'
avaliar 'q3' '1178 744' 'S'
avaliar 'q3' '900 712' 'N'
avaliar 'q3' '54 48' 'N'
avaliar 'q3' '40 50' 'N'
avaliar 'q3' '120 243' 'N'
avaliar 'q3' '1000 1013' 'N'
avaliar 'q3' '48 12' 'N'

avaliar 'q4' '0.9 2.53 1.53 1.73 1.42 0.77 1.58 0.57 1.42 0.68 1.15 0.04 1.98 -1.34 0.45 -0.83 1.25 -0.29 1.31 -0.86' '97'
avaliar 'q4' '-1.74 1.65 0.1 -1.21 -0.21 1.17 0.9 4.37 1.38 1.6 -1.93 2.52 1.76 0.78 1.13 -0.4 -2.84 -1.37 -2.71 0.32' '46'
avaliar 'q4' '2.5 5.01 4.89 3.62 4.12 2.78 6.03 -2.01 6.97 -1.72 4.85 -2.4 3.42 -1.08 -4.56 -2.42 -5.35 -2.25 -0.5 1.01' '26'
avaliar 'q4' '-2.2 -0.86 -3.91 1.35 -2.12 3.36 -1.43 0.9 -0.9 1.75 0.05 -1.94 3.74 1.38 0.42 -3.69 2.35 -2.06 -1.24 -4.5' '33'
avaliar 'q4' '-2.8 0.7 -2.83 1.94 -2.78 1.89 -1.74 0.9 -2.02 1.99 -1.76 1.69 -0.58 1.35 -1.63 1.24 -1.54 0.99 -1.64 0.32' '75'
avaliar 'q4' '1.85 -2.3 1.28 -2.9 0.93 -1.79 0.15 0.13 0.43 -0.35 0.34 -0.58 0.38 0.02 -0.63 0.77 -0.82 1.8 -1.61 1.14' '104'
avaliar 'q4' '-2.59 -0.53 -2.36 0.34 -2.54 0.65 -2.3 -0.56 -2.16 0.09 -2.04 -0.23 -0.95 1.36 -0.0 0.96 -0.29 0.43 -0.41 1.07' '95'

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