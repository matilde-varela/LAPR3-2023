## Planeamento da US-LP03

Como Product Owner, pretendo que seja desenvolvida uma funcionalidade que permita a evocação das USBD12. Não é pretendido
o desenvolvimento de uma interface gráfico para a aplicação ”Farm Coordinator”, esta interface pode ser em modo texto.


### 1.1. Análise
    
Nesta user story é necessário fazer uma funcionalidade que irá tratar do registo de operações de monda na base de dados. Devemos conectar o programa com a função desenvolvida em sql na base de dados. 

**Critérios Aceitação BD12:**
* Conforme aplicável, a parcela, operação, planta, fruto, fator de produção, etc., têm de existir.
* Não é possível registar operação monda no futuro (não usar SYSDATE numa função, que ela deixa de ser testável!).
* Não é possível registar operação monda que envolva área superior à de uma dada parcela.
* Não é possível registar operação monda que envolva um número de plantas permanentes superior à existente na parcela.
* Não é possível registar operação monda que envolva plantas permanentes ou temporárias que não existem na parcela.


### 1.3. Design

Criação das classes:
* RegistarOperacaoMondaUI
* RegistarOperacaoMondaController
* OperacaoRepository

#### Descrição

Tendo em conta os critérios de aceitação da USBD12, e de forma a limitarmos os possíveis erros, as opções de escolha ao user são limitadas.
Inicialmente, irá ser mostrado ao user as parcelas existentes, esta lista obtém-se da base de dados assegurando que o user irá selecionar uma parcela válida. Posteriormente, as culturas apresentadas para escolha
correspondem às culturas instaladas na parcela escolhida.
Por fim, é pedida a quantidade, esta não pode ser negativa e não pode ser
superior ao tamanho da cultura instalada. Estas validações são feitas na função sql da basse de dados.

Assim sendo, serão implementados testes que assegurem que a operação cumpre com todos os requisitos, estes serão implementados em sql (blocos anónimos).


