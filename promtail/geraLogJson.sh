#!/bin/bash

cpf(){
	# limpa todos os caracteres que não for número.
	cpf=$(echo $1 | tr -d -c 0123456789)

	# se não for digitado o parâmetro do cpf
	if [ -z $cpf ]; then

	# gera 3 sequência de 3 caracters, números randômicos.
		for i in {1..3};
			do
				a+=$(($RANDOM%9));
				b+=$(($RANDOM%9));
				c+=$(($RANDOM%9));
			done
		
		
	# estabelece o valor temporário do cpf, só pra poder gerar os digitos verificadores.	
		cpf="$a$b$c"

	# array pra multiplicar com o 9(do 10 ao 2)primeiros caracteres do CPF, respectivamente.
	mulUm=(10 9 8 7 6 5 4 3 2)

	# um loop pra multiplicar caracteres e numeros.Utilizamos nove pois são 9 casas do CPF
		for digito in {1..9}
			do
					# gera a soma dos números posteriormente multiplicados
					let DigUm+=$(($(echo $cpf | cut -c$digito) * $(echo ${mulUm[$(($digito-1))]})))
							 
			done
		
	# divide por 11
	restUm=$(($DigUm%11))

	# gera o primeiro digito subtraindo 11 menos o resto da divisão
	primeiroDig=$((11-$restUm))

	# caso o resto da divisão seja menor que 2
	[ $restUm -lt 2 ] && primeiroDig=0	

	# atualizamos o valor do CPF já com um digito descoberto
	cpf="$a$b$c$primeiroDig"

	# agora um novo array pra multiplicar com o 10(do 11 ao 2) primeiros caracteres do CPF, respectivamente.
	mulDois=(11 10 9 8 7 6 5 4 3 2)

		for digitonew in {1..10}
			do
				
					let DigDois+=$(($(echo $cpf | cut -c$digitonew) * $(echo ${mulDois[$(($digitonew-1))]})))				 
			done


	# também divide por 11
	restDois=$(($DigDois%11)) 

	# gera o segundo digito subtraindo 11 menos o resto da divisão
	segundoDig=$((11-$restDois))

	# caso o resto da divisão seja menor que 2
	[ $restDois -lt 2 ] && segundoDig=0

    

	# exibe o CPF gerado e formatado.
	echo -e "\033[1;35mO CPF gerado é:\033[1;32m $a.$b.$c-$primeiroDig$segundoDig\033[0m"

		# FINALIZA O SCRIPT
		#exit 0;
	fi
    # Escrever log
    mensagem="CPF aleatório gerado."
    escrever_log "$a.$b.$c-$primeiroDig$segundoDig" "$mensagem"
    exit 0;

	##############################################################################
	##############################################################################
	# -- SE DIGITAR O PARÂMETRO, MAS A QUANTIDADE DE NÚMEROS SEJA MENOR QUE 11 -- 
	##############################################################################
	##############################################################################

	# verificamos a quantidade de caracteres
	qtde=$(echo $cpf | wc -c)

	# como o wc aumenta mais 1, então precisamos subtrair para chegar a quantidade exata.
	total=$(echo $(($qtde-1)))

	# se for menos de 11 caracteres
	if [ $total != 11 ]; then

		# informa o erro e mostra quantos caracteres têm.
		echo -e "\033[1;31mQuantidade de números diferente de \033[7;31m11\033[0m: Total:\033[1;35m $total\033[0m";
	
		# finaliza o script
		exit 0;
	else

	# se passar, continua...daqui pra frente os comentários serão o mesmo da geração do CPF, 
	# mas nesse caso pra validar, pois só os dois últimos é que definem o CPF

	##############################################################################
	##############################################################################
	########## -- SE FOR PRA VALIDAR CPF -- ########################################
	##############################################################################
	##############################################################################

	mulUm=(10 9 8 7 6 5 4 3 2)

		for digito in {1..9}
			do
				
					let DigUm+=$(($(echo $cpf | cut -c$digito) * $(echo ${mulUm[$(($digito-1))]})))				 
			done
		


	mulDois=(11 10 9 8 7 6 5 4 3 2)

		for digitonew in {1..10}
			do
				
					let DigDois+=$(($(echo $cpf | cut -c$digitonew) * $(echo ${mulDois[$(($digitonew-1))]})))				 
			done


	restUm=$(($DigUm%11))
	[ $restUm -lt 2 ] && primeiroDig=0	
	primeiroDig=$((11-$restUm))


	restDois=$(($DigDois%11))
	[ $restDois -lt 2 ] && segundoDig=0	
	segundoDig=$((11-$restDois))

		if [ $(echo $cpf | cut -c10) == $primeiroDig -a  $(echo $cpf | cut -c11) == $segundoDig ]; then

			# se o CPF for válido.
			echo -e "\033[1;32mCPF Válido!\033[0m"
		else

			# informa quais seriam os dois últimos se o CPF estiver incorreto.
			echo -e "\033[1;31mCPF Inválido.\nOs dois Últimos números deveriam ser:\033[1;32m $primeiroDig$segundoDig\033[0m"
		fi
	
	fi
}

escrever_log() {
    local cpf=$1
    local mensagem=$2
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Criar o log em formato JSON
    local log_json=$(jq -n --arg timestamp "$timestamp" --arg cpf "$cpf" --arg mensagem "$mensagem" \
                      '{timestamp: $timestamp, cpf: $cpf, mensagem: $mensagem}')
                      
    # Adicionar o log ao arquivo log.json
    echo "$log_json" >> log.log
}

cpf $1