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

avaliar 'q1' '..xxx.x..x 0' '0'
avaliar 'q1' '..xxx.x..x 1' '1'
avaliar 'q1' '..xxx.x..x 5' '2'
avaliar 'q1' '..xxx.x..x 4' 'bum!'
avaliar 'q1' '..xxx.x..x 9' 'bum!'
avaliar 'q1' '..xxx.x..x 8' '1'
avaliar 'q1' 'x 0' 'bum!'
avaliar 'q1' '. 0' '0'
avaliar 'q1' '.x 1' 'bum!'
avaliar 'q1' 'x. 1' '1'
avaliar 'q1' '.x 0' '1'
avaliar 'q1' '.. 1' '0'

avaliar 'q2' 'ABC-9231' 'brasileiro'
avaliar 'q2' 'aBC-9231' 'invalido'
avaliar 'q2' 'AbC-9231' 'invalido'
avaliar 'q2' 'ABc-9231' 'invalido'
avaliar 'q2' 'ABC 9231' 'invalido'
avaliar 'q2' 'ABC-$231' 'invalido'
avaliar 'q2' 'ABC-1$31' 'invalido'
avaliar 'q2' 'ABC-12$1' 'invalido'
avaliar 'q2' 'ABC-123$' 'invalido'
avaliar 'q2' 'ABC-A231' 'invalido'
avaliar 'q2' 'ABC-1A31' 'invalido'
avaliar 'q2' 'ABC-12A1' 'invalido'
avaliar 'q2' 'ABC-123A' 'invalido'
avaliar 'q2' '$ABC-9231' 'invalido'
avaliar 'q2' 'ABC$-9231' 'invalido'
avaliar 'q2' 'ABC-$9231' 'invalido'
avaliar 'q2' 'ABC-9231$' 'invalido'
avaliar 'q2' 'ABC--9231' 'invalido'
avaliar 'q2' 'ABC-92311' 'invalido'
avaliar 'q2' 'ABC-923' 'invalido'
avaliar 'q2' 'ABC-92' 'invalido'
avaliar 'q2' 'ABC-9' 'invalido'
avaliar 'q2' '1234-ABC' 'invalido'
avaliar 'q2' 'A2B2-C88' 'invalido'
avaliar 'q2' '-ABC9231' 'invalido'
avaliar 'q2' 'ABC1D23' 'mercosul'
avaliar 'q2' 'PWD9E12' 'mercosul'
avaliar 'q2' 'SQR2T34' 'mercosul'
avaliar 'q2' 'ABS9M22' 'mercosul'
avaliar 'q2' 'ABS9M23A' 'invalido'
avaliar 'q2' 'ZABS9M23' 'invalido'
avaliar 'q2' 'ABS9M23-' 'invalido'
avaliar 'q2' 'ABSM923' 'invalido'
avaliar 'q2' 'aBS9M23' 'invalido'
avaliar 'q2' 'AbS9M23' 'invalido'
avaliar 'q2' 'ABs9M23' 'invalido'
avaliar 'q2' 'ABS9m23' 'invalido'
avaliar 'q2' 'ABSM923' 'invalido'
avaliar 'q2' 'ABS-9M22' 'invalido'
avaliar 'q2' 'A-BS9M22' 'invalido'
avaliar 'q2' 'ABS9-M22' 'invalido'
avaliar 'q2' 'ABS9M22-' 'invalido'
avaliar 'q2' 'RTFG987' 'invalido'
avaliar 'q2' '987RTFG' 'invalido'

