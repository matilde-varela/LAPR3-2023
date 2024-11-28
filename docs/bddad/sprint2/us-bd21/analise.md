## Planeamento da US-BD23

>Como Product Owner, pretendo que seja atualizado o modelo relacional (nível lógico e físico) à luz dos novos requisitos e user stories.


### 1.1. Análise
>Nesta user story é necessário atualizar as informações existentes no modelo relacional, lógico e físico, previamente criados para a US BD02 e BD03 respetivamente.


### 1.2. Planeamento

> Após o momento de avaliação realizado pelo grupo, no âmbito da disciplina de Base de Dados e de feedback dado pelo nosso professor, o grupo decidiu realizar algumas alterações.

#### Modelo Relacional Lógico

* **Remoção de ID's**
> Verificamos que em tabelas como Parcela e Edificio, a existência de atributos únicos, tal como nomeParcela e nomeEdificio, respetivamente. 
> 
>Assim, optamos pela remoção das primary keys existentes em cada tabela(idParcela e idEdificio), passando aqueles atributos a ser as PK. 

* **CalendarioFenologico**
> Na tabela CalendarioFenologico estavam presentes os atributos sementeira, poda, colheita e floracao, sendo cada um representado pelo intervalo de tempo em que acontecia.
> 
> Optamos por remover esses atributos e criar novas tabelas, sendo elas TipoFenologia, DataFenologia e DataFenologiaCalendarioFenologico.

* **FichaTecnica**
> Optamos pela remoção da tabela FichaTecnica, visto não ter informação relevante.

* **Verificações de atributos**
> Criação de checks para datas(a dataFinal não pode ser primeiro que a dataInicial) na tabela CulturaInstalada e para as percentagens na tabela ConstituicaoQuimica.
 
* **Verificações para casas decimais**
> Colocação de casas decimais em alguns atributos, como por exemplo ph em FatorProducao e quantidade em Operacao, CulturaInstalada e ConstituicaoQuimica e area em Parcela.

* **Criação de novas tabelas**
> Foram criadas as tabelas Setor, SetorCulturaInstalada, Colheita e Rega


#### Modelo Relacional Físico

> Continua a ser gerado automaticamente, através das funcionalidades do Visual Paradigm.







