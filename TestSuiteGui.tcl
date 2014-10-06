::itcl::class TestSuiteGui {
   constructor {} {
      set Frame(Main) [frame .main]
      set Frame(Results) [frame $Frame(Main).results -height 10]
      set Frame(Options) [frame $Frame(Main).options -relief groove \
                              -borderwidth 2]
      set Frame(Output) [frame $Frame(Main).output]

      set itsResults [Results \#auto $Frame(Results)]
      set itsOptions [Options \#auto $Frame(Options)]
      set itsOutput  [Output \#auto $Frame(Output)]
      
      pack $Frame(Main) -fill both -expand true
      pack $Frame(Results) -fill x 
      pack $Frame(Options) -fill x
      pack $Frame(Output) -expand true -fill both 

      $itsOutput SetLineWrap word
      $itsOutput SetStickActive
   }

   destructor {} 

   method Setup {} {
      $itsOptions Setup
   }

   method Clear {} {
      $itsOutput Clear
      $itsOutput EraseLines
      $itsResults Clear
   }

   method GetOutput {} {
      return ::TestSuiteGui::$itsOutput
   }

   method SetAllowedTags {tagList} {
      $itsOutput SetAllowedTags $tagList
   }

   method SetFile {file} {
      $itsResults SetFile $file
   }

   method Pass {} {
      $itsResults SetPass
   }

   method Fail {} {
      $itsResults SetFail
   }
   
   method Warn {} {
      $itsResults SetWarn
   }

   method Disable {} {
      $itsOptions Disable
   }

   method Enable {} {
      $itsOptions Enable
   }

   variable itsOptions {}
   variable itsResults {}
   variable itsOutput {}
}
