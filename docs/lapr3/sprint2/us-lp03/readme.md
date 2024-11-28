## Planeamento da US-LP03

Como Product Owner, pretendo que seja desenvolvida uma funcionalidade que permita de forma automática consuma o plano de rega gerado pelo
simulador do controlador desenvolvido na USLP02 e que de forma escalonada após
a conclusão da rega em cada sector registe essa operação no caderno de campo.




### 1.1. Análise
    
Nesta user story é necessário fazer uma funcionalidade que irá, através do ficheiro .csv gerado na US-LP02, registar regas no Caderno de Campo. 



### 1.2. Clarificações

**Feitas pelo cliente:** 

> **Questão:** Quando o enunciado se refere a "e que de forma escalonada após a conclusão da rega em cada sector registe essa operação"  ,  significa que a operação apenas tem que ser registada comparando a data e hora atual do computador com a do ficheiro que o plano de rega gerou?
> 
> **Resposta:** Significa que quando termina a rega de uma sector (de acordo com o Plano de Rega criado no LP2) deve ser criada uma entrada no Caderno de Campo da instalação agrícola. A hora actual pode naturalmente ser fornecida pelo computador.

> **Questão:** Qual deve ser o formato do caderno de campo? Também é um ficheiro .csv?
>
> **Resposta:** O formato do Caderno de Campo é definido pela equipa e deve estar modelado/capturado pelo modelo conceptual e pelo lógico, os dados deste caderno são guardados na Base de Dados.

> **Questão:** O conceito de Sistemas Distribuidos, no contexto desta US, assumimos que é especificamente referente à convergência do registo da operação no caderno de campo nos processos. Está correta a assunção?
>
> **Resposta:** Existe uma gralha na escrita do texto, deveria ser:
"No desenvolvimento desta US serao intencionalmente ignorados aspectos estudados em Sistemas Distribuidos (como por exemplo tolerancia a falhas)."
Isto significa que o simulador que está a ser desenvolvido, por exemplo, assume que os sistemas que lhe fornecem dados vão funcionar adequadamente, sem falhas. O que obviamente é uma simplificação do caso real mas pedagógicamente adequada ao ano curricular em que decorre LAPR3.

> **Questão:** Como é que, a partir do ficheiro gerado na US-LP02, sabemos a quantidade de água utilizada na rega?
> 
> **Resposta:** As regas podem ser registadas em minutos e en«m função do tipo de rega instalado no setor e respetivo débito poderiamos calcular a quantidade de água. No entanto, não entendo que o precisem de fazer, os minutos de rega são suficientes.

> **Questão:** No meu ponto de vista o que é solicitado da sua parte é o registo das operações de rega no caderno de campo conforme vão sendo realizadas. No entanto não percebi como é que o cliente as quer visualizar. É suposto ir armazenando num ficheiro conforme vou inserindo na base de dados? É suposto solicitar à base de dados através de uma query e guardar num ficheiro?
> 
> **Resposta:** Em termos de demo pode ser interessante escrever uma mensagem no ecra mas num contexto de utilização "real" poderiamos fazer um query à BD para obter essa informação (não é necessário).


### 1.3. Design

> NOTA : esta funcionalidade sofreu várias alterações de design. No fim chegou-se ao seguinte plano:

Criação das classes:
* RegistoRegaUI
* RegistoRegaController

Classes utilizadas já existentes:
* ImportarFicheiro
* ExcecaoFicheiro
* Rega
* ControladorRega

#### Descrição

Para esta US iremos adicionar a implementação de 'scheduled tasks' à implementação usada para o import do plano de rega. Desta forma, após o ficheiro do plano de rega for carregado,
o programa vai automaticamente fazer o schedule do registo da operação de rega.
Este registo, apenas vai ocorrer quando a rega chegar ao fim (quando o tempo real igualar a hora final da rega).
Como os dados de inserção provém do sistema, não é necessário verificar os dados. No entanto, a função sql irá conter uma verificação para que não se insira regas repetidas.
A implementação desta funcionalidade foca-se principalmente nas classes ImportFicheiro e SistemaDeRega. Na 
classe SistemaDeRega é feita o agendamento dos registos. No entanto, a classe ControladorRega de rega é a responsável por conetar com a base de dados e registar as regas.

##### Mini gráfico esclarecedor 

![diagrama-esclarecedor.png](diagrama-esclarecedor.png)

### Recursos

[Informação acerca Schedule Task](http://www.java2s.com/example/java-book/task-scheduling.html)