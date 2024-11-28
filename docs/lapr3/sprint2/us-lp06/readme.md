## Planeamento da US-LP06

Como Product Owner, pretendo que seja desenvolvida uma funcionalidade que permita a evocação das USBD13. Não é pretendido
o desenvolvimento de uma interface gráfico para a aplicação ”Farm Coordinator”, esta interface pode ser em modo texto.


### 1.1. Análise
    
Nesta user story é necessário fazer uma funcionalidade que irá tratar do registo de operações de monda na base de dados. Devemos conectar o programa com a função desenvolvida em sql na base de dados. 

**Critérios Aceitação BD13:**
* Conforme aplicável, a parcela, operação, planta, fruto, fator de produção, etc., têm de existir.
* Não é possível registar operação colheita no futuro (não usar SYSDATE numa função, que ela deixa de ser testável!).
* Não é possível registar operação colheita que envolva plantas permanentes ou temporárias que não existem na parcela.


### 1.2. Clarificações

**Feitas pelo cliente:** 

> **Questão:** 
> 
> **Resposta:** 


### 1.3. Design

Criação das classes:
* RegistarOperacaoColheitaUI
* RegistarOperacaoColheitaController
* OperacaoRepository

#### Descrição

>Tendo em conta os critérios de aceitação da USBD13, e de forma a limitarmos os possíveis erros, as opções de escolha ao utilizador são limitadas.
>Inicialmente, irá ser mostrado ao user as parcelas existentes, esta lista obtém-se da base de dados assegurando que o utilizador irá selecionar uma parcela válida. Posteriormente, as culturas apresentadas para escolha correspondem às culturas instaladas na parcela escolhida.
>Por fim, é pedida a quantidade, esta não pode ser negativa. Estas validações são feitas na função sql da base de dados.
>
>Assim sendo, serão implementados testes que assegurem que a operação cumpre com todos os requisitos, estes serão implementados em sql (blocos anónimos).


