set InterpTestVariable 0

proc setup {} {puts "Setup"}
proc shutdown {} {puts "Shutdown"}

proc test_TestOne {} {
    assert_equal 1 1
    expected false assert_equal 1 0

    expected false assert_equal 1 0 Foo
    assert_regexp "\[Foo\]" $::LastStdOut

    assert_notequal 1 0
    expected false assert_notequal 1 1
   
    assert_true 1
    expected false assert_true 0
   
    assert_false 0
    expected false assert_false 1
   
    assert_regexp "D E" "A B C D E"
    expected false assert_regexp "A E" "A B C D E"

    assert_!regexp "F F" "A B C D E"
    expected false assert_!regexp "A B" "A B C D E"

    set ::theMessage "{A B C D} {E F G H} {A B F}"
    assert_message A B F
    expected false assert_message A B E
    assert_!message A B E
}

proc test_FirstInterp {} {
    set ::InterpTestVariable 50
    assert_equal $::InterpTestVariable 50
}

proc test_SecondInterp {} {
    assert_equal $::InterpTestVariable 0
}
