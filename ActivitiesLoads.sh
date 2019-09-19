source ./JMeterLoadTemplate.sh

#############################################################################
################################### TESTS ###################################
#############################################################################

##### ARGS: testPlanName logFileName numOfThreads rampUpPeriod loopCount ######

run_jmeter_test "JMeterLoadTemplateActivities" "activities_3_parallel" 1 1 1;
# run_jmeter_test "JMeterLoadTemplateActivities" "activities-5-parallel" 5 1 1;
# run_jmeter_test "JMeterLoadTemplateActivities" "activities-10-parallel" 5 1 3;
# and so on ...
