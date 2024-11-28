## Planeamento da US-AC06

>Desenvolva uma função em _assembly_ que dada uma string (input) com a informação gerada pelo **ColetorDeDados** e um _token_ extraia a informaçãao (campo value da string) referente a esse _token_ (output).

### 1.1. Análise
>Nesta user story é necessário criar uma função que, dadas duas strings, o input e um token (referência à informação a ser extraída), os dados referentes ao token sejam extraídos e alocados no output.
> A função deve retornar 1 se conseguir extrair a informação, caso contrário devolve 0.


### 1.2. Clarificações

**Feitas pelo cliente:**

> **Questão:** Para tokens como **type** ou **unit**, cujo valor é uma string, como devemos tratar o retorno, visto que recebe um apontador do tipo inteiro? Deve-se retornar um output igual a 0?
>
> **Resposta:** Neste caso não é possível extrair. Só será possível, para sensor id, value e time.

### 1.3. Design

**Criação de labels:**

* _extract_token_ - inicia certos registos.
* _loop_ - itera pelos caracteres da string _input_ - caso haja correspondência com o caracter do _token_ entra na _label_ seguinte.
* _checkToken_ - itera pela string desde o momento em que existe correspondência com o caracter do _token_, se não sair do _loop_ até o _token_ acabar, então encontrou-se o token na string, os caracteres a seguir referem-se ao seu valor.
* _getTokenInfo_ - inicia certos registos para a extração da informação.
* _retrieveValueLoop_ - itera pela string _input_ até encontrar o caracter # ou um carater que não seja um número.

**Labels finais:**
* _end_ - verifica se o valor do registo de retorno é 0, se for então não foi possivel extrair informaçao. Caso contrário, altera-se o valor de retorno para 1.
* _done_ - retorna a execução do programa para a função _caller_, neste caso o _main_.

**Outras Labels:**
* _notToken_ - em _checkToken_, encontra-se um par de caracteres que não são iguais, portanto a secção da string _input_ a ser avaliada não corresponde ao _token_.
 
**Labels de Incremento:**
* increments -  incrementa o índice do caracter da string _input_.
* _valueIncrements_ - incrementa o índice do caracter da string _input_ referente ao valor a ser extraido.

> Para auxiliar na impressão dos resultados obtidos, criou-se uma outra função, desenvolvida em C, chamada printRetrievedInfo.