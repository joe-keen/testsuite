package require Itcl
package require Iwidgets

source $env(TESTSUITE_DIR)/ResultsWidget.tcl
source $env(TESTSUITE_DIR)/OutputWidget.tcl
source $env(TESTSUITE_DIR)/OptionsWidget.tcl
source $env(TESTSUITE_DIR)/TestSuiteGui.tcl
source $env(TESTSUITE_DIR)/TestRunner.tcl

set xSize 588
set ySize 420
set TestFiles ""

if {[info exists env(TS_XSIZE)]} {set xSize $env(TS_XSIZE)}
if {[info exists env(TS_YSIZE)]} {set ySize $env(TS_YSIZE)}

set GUI [TestSuiteGui \#auto]
set Runner [TestRunner \#auto [lrange $argv 0 end]]
$GUI Setup

wm title . [file tail [exec pwd]]
wm geometry . ${xSize}x${ySize}
