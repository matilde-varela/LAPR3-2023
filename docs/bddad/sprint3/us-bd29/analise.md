## Planeamento da US-BD29

>Como Product Owner, pretendo que seja atualizado o modelo relacional (nível lógico e físico) à luz dos novos requisitos e user stories.


### 1.1. Análise
>Nesta user story é necessário atualizar as informações existentes no modelo relacional, lógico e físico, previamente criados para a USBD02 e USBD03 respetivamente.


### 1.2. Planeamento

> Após o momento de avaliação realizado pelo grupo, no âmbito da disciplina de Base de Dados e de feedback dado pelo nosso professor, o grupo decidiu realizar algumas alterações.

#### Modelo Relacional Lógico

* **Remoção de ID's**
> Verificamos que em tabelas como Parcela e Edificio, a existência de atributos únicos, tal como nomeParcela e nomeEdificio, respetivamente.
>
> Assim, optamos pela remoção das primary keys existentes em cada tabela (idParcela e idEdificio), recorrendo a chaves primarias naturais. 

* **CalendarioFenologico**
> Na tabela CalendarioFenologico existiam os atributos: sementeira, poda, colheita e floracao. Estes eram representados pelos intervalos de tempo em que aconteciam.
> 
> Optamos por remover esses atributos e criar novas tabelas, sendo elas TipoFenologia, DataFenologia e DataFenologiaCalendarioFenologico.

* **Verificações de atributos e exceções**
> Costumização das exceções relativamente às condicionantes dos vários atributos das tabelas da base de dados.
 
* **Verificações para casas decimais**
> Colocação de casas decimais em alguns atributos, como, por exemplo, ph em FatorProducao, area em Parcela, e quantidade em Operacao, CulturaInstalada e ConstituicaoQuimica.

* **Criação de novas tabelas**
> Foram criadas as tabelas Setor, SetorCulturaInstalada, Colheita e Rega.

* **Remoção de Tabelas**
> Optamos pela remoção da tabela SetorCulturaInstalada, visto não ter informação relevante.

* **Inclusão de Estados**
> Inclusão dos estados fenológicos que uma colheita pode ter.
> Inclusão dos estados que uma operacao pode ter.

* **Desdobramento de Planta**
> Tendo em conta a dependência da permanência da planta apenas com o nome comum desta, criou-se uma nova tabela para representar esta relação.

* **Plantas Permanentes** 
> Com a fertirrega é necessário manter registo da distância das filas das plantas permanentes e o seu espaçamento, por isso foi criada a tabela PlantacaoPermanente.

* **Inclusão da Fertirrega**
> Conjugação de uma operação de rega com uma ou mais aplicações de fatores de produção.
> Adição do Catálogo das misturas de fertirrega.

* **Alterações em Colheita**
> Numa operação de colheita podem-se obter vários produtos. Posto isto, a tabela colheita foi substituida por ProdutosColhidos.

* **Log**
> Criou-se uma tabela Log, que regista as operacoes e as suas alterações.


#### Modelo Relacional Físico

> Continua a ser gerado automaticamente, através das funcionalidades do _Visual Paradigm_.







