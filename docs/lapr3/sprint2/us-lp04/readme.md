## Planeamento da US-LP04

Como Product Owner, pretendo que seja desenvolvida uma funcionalidade que permita registar na base de dados uma operação
de semeadura a partir da aplicação "Farm Coordinator", através da invocação da função desenvolvida na USBD11.
Aa interface pode ser em modo texto.

### 1.1. Análise

Nesta user story é necessário fazer uma funcionalidade que irá pedir ao utilizador vários dados necessários para o
registo de uma operação de cultura - tipo "Semeadura". Além disso, serão necessárias algumas validações ao nível da
área, quantidade a semear e registos já existentes na base de dados com a mesma informação.

#### **Critérios Aceitação BD11:**

* Conforme aplicável, a parcela, operação, planta, fruto, fator de produção, etc., têm de existir.
* Não é possível registar operação semeadura no futuro (não usar SYSDATE numa função, que ela deixa de ser testável!).
* Não é possível registar operação semeadura que envolva área superior à de uma dada parcela.
* Não é possível registar operação semeadura que envolva um número de plantas superior à área disponível (sem estar
  ocupada) na parcela.

### 1.2. Clarificações

**Feitas pelo cliente:**

> **Questão:** O que se entende por operações realizadas sobre uma parcela? Essas operações incluem sempre o uso de
> fatores de produção?
>
> **Resposta:** Uma operação realizada numa parcela é uma ação cultural (sobre uma cultura), pode ser semeadura ou
> plantação, poda, monda, desfolha, aplicação de um fator de produção, corte de infestantes, rega, colheita,
> pastoreio (entre outros). No fundo, todas as atividades que visam fornecer as melhores condições às plantas e solo
> para uma produção plena. Nem todas as ações implicam fatores de produção, como, por exemplo, poda ou colheita.

> **Questão:** A nova atualização do documento do projeto dá a entender que cultura e planta são a mesma coisa (no ponto
> de estado fenológico, secção 2.2).
>
> **Resposta:** A cultura da vinha tem plantas que são as videiras, por isso, o ciclo fenológico da videira determina o
> ciclo da vinha.

> **Questão:** Quando é registada uma operação de semeadura devem também ser registadas informações relativamente à
> colheita prevista?
>
> **Resposta:** Creio que não. Porque tipicamente os valores previstos (teóricos) estão associados a uma cultura e
> valores padrão (ha, árvore, etc). A semeadura será realizada numa parcela/cultura.
> De qualquer forma após alguns ciclos produtivos são prováveis obter previsões mais precisas com base nas produções
> anteriores da quinta do que nos valores indicados na literatura (que estão sempre dependentes da região, solos, clima,
> práticas culturais).

> **Questão:** é correto assumir que semeadura está relacionado com culturas temporárias e plantação com permanentes ou
> podemos ter uma mistura de ambos?
>
> **Resposta:** Semear e plantar só têm a ver com reprodução sexuada (por semente) ou assexuada da espécie vegetal (por
> de estaca ou parte do fruto/tuberculo).
> Por exemplo, a batata (temporária) é tipicamente plantada. Uma árvore como a oliveira que pode viver milhares de anos
> pode ser propagada por semente.

### 1.3. Design

> NOTA: esta funcionalidade sofreu várias alterações de design. No fim chegou-se ao seguinte plano:

#### Criação das classes:

* RegistarOperacaoSemeaduraUI
* RegistarOperacaoSemeaduraController
* OperacaoRepository
* FieldsRepository
* CultureRepository
* Repositories
* UnitsRepository
* DatabaseConnection
* Operacao
* OperacaoCultura

#### Classes utilizadas já existentes:

* Utils
* ExcecaoData

#### Descrição

Para atender aos critérios de aceitação da USBD11, e agilizar o fluxo de uso da funcionalidade, as opções concedidas ao
utilizador são limitadas.

Quando a funcionalidade de registar uma operacao de semeadura é escolhida, uma lista com as parcelas da exploração é
mostrada. Desta forma garante-se que a escolha da parcela para a operação será sempre válida. O mesmo ocorre com a lista
de todas as culturas da base de dados disponíveis para selecionar. A partir da escolha de cultura obtém-se o nome comum
da planta, a variedade e com a permanência.
Caso a permanência seja "Permanente" então o tipo de unidade da cultura é definida como "un", caso contrário dá-se a
escolha de
unidade, entre "ha" e "m2".

O input do utilizador termina com a quantidade de cultura (área correspondente à operação), a da operação (referente às
sementes a usar - em kg), e a data da operação.

A quantidade não pode ser negativa e nem superior ao tamanho da cultura instalada. Estas validações são feitas na função
sql da basse de dados.

Procede-se então ao registo da operação de semeadura.

Assim sendo, serão implementados testes que assegurem que a operação cumpre com todos os requisitos, estes serão
implementados em sql (blocos anónimos).