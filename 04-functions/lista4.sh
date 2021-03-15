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

avaliar 'q1' '18 0 0' '18:00\n19:00\n20:10\n22:40\n06:05'
avaliar 'q1' '23 59 1' '11:59 PM\n12:59 AM\n02:09 AM\n04:39 AM\n12:04 PM'
avaliar 'q1' '0 35 0' '00:35\n01:35\n02:45\n05:15\n12:40'
avaliar 'q1' '15 59 1' '03:59 PM\n04:59 PM\n06:09 PM\n08:39 PM\n04:04 AM'
avaliar 'q1' '13 15 0' '13:15\n14:15\n15:25\n17:55\n01:20'
avaliar 'q1' '11 30 0' '11:30\n12:30\n13:40\n16:10\n23:35'
avaliar 'q1' '11 30 1' '11:30 AM\n12:30 PM\n01:40 PM\n04:10 PM\n11:35 PM'
avaliar 'q1' '12 59 0' '12:59\n13:59\n15:09\n17:39\n01:04'
avaliar 'q1' '12 59 1' '12:59 PM\n01:59 PM\n03:09 PM\n05:39 PM\n01:04 AM'

avaliar 'q2' '' '(5, 7, 11)\n(11, 13, 17)\n(17, 19, 23)\n(41, 43, 47)\n(101, 103, 107)\n(107, 109, 113)\n(191, 193, 197)\n(227, 229, 233)\n(311, 313, 317)\n(347, 349, 353)\n(461, 463, 467)\n(641, 643, 647)\n(821, 823, 827)\n(857, 859, 863)\n(881, 883, 887)\n(1091, 1093, 1097)\n(1277, 1279, 1283)\n(1301, 1303, 1307)\n(1427, 1429, 1433)\n(1481, 1483, 1487)\n(1487, 1489, 1493)\n(1607, 1609, 1613)\n(1871, 1873, 1877)\n(1997, 1999, 2003)\n(2081, 2083, 2087)\n(2237, 2239, 2243)\n(2267, 2269, 2273)\n(2657, 2659, 2663)\n(2687, 2689, 2693)\n(3251, 3253, 3257)\n(3461, 3463, 3467)\n(3527, 3529, 3533)\n(3671, 3673, 3677)\n(3917, 3919, 3923)\n(4001, 4003, 4007)\n(4127, 4129, 4133)\n(4517, 4519, 4523)\n(4637, 4639, 4643)\n(4787, 4789, 4793)\n(4931, 4933, 4937)\n(4967, 4969, 4973)\n(5231, 5233, 5237)\n(5477, 5479, 5483)\n(5501, 5503, 5507)\n(5651, 5653, 5657)\n(6197, 6199, 6203)\n(6827, 6829, 6833)\n(7877, 7879, 7883)\n(8087, 8089, 8093)\n(8231, 8233, 8237)\n(8291, 8293, 8297)\n(8537, 8539, 8543)\n(8861, 8863, 8867)\n(9431, 9433, 9437)\n(9461, 9463, 9467)\n(10331, 10333, 10337)\n(10427, 10429, 10433)\n(10457, 10459, 10463)\n(11171, 11173, 11177)\n(11777, 11779, 11783)\n(12107, 12109, 12113)\n(12917, 12919, 12923)\n(13001, 13003, 13007)\n(13691, 13693, 13697)\n(13757, 13759, 13763)\n(13877, 13879, 13883)\n(13901, 13903, 13907)\n(14081, 14083, 14087)\n(14321, 14323, 14327)\n(14627, 14629, 14633)\n(15641, 15643, 15647)\n(15731, 15733, 15737)\n(16061, 16063, 16067)\n(16067, 16069, 16073)\n(16187, 16189, 16193)\n(17027, 17029, 17033)\n(17387, 17389, 17393)\n(18041, 18043, 18047)\n(18251, 18253, 18257)\n(18911, 18913, 18917)\n(19421, 19423, 19427)\n(19427, 19429, 19433)\n(19991, 19993, 19997)\n(20477, 20479, 20483)\n(20747, 20749, 20753)\n(20897, 20899, 20903)\n(21011, 21013, 21017)\n(21017, 21019, 21023)\n(21317, 21319, 21323)\n(21377, 21379, 21383)\n(21557, 21559, 21563)\n(21611, 21613, 21617)\n(22271, 22273, 22277)\n(22277, 22279, 22283)\n(22637, 22639, 22643)\n(23057, 23059, 23063)\n(23291, 23293, 23297)\n(23561, 23563, 23567)\n(23627, 23629, 23633)\n(23741, 23743, 23747)\n(24107, 24109, 24113)\n(24917, 24919, 24923)\n(25031, 25033, 25037)\n(25301, 25303, 25307)\n(25577, 25579, 25583)\n(25997, 25999, 26003)\n(26261, 26263, 26267)\n(26681, 26683, 26687)\n(26711, 26713, 26717)\n(27737, 27739, 27743)\n(27941, 27943, 27947)\n(28277, 28279, 28283)\n(29021, 29023, 29027)\n(29567, 29569, 29573)\n(30491, 30493, 30497)\n(31247, 31249, 31253)\n(31391, 31393, 31397)\n(31511, 31513, 31517)\n(31541, 31543, 31547)\n(31721, 31723, 31727)\n(32057, 32059, 32063)\n(32297, 32299, 32303)\n(32321, 32323, 32327)\n(32531, 32533, 32537)\n(33347, 33349, 33353)\n(33617, 33619, 33623)\n(33767, 33769, 33773)\n(34211, 34213, 34217)\n(34757, 34759, 34763)\n(34841, 34843, 34847)\n(35531, 35533, 35537)\n(35591, 35593, 35597)\n(36011, 36013, 36017)\n(36467, 36469, 36473)\n(37307, 37309, 37313)\n(37991, 37993, 37997)\n(38327, 38329, 38333)\n(38447, 38449, 38453)\n(39041, 39043, 39047)\n(39227, 39229, 39233)\n(40427, 40429, 40433)\n(40847, 40849, 40853)\n(41177, 41179, 41183)\n(42017, 42019, 42023)\n(42221, 42223, 42227)\n(42461, 42463, 42467)\n(43397, 43399, 43403)\n(43607, 43609, 43613)\n(43781, 43783, 43787)\n(43787, 43789, 43793)\n(44201, 44203, 44207)\n(44267, 44269, 44273)\n(44531, 44533, 44537)\n(44771, 44773, 44777)\n(45821, 45823, 45827)\n(46181, 46183, 46187)\n(47711, 47713, 47717)\n(48407, 48409, 48413)\n(49031, 49033, 49037)\n(49937, 49939, 49943)'

avaliar 'q3' '1.1 -0.5' 'inseguro'
avaliar 'q3' '0.2 1' 'relativamente seguro'
avaliar 'q3' '0.2 3.6' 'troque de coordenada'
avaliar 'q3' '-1 -5' 'relativamente seguro'
avaliar 'q3' '-5 -0.6' 'seguro'
avaliar 'q3' '4.9 0.4' 'relativamente seguro'
avaliar 'q3' '4.6 -0.6' 'troque de coordenada'
avaliar 'q3' '-4.8 1' 'seguro'
avaliar 'q3' '0.4 0.7' 'seguro'
avaliar 'q3' '0.5 -0.4' 'relativamente seguro'
avaliar 'q3' '1.2 1.4' 'relativamente seguro'


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