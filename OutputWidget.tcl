::itcl::class Output {
   constructor {theFrame} {}
   destructor {}

   # Insertion and option setting ------------------------------------------
   
   method ReIssue {}
   method Issue {data {tag {}}}
   method Display {data tag}
   method AllowedTag {tag}
   method SetAllowedTags {tagList}
   method SetLineWrap {type}
   method SetStickActive {}
   
   # Text manipulation -----------------------------------------------------
   
   method Clear {} 
   method EraseLines {}
   method SetStick {}
   method Find {{index {}}}
   method JumpToBottom {}

   private variable itsLines {}
   private variable itsStick 0
   private variable Index 1.0
   private variable lastTerm {}

   private variable itsAllowedTags 
   array set itsAllowedTags {}
   private variable Widgets
   array set Widgets {}
}

#----------------------------------------------------------------------------

::itcl::body Output::constructor {theFrame} {
   set Widgets(Menu) [frame $theFrame.menu -borderwidth 1]
   set Widgets(TextFrame) [frame $theFrame.text]
      
   set Widgets(Clear) [button $Widgets(Menu).clear \
            -text "Clear" -command [list $this Clear] -borderwidth 1]
   set Widgets(Stick) [checkbutton $Widgets(Menu).jump \
            -text "Scroll" -borderwidth 1 -padx 5 \
            -variable $this -command [list $this SetStick]]
   set Widgets(SearchEntry) [iwidgets::entryfield \
            $Widgets(Menu).searchentry -labeltext "Search String:" \
            -borderwidth 1 -command [list $this Find]]
   set Widgets(Search) [button $Widgets(Menu).search \
            -text "Find" -command [list $this Find] -borderwidth 1]
   set Widgets(Text) [iwidgets::scrolledtext $Widgets(TextFrame).text \
            -borderwidth 1 -foreground black \
            -textbackground white -wrap none]

   pack $Widgets(Menu) -fill x -anchor nw
   pack $Widgets(TextFrame) -expand true -fill both 
   pack $Widgets(Clear) -side left -anchor nw
   pack $Widgets(Stick) -side left -anchor center 
   pack $Widgets(Search) -side right -anchor center
   pack $Widgets(SearchEntry) -side right -anchor center
   pack $Widgets(Text) -expand true -fill both
   
   set Tags(Pass) "#3a883a"
   set Tags(Fail) "#cd1f1f"
   set Tags(Warn) "#e5c42c"
   set Tags(Header) "#363cc6"
   set Tags(Footer) "#323232"
   set Tags(TestBlock) "#87B6ff"

   $Widgets(Text) tag configure Pass -foreground $Tags(Pass) 
   $Widgets(Text) tag configure Fail -foreground $Tags(Fail) 
   $Widgets(Text) tag configure Warn -foreground $Tags(Warn)
   $Widgets(Text) tag configure Header \
                           -background $Tags(Header) -foreground white 
   $Widgets(Text) tag configure Footer \
                           -background $Tags(Footer) -foreground white 
   $Widgets(Text) tag configure TestBlock \
                           -background $Tags(TestBlock) -foreground black

   set itsAllowedTags(Pass) "true"
   set itsAllowedTags(Fail) "true"
   set itsAllowedTags(Warn) "true"
   set itsAllowedTags(Header) "true"
   set itsAllowedTags(Footer) "true"
   set itsAllowedTags(TestBlock) "true"
   set itsAllowedTags(Debug) "true"
}

#----------------------------------------------------------------------------

::itcl::body Output::destructor {} {
   destroy $Widgets(Menu)
   destroy $Widgets(TextFrame)
   destroy $Widgets(Clear)
   destroy $Widgets(Stick)
   destroy $Widgets(SearchEntry)
   destroy $Widgets(Search)
   destroy $Widgets(Text)
}

#----------------------------------------------------------------------------

::itcl::body Output::ReIssue {} {
   Clear
   foreach {line tag} $itsLines {
      Display $line $tag
   }
}

#----------------------------------------------------------------------------

::itcl::body Output::Issue {data {tag {}}} {
   lappend itsLines $data 
   lappend itsLines $tag
   Display $data $tag
}

#----------------------------------------------------------------------------

::itcl::body Output::Display {data tag} {
   if {[AllowedTag $tag]} {
      $Widgets(Text) insert end $data $tag
      update idletasks
      if {$itsStick} {JumpToBottom}
   }
}

#----------------------------------------------------------------------------

::itcl::body Output::AllowedTag {tag} {
   if {$tag == ""} {return true}
   return $itsAllowedTags($tag)
}

#----------------------------------------------------------------------------

::itcl::body Output::SetAllowedTags {tagList} {
   array set itsAllowedTags $tagList
   ReIssue
}

#----------------------------------------------------------------------------

::itcl::body Output::Clear {} {
   $Widgets(Text) delete 0.0 end
}

#----------------------------------------------------------------------------

::itcl::body Output::EraseLines {} {
   set itsLines {}
}

#----------------------------------------------------------------------------

::itcl::body Output::Find {{index {}}} {
   set Term [$Widgets(SearchEntry) get]
   $Widgets(Text) tag remove search 0.0 end

   if {$index != {}} {set Index $index}
   if {$lastTerm != $Term} {
      set lastTerm $Term
      set Index 1.0
   }

   set curIndex $Index
   set Index [$Widgets(Text) search -nocase -count length {$Term} $Index end]
   if {$Index == "" && $curIndex != 1.0} {
      Find 1.0
      return
   } 
   if {$Index == ""} {return}

   $Widgets(Text) tag add search $Index "$Index + $length char"
   $Widgets(Text) tag configure search -background #ce5555 -foreground white
   $Widgets(Text) see $Index
   set Index [$Widgets(Text) index "$Index + $length char"]
}

#----------------------------------------------------------------------------

::itcl::body Output::JumpToBottom {} {
   $Widgets(Text) see end 
}

#----------------------------------------------------------------------------

::itcl::body Output::SetStick {} {
   set itsStick [expr !$itsStick]
}

#----------------------------------------------------------------------------

::itcl::body Output::SetStickActive {} {
   $Widgets(Stick) select
   set itsStick 1
}

#----------------------------------------------------------------------------

::itcl::body Output::SetLineWrap {type} {
   $Widgets(Text) configure -wrap $type
}
