#!/bin/sh
# the next line restarts using wish \
    exec tclsh "$0" ${1+"$@"}

source $env(TESTSUITE_DIR)/TclTestHarness.tcl

if {[catch {source [lindex $argv 0]} error]} {
    puts "<fail>Error loading [lindex $argv 0]: $error"
    puts $::errorInfo
}

regsub ".*?test_" [lindex $argv 0] {} TestCase
regsub "\.tcl" $TestCase {} TestCase
puts "<testcase> $TestCase"

if {[info proc test_*] == {}} {
    assert_warn "No tests defined"
}

foreach TestProc [info proc test_*] {
    regsub "test_" $TestProc {} TestBlock
    puts "<testblock>$TestBlock"
    
    set TestInterp [interp create $TestBlock]
    $TestInterp eval source $::env(TESTSUITE_DIR)/TclTestHarness.tcl
    if {[catch {$TestInterp eval source [lindex $argv 0]}]} {
        puts "<fail>Error sourcing [lindex $argv 0]: $error"
        puts $::errorInfo
    }
    $TestInterp eval RunTest $TestProc

    interp delete $TestInterp
}
