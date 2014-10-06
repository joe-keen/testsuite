proc setup {} {}
proc shutdown {} {}

set error {}

proc bgerror {message} {
   puts "Event died with $message"
   puts $::errorInfo
}

proc expected {condition args} {
    rename puts _puts

    proc puts {args} {set ::LastStdOut $args}
    set result [eval $args]

    rename puts ""
    rename _puts puts
    
    switch $condition {
        "false" {if {!$result} {puts "<pass>got expected result from $args"}}
        "true"  {if {$result}  {puts "<fail>got unexpected result from $args"}}
    }
}

proc pass {Result {Message {}}} {
    set Message [eval concat $Message]
    if {$Message != {}} {
        set Message "\[$Message\] "
    }
    set Func [lindex [info level [expr {[info level] -1}]] 0]
    puts "<pass>${Func}: $Message$Result"
    return 1
}

proc fail {Result {Message {}}} {
    set Message [eval concat $Message]
    if {$Message != {}} {
        set Message "\[$Message\] "
    }
    set Func [lindex [info level [expr {[info level] -1}]] 0]
    puts "<fail>${Func}: $Message$Result"
    return 0
}

proc assert_warn {msg} {
    puts "<warn>assert_warn: $msg"
}

proc assert_fail {msg} {
    puts "<fail>assert_fail: $msg"
}

proc assert_message {args} {
    set MessageFilter {}
    foreach msg $::theMessage {
        set result [assert_message_filter $args $msg]
        if {$result != {}} {
            lappend MessageFilter $result
        }
    }
    if {[llength $MessageFilter] > 0} {
        pass "Message found containing $args"
    } else {
        fail "Message not found containing $args"
    }
}

proc assert_!message {args} {
    set MessageFilter {}
    foreach msg $::theMessage {
        set result [assert_message_filter $args $msg]
        if {$result != {}} {
            lappend MessageFilter $result
        }
    }
    if {[llength $MessageFilter] > 0} {
        fail "Message found containing $args"
    } else {
        pass "Message not found containing $args"
    }

}

proc assert_message_filter {ExpressionList Message} {
    foreach expression $ExpressionList {
        if {![regexp -- $expression $Message]} {return}
    }
    return $Message
}

proc assert_regexp {expression data args} {
    if {[regexp -- $expression $data]} {
        pass "{$expression} found" $args
    } else {
        fail "{$expression} not found" $args
    }
}

proc assert_!regexp {expression data args} {
    if {![regexp -- $expression $data]} {
        pass "{$expression} not found" $args
    } else {
        fail "{$expression} found" $args
    }
}

proc assert_true {condition args} {
    if {$condition} {
        pass "$condition is true" $args
    } else {
        fail "$condition is false" $args
    }
}

proc assert_false {condition args} {
    if {!$condition} {
        pass "$condition is false" $args
    } else {
        fail "$condition is true" $args
    }
}

proc assert_equal {lhs rhs args} {
    if {"$lhs" == "$rhs"} {
        pass "$lhs == $rhs" $args
    } else {
        fail "$lhs == $rhs" $args
    }
}

proc assert_notequal {lhs rhs args} {
    if {$lhs != $rhs} {
        pass "$lhs != $rhs" $args
    } else {
        fail "$lhs != $rhs" $args
    }
}

proc RunTest {Function} {
    if {[catch {setup} error]} {
        puts "<fail>Error in setup: $error"
        puts $::errorInfo
        flush stdout
    }
    if {[catch {eval $Function} error]} {
        puts "<fail>Error running $Function: $error"
        puts $::errorInfo
        flush stdout
    }
    if {[catch {shutdown} error]} {
        puts "<fail>Error in shutdown: $error"
        puts $::errorInfo
        flush stdout
    }
}
