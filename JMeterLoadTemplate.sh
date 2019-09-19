###############################################################################
############################### JMETER TEMPLATE ###############################
###############################################################################

jmeterHomeDir=apache-jmeter-5.1.1

#cria diretorios na primeira execucao
mkdir testDashboards testLogs;
echo "\n\n";

#mock or app
environment="app"
mockHostAddress=

if test $environment = "app"
then
    myHost="fakerestapi.azurewebsites.net/api/";
elif test $environment = "mock"
then
    myHost=$mockHostAddress;
fi

run_jmeter_test(){
    local testPlanNameLocal=$1;
    local logFileNameLocal=$2;
    local numOfThreadsLocal=$3;
    local rampUpPeriodLocal=$4;
    local loopCountLocal=$5;

    echo "Teste iniciado:";
    echo "Executando:     $jmeterHomeDir/bin/jmeter -n -t testPlans/"${testPlanNameLocal}".jmx -L jmeter=INFO -JnumOfThreads=$numOfThreadsLocal -JrampUpPeriod=$rampUpPeriodLocal -JloopCount=$loopCountLocal -Jhost=$myHost -l testLogs/"${logFileNameLocal}".jtl \n";
    $jmeterHomeDir/bin/jmeter -n -t testPlans/"${testPlanNameLocal}".jmx -L jmeter=INFO -JnumOfThreads=$numOfThreadsLocal -JrampUpPeriod=$rampUpPeriodLocal -JloopCount=$loopCountLocal -Jhost=$myHost -l testLogs/"${logFileNameLocal}".jtl ;
    echo "Teste finalizado. Gerando relatório HTML: \n $jmeterHomeDir/bin/jmeter -d $jmeterHomeDir -g testLogs/"${logFileNameLocal}".jtl -o testDashboards/"${logFileNameLocal}" -f \n"
    $jmeterHomeDir/bin/jmeter -d $jmeterHomeDir -g testLogs/"${logFileNameLocal}".jtl -o testDashboards/"${logFileNameLocal}" -f;
}