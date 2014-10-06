::itcl::class Options {
   constructor {theFrame} {}
   destructor {}

   method Setup {}
   method Toggle {name}
   method RunTests {}
   method Enable {} 
   method Disable {}

   private variable Buttons
   array set Buttons {}
   private variable Widgets
   array set Widgets {}
}

#----------------------------------------------------------------------------

::itcl::body Options::constructor {theFrame} {
   set Buttons(Header) "false"
   set Buttons(TestBlock) "false"
   set Buttons(Pass) "false"
   set Buttons(Fail) "false"
   set Buttons(Warn) "false"
   set Buttons(Debug) "false"
   
   set Widgets(Header) [checkbutton $theFrame.header -text "Header" \
                              -command [list $this Toggle "Header"]]
   set Widgets(TestBlock) [checkbutton $theFrame.testblock -text "TestBlock" \
                              -command [list $this Toggle "TestBlock"]]
   set Widgets(Pass) [checkbutton $theFrame.pass -text "Pass" \
                              -command [list $this Toggle "Pass"]]
   set Widgets(Fail) [checkbutton $theFrame.fail -text "Fail" \
                              -command [list $this Toggle "Fail"]]
   set Widgets(Warn) [checkbutton $theFrame.error -text "Warn" \
                              -command [list $this Toggle "Warn"]]
   set Widgets(Debug) [checkbutton $theFrame.debug -text "Debug" \
                              -command [list $this Toggle "Debug"]]

   set Widgets(Test) [button $theFrame.test -text "Run Tests" \
                              -command [list $this RunTests] -borderwidth 1]

   pack $Widgets(Header) -side left
   pack $Widgets(TestBlock) -side left
   pack $Widgets(Pass) -side left
   pack $Widgets(Fail) -side left
   pack $Widgets(Warn) -side left
   pack $Widgets(Debug) -side left
   pack $Widgets(Test) -side right
}

#----------------------------------------------------------------------------

::itcl::body Options::Setup {} {
   $Widgets(Header) invoke
   $Widgets(TestBlock) invoke
   $Widgets(Fail) invoke
   $Widgets(Warn) invoke
}

#----------------------------------------------------------------------------

::itcl::body Options::Toggle {name} {
   set Buttons($name) [expr {!$Buttons($name)}]
   $::GUI SetAllowedTags [array get Buttons]
}

#----------------------------------------------------------------------------

::itcl::body Options::RunTests {} {
   $::GUI Clear
   $::Runner RunTests
}

#----------------------------------------------------------------------------

::itcl::body Options::Disable {} {
    $Widgets(Test) configure -state disable
}

#----------------------------------------------------------------------------

::itcl::body Options::Enable {} {
    $Widgets(Test) configure -state normal
}