avaliar 'q3' 'Hugo 19/04' '1'
avaliar 'q3' 'Hugo 19/04 Ana 13/04 Rafael Priscila Gustavo Ricardo André Rodrigo Alberto Rita Leonardo Gaspar Larissa Paulo Ana Mateus Hugo Sara 06/04 Larissa Leonardo Ricardo Karlisson Sara Paulo Hugo 04/04 André Hugo Mateus Priscila Sara Ana Gaspar Alberto Rodrigo Ricardo Larissa Gustavo Rita Paulo Rafael 18/01 André Paulo Rita Gaspar Rodrigo Priscila Hugo Sara Karlisson Ricardo Mateus Larissa Leonardo' '1'
avaliar 'q3' 'André 02/02 Gustavo Mateus Alberto Sara Rita Ana Ricardo Karlisson Gaspar Paulo Leonardo 08/04 Sara Priscila 04/04 Hugo Rodrigo Alberto Gaspar Gustavo Rafael Sara Paulo André Priscila Larissa Rita Karlisson 08/03 Leonardo Alberto Priscila Mateus Rita Sara Ricardo Paulo André Hugo Larissa Rafael 03/01 Gaspar Leonardo Karlisson Alberto Priscila 12/03 Karlisson Priscila' '4'
avaliar 'q3' 'Ricardo 19/04 Paulo Larissa Gustavo Rodrigo 12/03 André Larissa Hugo Paulo Mateus Priscila Rodrigo Sara Ricardo Gustavo Leonardo Karlisson Rafael Rita 04/04 Hugo Larissa Paulo Ricardo 16/04 Paulo Hugo Sara Priscila Mateus Rafael Ricardo' '1'
avaliar 'q3' 'Karlisson 15/03 Rafael Mateus Karlisson Rita Gustavo Alberto Leonardo Hugo Gaspar André Priscila 06/04 Mateus Sara Karlisson Ana Alberto 13/04 Mateus André Gustavo Alberto Larissa Ricardo Paulo Ana Hugo Rodrigo Sara Leonardo 14/01 Priscila 19/04 Ana Mateus André Larissa Karlisson Ricardo Paulo Gaspar 04/03 Gustavo Larissa Mateus Gaspar Ricardo Hugo André Sara Rafael Alberto 20/02 Larissa Mateus Ricardo Ana Gustavo Karlisson Priscila Paulo Leonardo Sara André Rafael Hugo Rita Gaspar Rodrigo 16/04 Rafael Priscila Paulo Rita Ana Mateus Gaspar 23/04 André Sara Larissa Alberto Gustavo Paulo Gaspar Rodrigo Rita' '5'
avaliar 'q3' 'Alberto 22/02 Paulo Gaspar Priscila Ricardo Hugo Rita Alberto Rodrigo Larissa 20/02 Gustavo André Larissa Ricardo Rodrigo Sara Mateus Ana Leonardo Hugo Rafael Gaspar Rita Priscila Paulo Karlisson 04/04 Gustavo Ricardo Rafael Leonardo Hugo Alberto André 18/01 Ana Leonardo Mateus Rodrigo Paulo Rafael Hugo Priscila Gaspar Larissa Gustavo Ricardo André Karlisson 02/02 Gaspar Alberto Hugo Rafael Ana Rita Gustavo Rodrigo 04/02 Priscila Larissa Rodrigo Karlisson Alberto Paulo 12/01 André Rafael Ana Priscila Hugo Mateus Rodrigo Larissa Paulo Alberto Ricardo Leonardo Karlisson Rita Sara Gustavo 13/04 Priscila Ana Leonardo Rafael Gaspar Karlisson Mateus Gustavo Rodrigo Ricardo Hugo Larissa André 15/03 Rafael Leonardo André Paulo Rodrigo Hugo Mateus Priscila Gaspar Rita Alberto 23/04 Rodrigo Sara Paulo André Hugo Rita Ricardo Priscila Rafael Karlisson Gustavo Larissa Alberto Mateus Gaspar' '3'
avaliar 'q3' 'Mateus 16/04 Hugo Rodrigo Ana Rita Ricardo Sara André Paulo Alberto Gaspar Mateus Leonardo 22/02 Ana Alberto Leonardo Gustavo Ricardo Rita Paulo Hugo Rodrigo Mateus Gaspar Larissa Karlisson André Rafael Priscila 13/04 Sara Rafael André Paulo Gustavo Larissa Rodrigo Hugo Gaspar Ana Alberto 06/04 Ana Priscila Mateus Karlisson Hugo Leonardo Rita Gaspar Sara Rodrigo 04/04 André Paulo Mateus Gustavo Sara Alberto Ricardo Rafael Gaspar 12/03 Hugo Rita Gaspar Priscila Ana Rafael Gustavo Alberto Ricardo Mateus André Sara Larissa Rodrigo Leonardo Paulo' '1'
avaliar 'q3' 'Alberto 23/04 Rafael Paulo Ricardo Priscila Karlisson Larissa Mateus André Rita Rodrigo Gustavo' '1'
avaliar 'q3' 'Alberto 04/04 Ana Alberto Karlisson André Hugo Priscila Larissa Sara Gaspar Leonardo Rodrigo Paulo Rafael Mateus 14/01 Hugo Rodrigo Paulo Priscila Ricardo Gustavo Larissa Ana 08/03 Ricardo Paulo Gustavo André 22/02 Sara Ricardo Leonardo André 23/04 Rita Larissa Mateus Paulo Gaspar Hugo Gustavo Alberto Rodrigo Rafael Ricardo 15/03 Alberto Rafael Rita Mateus Gustavo Hugo 05/01 Larissa Ricardo André Paulo Priscila Hugo 16/04 Mateus Rita Sara Leonardo Ricardo Gaspar' '5'
avaliar 'q3' 'Priscila 13/04 Rodrigo Alberto Priscila Paulo Gustavo Sara Rafael Ana Hugo Mateus Karlisson Ricardo Gaspar Larissa 04/04 Sara Paulo Larissa Alberto André Rita Leonardo Gustavo Ricardo Rafael Hugo Priscila Ana Mateus Rodrigo 02/02 Hugo Alberto Gustavo Larissa Mateus Leonardo Rafael Ricardo André Rita Karlisson Sara Ana Rodrigo 12/03 Gustavo Alberto Hugo Priscila Ricardo André Rita Paulo Rodrigo Mateus Gaspar Rafael 08/03 Hugo Larissa Sara Mateus Rodrigo Karlisson Alberto' '2'
avaliar 'q3' 'Rafael 04/02 Rodrigo Rafael Gaspar Mateus Sara Leonardo Larissa Priscila' '0'
avaliar 'q3' 'Rafael 16/04 Priscila Karlisson Mateus Alberto Paulo André Ricardo Sara Leonardo Rita Larissa Gaspar Rodrigo Rafael 19/04 Rodrigo Rita Paulo Gaspar Larissa André Leonardo Alberto 13/04 Alberto Gaspar Hugo Ricardo 04/02 Larissa Rita Rafael Gaspar Gustavo Sara Karlisson Rodrigo Priscila Mateus Alberto Ana Leonardo 08/02 Rita Hugo Gaspar 12/03 Mateus Gaspar Alberto Priscila André Ana Ricardo Rodrigo Leonardo' '4'
avaliar 'q3' 'Gustavo 19/04 Priscila Rodrigo Larissa Ricardo Gustavo Mateus Alberto Rafael André Sara Leonardo Karlisson 22/02 Paulo Ana Karlisson Rafael Hugo Gustavo Gaspar Ricardo André Alberto Mateus Rita Larissa Leonardo Sara 23/04 Alberto Rafael Rita Ricardo Gustavo Rodrigo Larissa Ana André Priscila' '0'
avaliar 'q3' 'Rodrigo 16/04 Gustavo Rodrigo Gaspar Mateus Rafael Rita Sara Alberto Priscila 12/01 Alberto Priscila Gaspar Ricardo Hugo Sara André Ana Gustavo Rafael Mateus Larissa Rita Karlisson Leonardo 15/03 Alberto Ana 02/02 Larissa Karlisson Rafael Leonardo 08/03 Priscila Paulo Gaspar Alberto Larissa 18/03 Rita Mateus' '5'
avaliar 'q3' 'Karlisson 19/04 Ricardo Sara Leonardo Alberto Gustavo Gaspar André Karlisson Priscila Paulo Larissa Ana Rita Rafael 23/04 Mateus 08/04 Rafael Mateus Gustavo Ricardo Karlisson Priscila Hugo Larissa Ana Rodrigo 16/04 Alberto Ricardo André Rafael 14/01 Alberto Larissa Ana Priscila Sara Hugo Rodrigo Gustavo Rita Mateus Paulo 12/01 Karlisson 04/02 Karlisson Priscila Larissa Paulo Ana Hugo Sara André 08/03 Rodrigo Hugo Rita Sara Ana Alberto Larissa Rafael Karlisson Priscila Gaspar' '3'
avaliar 'q3' 'Larissa 04/04 04/02 Ricardo Priscila Karlisson Rodrigo Rafael 18/01 Rodrigo Mateus André Sara 02/02 Priscila Ana Gaspar Rodrigo Leonardo Karlisson Alberto Sara Hugo Larissa Rafael André Mateus' '3'
avaliar 'q3' 'Karlisson 04/03 Hugo Paulo Priscila Ana Ricardo Sara 12/01 Karlisson Mateus Gustavo Rita Rafael Paulo André Alberto Hugo Gaspar Ana 08/02 Paulo Ana' '2'
avaliar 'q3' 'Hugo 12/01 Alberto Gustavo Larissa Rafael Rodrigo Ana Karlisson Ricardo Sara Gaspar Paulo Leonardo André Mateus Rita Hugo 02/02 Mateus Paulo Ana Larissa Priscila Rita Hugo 13/04 Priscila Sara Rafael Mateus Paulo Ricardo Ana Alberto Gustavo André Leonardo Gaspar Hugo Karlisson 04/04 Sara 04/03 Rita Hugo Mateus Alberto Paulo Priscila Ricardo 03/01 Ricardo Sara Larissa Hugo Ana Gaspar Rafael Paulo Alberto André Rita Mateus Priscila Rodrigo Karlisson 06/04 Rafael André Rita Ana Mateus Gaspar Leonardo Larissa Gustavo Sara Hugo Priscila Ricardo Karlisson Alberto Paulo 16/04 Rita Rodrigo 22/02 Hugo Sara Karlisson Ana Leonardo Rodrigo Alberto' '2'
avaliar 'q3' 'Rita 04/02 Alberto Leonardo Gaspar Karlisson Gustavo Rodrigo André Ana Paulo Ricardo Rita Larissa Hugo Priscila Mateus Rafael 08/02 Ricardo Paulo 06/04 14/01 Rodrigo 18/01 02/02 André Karlisson Ricardo Larissa Alberto Paulo Gustavo Ana Priscila Gaspar Mateus Rodrigo Leonardo Sara Hugo 05/01 Mateus Leonardo Priscila Rafael Rita Ana Hugo Karlisson Sara Gaspar Larissa 16/04 Karlisson Alberto Rita Leonardo Rafael Hugo Mateus Sara Larissa Ana' '5'
avaliar 'q3' 'Rita 02/02 Sara Gaspar Ricardo Paulo Rodrigo Larissa 04/02 Alberto Karlisson Ricardo Mateus Rita Paulo 22/02 Leonardo Ana Paulo Ricardo Sara Rafael Larissa Priscila Gustavo Rita Mateus André Hugo Rodrigo Alberto 18/03 André Sara 12/01 Ana Sara Rodrigo Larissa Mateus Rita Ricardo Gaspar Priscila Gustavo Karlisson Leonardo Paulo Rafael Hugo Alberto' '2'
avaliar 'q3' 'Priscila 03/01 Hugo Paulo Gustavo André Ana Gaspar Rafael Rita Rodrigo Karlisson Mateus Sara Alberto Ricardo Priscila Larissa 08/03 Rodrigo Paulo 15/03 18/01 Rafael Ricardo Leonardo Mateus Paulo Alberto Gustavo Larissa Rodrigo Hugo Priscila Sara Gaspar Rita André 05/01 Ricardo Leonardo 04/04 Rafael Alberto Larissa Paulo Gaspar Rita Ricardo Hugo Leonardo Mateus Sara Priscila Ana Gustavo Karlisson 23/04 Hugo André Priscila Karlisson Rafael Gustavo 04/03 Sara Paulo Hugo Priscila Ana Gaspar Rodrigo Leonardo Rafael Ricardo Larissa Alberto Mateus Karlisson 18/03 ' '4'
avaliar 'q3' 'Rita 16/04 Gustavo Karlisson Rodrigo' '1'
avaliar 'q3' 'Rodrigo 19/04 18/03 Gustavo Ricardo Larissa Rafael Paulo 05/01 Karlisson Gaspar Larissa Priscila Gustavo Rita Paulo Rodrigo Ricardo Alberto 12/01 Larissa Karlisson Alberto André Gaspar Mateus Rita Paulo Priscila Gustavo Hugo Ana Leonardo Ricardo Rafael 15/03 Mateus Alberto Gaspar Paulo Rafael Rodrigo Ana Ricardo Hugo Priscila Sara Larissa Leonardo Karlisson André Rita' '3'
avaliar 'q3' 'Sara 22/02 18/01 Ricardo Mateus 20/02 Alberto Leonardo Sara Gaspar Karlisson Rita André Ricardo Mateus Paulo Ana Rodrigo 02/02 Ricardo 08/02 08/04 ' '5'
avaliar 'q3' 'Rodrigo 13/04 Priscila Karlisson Gaspar Mateus Rafael 04/04 Hugo Rodrigo Rafael Paulo Ricardo Priscila Rita André Leonardo Sara Alberto Larissa Gaspar Gustavo' '1'
avaliar 'q3' 'Ana 05/01 Alberto Hugo Gustavo Ana Gaspar Ricardo Paulo Priscila Leonardo Rodrigo Rita Sara 19/04 Sara Leonardo Gustavo Gaspar Alberto Ana Mateus Larissa Hugo Rita André Rodrigo Paulo Ricardo Priscila 16/04 Mateus Rodrigo Larissa Gustavo Priscila Paulo Rita Leonardo André Gaspar Ricardo Ana Rafael Karlisson Alberto Sara 14/01 Alberto Priscila Gaspar Ricardo Karlisson Hugo 20/02 Alberto 18/03 Alberto Leonardo Larissa Mateus Ana Karlisson Rodrigo Sara Priscila 13/04 André Larissa Ana Sara Rita Leonardo Priscila Hugo 02/02 Rodrigo Rita Alberto Mateus Priscila Leonardo Karlisson Ricardo Gaspar Hugo Sara Paulo Ana André Larissa Rafael 06/04 Ricardo Rodrigo Alberto Priscila Rita Karlisson Mateus Gaspar' '3'
avaliar 'q3' 'Alberto 20/02 Gaspar 06/04 Mateus Alberto Karlisson Rodrigo Ana Hugo Gaspar Rafael Rita Priscila 12/03 Sara Priscila Ana Larissa Hugo André Gustavo Gaspar Paulo' '2'
avaliar 'q3' 'Ana 08/03 Rita Ana Paulo Mateus Larissa Karlisson Sara André Gustavo Priscila Ricardo Leonardo 08/04 Rodrigo Rita Sara Larissa Leonardo Priscila Gustavo Mateus Hugo Gaspar 13/04 Leonardo' '2'
avaliar 'q3' 'Gustavo 13/04 Leonardo André Alberto Priscila Rita Gaspar Hugo Rodrigo Paulo Gustavo Larissa Sara Mateus Ricardo Karlisson Ana' '0'
avaliar 'q3' 'Rafael 13/04 Priscila 15/03 Gaspar Priscila Mateus Sara André Ricardo Rita Leonardo 04/03 Paulo Rafael Priscila Mateus André Rodrigo Leonardo Alberto Gaspar Ricardo Gustavo Karlisson Sara 04/04 Ricardo Sara Paulo Hugo Leonardo Ana Rodrigo 06/04 Gustavo Sara Rita Karlisson Hugo Paulo 12/01 Priscila Karlisson Hugo' '5'
avaliar 'q3' 'Alberto 22/02 Paulo André Gustavo Rafael Rita Alberto Leonardo Priscila Gaspar Hugo Sara 08/03 Rafael Mateus Rita Priscila Alberto Gustavo Hugo 16/04 Alberto Larissa Ana Priscila Hugo Karlisson Rodrigo 04/03 Rita Ana Rodrigo Priscila Rafael Mateus Larissa Gaspar Ricardo Sara Paulo Karlisson Alberto André Hugo 15/03 Rita Ricardo' '1'


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
