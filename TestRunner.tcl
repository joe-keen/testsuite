set itsTestRunning 0

::itcl::class TestRunner {
    constructor {{TestFiles {}}} {}
    destructor {}

    # Timing ---------------------------------------------------------
    method Done {}
    method WaitUntilDone {}

    # Finding files --------------------------------------------------
    method FindFiles {{dir .}}
    method TraverseSubDirectory {dir}
   
    # Test Interaction -----------------------------------------------
    method RunTests {}
    method RunSingleTest {file} 
    method Recieve {}

    variable ValidTest {}
    variable itsOutput {}
    variable itsTestFiles {}
    variable itsFileList {}
    variable itsCurrentFile {}
}

#----------------------------------------------------------------------------

::itcl::body TestRunner::constructor {{TestFiles {}}} {
    set itsTestFiles $TestFiles
    set itsOutput [$::GUI GetOutput]
}

#----------------------------------------------------------------------------

::itcl::body TestRunner::Done {} {
   incr ::itsTestRunning
}

#----------------------------------------------------------------------------

::itcl::body TestRunner::WaitUntilDone {} {
   vwait ::itsTestRunning
}

#----------------------------------------------------------------------------

::itcl::body TestRunner::FindFiles {{dir .}} {
   foreach file [glob -nocomplain -directory $dir test_*] {
      lappend itsFileList $file
   }
   TraverseSubDirectory $dir
}

#----------------------------------------------------------------------------

::itcl::body TestRunner::TraverseSubDirectory {dir} {
   foreach directory [glob -nocomplain -directory $dir -types d *] {
      if {![regexp "easyunit" $directory]} {
         FindFiles $directory
      }
   }
}

#----------------------------------------------------------------------------

::itcl::body TestRunner::RunTests {} {
    $::GUI Disable 
    set ValidTest false
    set TestsRun 0
    set itsFileList {}
    if {$itsTestFiles == {}} {
        FindFiles
    } else {
        set itsFileList $itsTestFiles
    }
    foreach file $itsFileList {
        RunSingleTest $file
        WaitUntilDone
        if {$ValidTest} {incr TestsRun}
    }
    $itsOutput Issue " Tests Run: $TestsRun\n" "Footer"
    $::GUI Enable
}

#----------------------------------------------------------------------------

::itcl::body TestRunner::RunSingleTest {file} {
   $::GUI SetFile $file
   if {[regexp -- "\.tcl" $file]} {
      set itsCurrentFile \
         [open "|$::env(TESTSUITE_DIR)/TclTestRunner.tcl $file"]
   } else {
      set itsCurrentFile [open "|./$file"]
   }
   set ValidTest false
   fileevent $itsCurrentFile readable [list $this Recieve]
}

#----------------------------------------------------------------------------

::itcl::body TestRunner::Recieve {} {
   if {[eof $itsCurrentFile]} {
      fileevent $itsCurrentFile readable ""
      catch {close $itsCurrentFile}
      Done
      return
   }
   
   set theLine [gets $itsCurrentFile]
   set tags ""
   set type ""
   regexp -- "^<(.*?)>" $theLine --> type
   switch $type {
      "testcase" {set tags "Header"}
      "testcasepass" {}
      "teastcasefail" {}
      "testblock" {set tags "TestBlock"}
      "pass" {
         $::GUI Pass
         set tags "Pass"
      }
      "fail" {
         $::GUI Fail
         set tags "Fail"
      }
      "warn" {
        $::GUI Warn
        set tags "Warn"
      }
      default {
         set tags "Debug"
      }
   }
   regsub "^<(.*?)>" $theLine {} theLine

   if {[regexp "Segmentation fault" $theLine]} {
      set tags "Fail"   
   }

   #if {$theLine != ""} {
      set ValidTest true
      $itsOutput Issue "$theLine\n" $tags
   #}
}
