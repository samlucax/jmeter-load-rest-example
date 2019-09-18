# Projeto Exemplo - JMeter + Template w/ shell script

Exemplo para execução de testes de carga em uma API REST utilizando parametrização com jmeterproperties e um template em shell script para facilitar a criação de cenários para diferentes test plans e variação de cargas nos testes.

## Ferramentas utilizadas:
- [Apache JMeter (v5.1.1)](https://jmeter.apache.org/ "Apache JMeter (v5.1.1)")
- [FakeRestAPI  (API Fake)](http://fakerestapi.azurewebsites.net/swagger/ui/index#/ "API Fake")

O Apache JMeter é uma ferramenta para configuração e execução de testes de carga. Neste contexto, foi utilizado para mapear os cenários e para efetuar as cargas nos serviços.

A FakeRestAPI é uma API Fake, disponibilizada para estudo de ferramentas. Neste contexto, foi a aplicação utilizada nos testes.

***Importante***: *Por se tratar de uma aplicação de testes, as cargas efetuadas foram extremamente leves (máximo 5 usuários). Caso tenha interesse em realizar cargas mais ~~legais~~ **pesadas**, sugiro o uso de uma API própria ou o uso de algum mock, para evitar indisponibilidade ou bloqueio na aplicação.*

## Estrutura de pastas
```
.
├── ActivitiesLoads.sh
├── JMeterLoadTemplate.sh
├── jmeter.log
├── README.md
├── apache-jmeter-5.1.1
├── testDashboards
├── testLogs
└── testPlans
    └── JMeterLoadTemplateActivities.jmx
	├── JMeterLoadTemplate.jmx
```

O diretório *apache-jmeter-5.1.1* possui os binários e configurações da ferramenta JMeter. 
> ***IMPORTANTE*:** *devido ao tamanho do binário do JMeter (+100MB !), este diretório não será versionado.** Faça download diretamente no site e adicione neste projeto seguindo esta mesma estrutura de pastas.** Após baixar e adicionar no projeto, atualize o valor da variável `jmeterHomeDir` no arquivo `JMeterLoadTemplate`.

O diretório *testDashboards* possui os relatórios em HTML gerados após a execução do teste. 

O diretório *testLogs* possui os logs na extensão .jtl gerados após a execução do teste. Por convenção, os relatórios e logs possuem o mesmo nome.

O diretório *testPlans* possui os planos de testes criados no JMeter. Isso facilita a criação de planos de testes específicos sem perder a organização do projeto.

O arquivo *JMeterLoadTemplate.sh* é o arquivo responsável por abstrair o gerenciamento do plano de testes, geração de logs, relatórios e ambiente de execução. É responsável também pela função parametrizada que executa os testes.

O arquivo *ActivitiesLoads.sh* possui os cenários de testes para a execução das cargas. Utilizando a função do template, permite criar cenários de forma mais simples.

O arquivo *jmeter.log* é gerado automaticamente durante a execução do Apache JMeter.

## Recursos do JMeter utilizados no projeto
- [JMeter Test Plans](https://jmeter.apache.org/usermanual/build-test-plan.html "JMeter Test Plans")
- [HTTP Request Defaults](https://jmeter.apache.org/usermanual/component_reference.html#HTTP_Request_Defaults "HTTP Request Defaults")
- [HTTP Header Manager](https://jmeter.apache.org/usermanual/component_reference.html#HTTP_Header_Manager "HTTP Header Manager")
- [User Defined Variables](https://jmeter.apache.org/usermanual/component_reference.html#User_Defined_Variables "User Defined Variables")
- [Thread Groups](https://jmeter.apache.org/usermanual/test_plan.html#thread_group "Thread Groups")
- [HTTP Request](https://jmeter.apache.org/usermanual/component_reference.html#HTTP_Request "HTTP Request")
- [View Results Tree](https://jmeter.apache.org/usermanual/component_reference.html#View_Results_Tree "View Results Tree")
- [Aggregate Graph](https://jmeter.apache.org/usermanual/component_reference.html#Aggregate_Graph "Aggregate Graph")
- [JMeter - Non GUI Mode](https://jmeter.apache.org/usermanual/get-started.html#non_gui "JMeter - Non GUI Mode")
- [JMeter - Dashboard](https://jmeter.apache.org/usermanual/generating-dashboard.html "JMeter - Dashboard")
- [JMeter - Best practices](https://jmeter.apache.org/usermanual/best-practices.html "JMeter - Best practices")

## Test Plan Template (JMeterLoadTemplate.jmx)
Para a criação do cenário e execução da carga, foi criado o arquivo JMeterLoadTemplate.jmx. Este arquivo possui exemplos para requisições GET, POST, PUT & DELETE. Quando executado, recebe parâmetros como propriedades e atualiza o valor das seguintes variáveis:
- HOST
- NUM_OF_THREADS
- RAMP_UP_PERIOD
- LOOP_COUNT

**Importante**: os arquivos JMeter (.jmx) devem ser adicionados ao diretório `testPlans`.


## Runner Template (JMeterLoadTemplate.sh)
Para facilitar a criação de testes para diferentes TestPlans e variação de cargas entre os testes, foi criado o arquivo JMeterLoadTemplate.sh.

Este arquivo possui uma função shell `run_jmeter_test`, que recebe como parâmetros:

- **testPlanNameLocal** - nome do Test Plan
- **logFileNameLocal** - nome do arquivo de logs
- **numOfThreadsLocal** - valor da config Number of Threads (users)
- **rampUpPeriodLocal** - valor da config Ramp-Up Period (seconds)
- **loopCountLocal** - valor da config Loop Count

Com base nos parâmetros passados na chamada da função, são executadas duas etapas: *execução do teste e geração do relatório.*

### Execução do teste de carga e geração de logs

Nesta etapa, é executado o seguinte comando:

> $jmeterHomeDir/bin/jmeter -n -t testPlans/"${testPlanNameLocal}".jmx -L jmeter=INFO -JnumOfThreads=$numOfThreadsLocal -JrampUpPeriod=$rampUpPeriodLocal -JloopCount=$loopCountLocal -Jhost=$myHost -l testLogs/"${logFileNameLocal}".jtl ; ;

Após finalizada, esta etapa deve gerar e armazenar o resultado dos testes.

### Geração do relatório HTML, baseado nos logs

Nesta etapa, é executado o seguinte comando:

> $jmeterHomeDir/bin/jmeter -d $jmeterHomeDir -g testLogs/"${logFileNameLocal}".jtl -o testDashboards/"${logFileNameLocal}" -f;

Após finalizada, esta etapa deve gerar um relatório HTML.

------------
Este arquivo possui também um controle de execução por ambiente, sendo **app** e **mock** como exemplos.

## Tests (ActivitiesLoads.sh)
Utilizando a função e template criados previamente, foram criados testes em um arquivo separado, seguindo a seguinte sintaxe:

> run_jmeter_test "nomeDoTestPlan" "nomeParaSalvarOsLogs" qtdThreads rampUpCount loopCount;

Com isso, para criar um *novo* teste basta seguir a sintaxe acima. Veja um exemplo:

> run_jmeter_test "JMeterLoadTemplateActivities" "activities_5_parallel" 5 1 2;

Neste caso:
-  `run_jmeter_test` é o nome da função criada para executar os testes
- `JMeterLoadTemplateActivities` - é o nome do nosso JMeter Test Plan
- `activities_5_parallel` - é o nome dado aos arquivos de logs e para o relatório HTML
- `5` - é a quantidade de threads que será executada
- `1` - é o tempo de "ramp up" até a quantidade de threads que definimos
- `2` - é o número de vezes que o teste será repetido


***Importante***: *ao criar novos arquivos com testes, deve ser feita a "importação" do arquivo template, para utilizar suas funções. Para isso, use o comando: `source ArquivoTemplate.sh` no topo do arquivo.*



## Logs & Relatórios (JMeter Test Dashboards)
Os logs gerados possuem o formato .jtl (JMeter Text Files), e possuem as saídas de uma execução de testes. Estes arquivos podem ser analisados em sua forma "bruta" ou utilizados para a geração de relatórios. Neste caso, as informações deste arquivo são utilizadas para a geração de um relatório em HTML, utilizando o Apache JMeter Dashboard, que permite uma visualização mais "amigável" dos resultados.



## Dicas

*- Recomenda-se o uso, sempre que possível, da versão mais atualizada do JMeter. Ao construir seus testes a partir deste projeto, avalie se não há versão mais recente da ferramenta.*
*- Em ambientes Windows, a execução deve funcionar normalmente utilizando o PowerShell, Cmder, ou similares.*