::itcl::class Results {
   constructor {theFrame} {}
   destructor {}

   # Setting results  -----------------------------------------------
   
   method SetFile {file}
   method SetPass {}
   method SetFail {}
   method SetWarn {}

   # Label manipulation ---------------------------------------------
   
   method SetLabel {} 
   method Clear {} 

   private variable itsPass 0
   private variable itsFail 0
   private variable itsWarn 0
   private variable itsFile {}

   private variable Colors
   array set Colors {}
   private variable Widgets
   array set Widgets {}
}

#----------------------------------------------------------------------------

::itcl::body Results::constructor {theFrame} {
   set Widgets(Label) [label $theFrame.label -borderwidth 1 -anchor nw]

   set Colors(Base) [lindex [$Widgets(Label) configure -background] 4]
   set Colors(Pass) "#3a883a"
   set Colors(Fail) "#cd1f1f"
   set Colors(Warn) "#e5c42c"

   pack $Widgets(Label) -fill x -anchor nw -expand true
   SetLabel
}

#----------------------------------------------------------------------------

::itcl::body Results::SetFile {file} {
   set itsFile $file
}  

#----------------------------------------------------------------------------

::itcl::body Results::SetPass {} {
   incr itsPass 
   SetLabel
}

#----------------------------------------------------------------------------

::itcl::body Results::SetFail {} {
   incr itsFail
   SetLabel
}

#----------------------------------------------------------------------------

::itcl::body Results::SetWarn {} {
   incr itsWarn
   SetLabel
}

#----------------------------------------------------------------------------

::itcl::body Results::SetLabel {} {
   if {$itsFail} {
      set theColor $Colors(Fail)
   } elseif {$itsWarn} {
      set theColor $Colors(Warn)
   } elseif {$itsPass} {
      set theColor $Colors(Pass)
   } else {
      set theColor $Colors(Base)
   }

   set Label [format "%-10.10s%10.10s%10.10s%5.5s%-80.80s" \
               "Pass: $itsPass" \
               "Fail: $itsFail" \
               "Warn: $itsWarn" \
               "" \
               "$itsFile"]
   $Widgets(Label) configure -text $Label -background $theColor
}

#----------------------------------------------------------------------------

::itcl::body Results::Clear {} {
   set itsPass 0
   set itsFail 0
   set itsWarn 0
   set itsFile {}
   #$Widgets(Label) configure -text "" -background $Colors(Base)
   SetLabel
}
