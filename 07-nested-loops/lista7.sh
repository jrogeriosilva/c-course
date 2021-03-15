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

avaliar 'q1' ' 15 20 33001 77001 51001 13001 78001 87001 75001 50001 98001 53001 80001 91001 31001 14001 49001 76001 87001 2001 41001 62001 45001 94001 23001 11001 73001 1 31001 43001 40001 16001 90001 42001 59001 27001 92001 ' '2\n'
avaliar 'q1' ' 12 13 56001 95001 87001 3001 47001 69001 23001 89001 15001 26001 81001 62001 5001 90001 62001 29001 74001 40001 85001 2001 84001 25001 53001 26001 59001 ' '2\n'
avaliar 'q1' ' 29 31 63001 30001 23001 75001 34001 94001 65001 1001 19001 66001 67001 43001 50001 56001 16001 90001 36001 77001 5001 21001 13001 7001 49001 68001 14001 15001 76001 1 71001 14001 80001 75001 44001 49001 4001 67001 72001 6001 91001 59001 19001 78001 71001 7001 66001 46001 35001 38001 13001 9001 36001 69001 83001 17001 31001 68001 12001 99001 73001 63001 ' '12\n'
avaliar 'q1' ' 23 24 65001 73001 71001 52001 89001 85001 23001 57001 28001 37001 82001 93001 14001 90001 72001 92001 88001 50001 26001 44001 61001 46001 30001 32001 9001 7001 55001 61001 1001 43001 65001 15001 23001 18001 25001 37001 12001 81001 96001 60001 90001 62001 78001 31001 47001 88001 16001 ' '6\n'
avaliar 'q1' ' 4 6 15001 36001 13001 87001 81001 34001 91001 51001 4001 64001 ' '0\n'
avaliar 'q1' ' 18 21 24001 23001 83001 93001 52001 59001 98001 65001 15001 27001 70001 81001 76001 53001 19001 39001 20001 94001 97001 12001 8001 5001 79001 19001 7001 44001 78001 36001 41001 25001 95001 35001 16001 81001 47001 39001 1001 3001 14001 ' '3\n'
avaliar 'q1' ' 18 19 91001 47001 33001 70001 45001 56001 37001 93001 80001 75001 24001 46001 3001 57001 41001 51001 5001 2001 96001 23001 93001 19001 85001 1 51001 7001 42001 43001 10001 77001 9001 66001 5001 24001 62001 40001 31001 ' '4\n'
avaliar 'q1' ' 2 2 68001 72001 52001 82001 ' '0\n'
avaliar 'q1' ' 6 7 65001 58001 89001 94001 12001 7001 86001 94001 58001 78001 9001 79001 52001 ' '2\n'
avaliar 'q1' ' 3 5 64001 26001 1001 19001 11001 53001 51001 48001 ' '0\n'
avaliar 'q1' ' 7 8 14001 43001 29001 83001 85001 52001 15001 87001 57001 98001 9001 67001 20001 17001 40001 ' '0\n'
avaliar 'q1' ' 8 8 45001 16001 54001 78001 53001 4001 31001 7001 4001 67001 38001 77001 90001 92001 60001 62001 ' '1\n'
avaliar 'q1' ' 20 20 24001 70001 13001 55001 58001 79001 56001 67001 37001 54001 98001 21001 7001 36001 50001 95001 27001 6001 96001 22001 9001 7001 46001 28001 41001 66001 90001 59001 35001 8001 98001 11001 23001 76001 96001 16001 60001 92001 34001 10001 ' '3\n'
avaliar 'q1' ' 20 20 35001 91001 28001 61001 68001 89001 52001 88001 62001 9001 95001 73001 18001 5001 53001 27001 66001 83001 97001 49001 17001 23001 58001 28001 66001 1 16001 79001 63001 57001 96001 51001 99001 7001 89001 74001 21001 55001 52001 36001 ' '4\n'
avaliar 'q1' ' 18 21 64001 6001 27001 35001 73001 7001 2001 69001 65001 80001 49001 67001 97001 22001 57001 94001 8001 98001 23001 96001 82001 78001 40001 50001 34001 41001 7001 57001 26001 17001 30001 91001 68001 47001 31001 21001 10001 73001 24001 ' '3\n'

avaliar 'q2' '61 94 203 272 236 353 242 134 47 22 28 25' 'Junho 353\nAbril 272\nJulho 242\nMaio 236\nMarco 203\nAgosto 134\nFevereiro 94\nJaneiro 61\nSetembro 47\nNovembro 28\nDezembro 25\nOutubro 22\n'
avaliar 'q2' '74 200 53 77 56 150 98 399 34 4 9 78' 'Agosto 399\nFevereiro 200\nJunho 150\nJulho 98\nDezembro 78\nAbril 77\nJaneiro 74\nMaio 56\nMarco 53\nSetembro 34\nNovembro 9\nOutubro 4\n'

avaliar 'q3' '10 5 8 7 3 9 4 2 10 1 6 9 4 10 5 3 6 7 1 2 8' '10'
avaliar 'q3' '11 10 1 7 2 5 4 11 6 8 9 3 1 3 11 8 5 4 6 9 2 10 7' '3'
avaliar 'q3' '4 2 3 1 4 3 1 4 2' 'empate'
avaliar 'q3' '17 7 3 10 11 6 1 5 15 14 16 4 8 13 9 17 2 12 10 16 14 7 13 11 4 1 2 9 12 3 6 8 17 5 15' 'empate'
avaliar 'q3' '7 7 2 3 5 6 1 4 2 7 3 5 1 6 4' 'empate'
avaliar 'q3' '17 8 3 6 2 4 7 16 10 13 9 12 5 14 11 1 15 17 2 13 7 4 10 12 14 1 8 5 6 3 15 11 17 9 16' 'empate'
avaliar 'q3' '10 6 3 8 9 5 1 2 10 7 4 8 1 2 7 10 9 4 5 3 6' '7'
avaliar 'q3' '18 12 2 3 6 10 1 8 11 7 18 5 16 14 15 4 17 9 13 5 11 10 6 1 8 3 7 4 9 16 15 12 2 14 13 18 17' '5'
avaliar 'q3' '20 9 10 11 12 17 8 4 6 3 13 1 19 14 18 7 16 5 2 20 15 8 18 6 17 2 3 19 11 4 10 15 13 1 14 7 20 5 16 9 12' '2'

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
