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

avaliar 'q2' '6 3' 'Resultado: 2'
avaliar 'q2' '6 4' ''
avaliar 'q2' '12 4' 'Resultado: 3'
avaliar 'q2' '100 5' 'Resultado: 20'
avaliar 'q2' '100 11' ''

avaliar 'q3' '30 28 2' 'Digite A: Digite B: Digite C: Um dos números é a soma dos outros dois'
avaliar 'q3' '20 35 15' 'Digite A: Digite B: Digite C: Um dos números é a soma dos outros dois'
avaliar 'q3' '25 45 70' 'Digite A: Digite B: Digite C: Um dos números é a soma dos outros dois'
avaliar 'q3' '4 2 2' 'Digite A: Digite B: Digite C: Um dos números é a soma dos outros dois'
avaliar 'q3' '0 0 0' 'Digite A: Digite B: Digite C: Um dos números é a soma dos outros dois'
avaliar 'q3' '31 28 2' 'Digite A: Digite B: Digite C: Nenhum dos números é a soma dos outros dois'
avaliar 'q3' '20 36 15' 'Digite A: Digite B: Digite C: Nenhum dos números é a soma dos outros dois'
avaliar 'q3' '25 45 71' 'Digite A: Digite B: Digite C: Nenhum dos números é a soma dos outros dois'

avaliar 'q5' '4' 'Digite o mês: 30 dias'
avaliar 'q5' '6' 'Digite o mês: 30 dias'
avaliar 'q5' '9' 'Digite o mês: 30 dias'
avaliar 'q5' '11' 'Digite o mês: 30 dias'
avaliar 'q5' '2' 'Digite o mês: 29 dias'
avaliar 'q5' '1' 'Digite o mês: 31 dias'
avaliar 'q5' '3' 'Digite o mês: 31 dias'
avaliar 'q5' '5' 'Digite o mês: 31 dias'
avaliar 'q5' '7' 'Digite o mês: 31 dias'
avaliar 'q5' '8' 'Digite o mês: 31 dias'
avaliar 'q5' '10' 'Digite o mês: 31 dias'
avaliar 'q5' '12' 'Digite o mês: 31 dias'

avaliar 'q6' '23 59 0 1' 'Digite as horas do horário inicial: Digite os minutos do horário inicial: Digite as horas do horário final: Digite os minutos do horário final: Resultado: 0h2min'
avaliar 'q6' '12 0 13 5' 'Digite as horas do horário inicial: Digite os minutos do horário inicial: Digite as horas do horário final: Digite os minutos do horário final: Resultado: 1h5min'
avaliar 'q6' '5 3 5 3' 'Digite as horas do horário inicial: Digite os minutos do horário inicial: Digite as horas do horário final: Digite os minutos do horário final: Resultado: 0h0min'
avaliar 'q6' '23 57 0 59' 'Digite as horas do horário inicial: Digite os minutos do horário inicial: Digite as horas do horário final: Digite os minutos do horário final: Resultado: 1h2min'
avaliar 'q6' '23 55 1 10' 'Digite as horas do horário inicial: Digite os minutos do horário inicial: Digite as horas do horário final: Digite os minutos do horário final: Resultado: 1h15min'
avaliar 'q6' '0 0 23 59' 'Digite as horas do horário inicial: Digite os minutos do horário inicial: Digite as horas do horário final: Digite os minutos do horário final: Resultado: 23h59min'
avaliar 'q6' '5 10 6 3' 'Digite as horas do horário inicial: Digite os minutos do horário inicial: Digite as horas do horário final: Digite os minutos do horário final: Resultado: 0h53min'
avaliar 'q6' '5 10 6 23' 'Digite as horas do horário inicial: Digite os minutos do horário inicial: Digite as horas do horário final: Digite os minutos do horário final: Resultado: 1h13min'

avaliar 'q7' '3 4 1 2' 'Maior: 4'
avaliar 'q7' '0 0 0 0' 'Maior: 0'
avaliar 'q7' '-4 -5 -5 -4' 'Maior: -4'
avaliar 'q7' '1 2 -1 4' 'Maior: 4'
avaliar 'q7' '7 3 1 -8' 'Maior: 7'
avaliar 'q7' '18 1 19 4' 'Maior: 19'

avaliar 'q9' '9.3 9.1 8.2' 'Digite a primeira nota: Digite a segunda nota: Digite a terceira nota: Conceito: B'
avaliar 'q9' '9.4 9.8 9.3' 'Digite a primeira nota: Digite a segunda nota: Digite a terceira nota: Conceito: A'
avaliar 'q9' '7.3 5.8 8.9' 'Digite a primeira nota: Digite a segunda nota: Digite a terceira nota: Conceito: C'
avaliar 'q9' '5.4 4.8 8.3' 'Digite a primeira nota: Digite a segunda nota: Digite a terceira nota: Conceito: D'
avaliar 'q9' '3.2 1.9 0.3' 'Digite a primeira nota: Digite a segunda nota: Digite a terceira nota: Conceito: F'

avaliar 'q10' '4 4 4' 'Existe\nClassificação: equilátero'
avaliar 'q10' '8 8 8' 'Existe\nClassificação: equilátero'
avaliar 'q10' '8 9 8' 'Existe\nClassificação: isósceles'
avaliar 'q10' '4 3 3' 'Existe\nClassificação: isósceles'
avaliar 'q10' '7 7 8' 'Existe\nClassificação: isósceles'
avaliar 'q10' '3 4 5' 'Existe\nClassificação: escaleno'
avaliar 'q10' '5 4 3' 'Existe\nClassificação: escaleno'
avaliar 'q10' '4 5 3' 'Existe\nClassificação: escaleno'
avaliar 'q10' '3 5 9' 'Não existe'
avaliar 'q10' '8 20 7' 'Não existe'
avaliar 'q10' '11 5 4' 'Não existe'

avaliar 'q11' '650' 'Digite a renda mensal: Resultado: alto risco'
avaliar 'q11' '699' 'Digite a renda mensal: Resultado: alto risco'
avaliar 'q11' '2100 0' 'Digite a renda mensal: Digite se o histórico de crédito é bom: Resultado: alto risco'
avaliar 'q11' '700 1' 'Digite a renda mensal: Digite se o histórico de crédito é bom: Resultado: médio risco'
avaliar 'q11' '6350 0' 'Digite a renda mensal: Digite se o histórico de crédito é bom: Resultado: médio risco'
avaliar 'q11' '3200 1' 'Digite a renda mensal: Digite se o histórico de crédito é bom: Resultado: baixo risco'


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
		notaQuestao=$(echo "$acertos/$total" | bc -l)
		notaTotal=$(echo "$notaTotal+$notaQuestao" | bc -l)
	else
		sumario=$sumario,0
		echo -e $i '\t' 'Erro:' ${sumarioStatus[$i]}
	fi
	totalQuestoes=$((totalQuestoes+1))
done
if [ $totalQuestoes -ne 0 ]; then
	echo '----------------------'
	echo 'Nota: ' $(echo "2*$notaTotal/$totalQuestoes" | bc -l)
fi

#cria um arquivo csv no diretorio superior (interessante para montar uma planilha)
if [ "$criarSumario" = true ]; then
	echo $sumario >> ../sumario.csv
fi

rm gabarito input output exec*
