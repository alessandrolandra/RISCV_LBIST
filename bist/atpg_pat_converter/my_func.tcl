
# @Brief return the length of a string
proc strlen s {
    return [llength [split $s {}]]
}


# @Brief a number of patterns, returns the transpose on if
proc transpose_list {pat_list max_pat_length} {
	set count 0
	set t_list [list]
	set adj_list [list]
	# *adjust the size*
	foreach pattern $pat_list {
		set t_pattern $pattern
		while { [strlen $t_pattern] < $max_pat_length } {
			set t_pattern ${t_pattern}0
		}
		#puts "------> $pattern $t_pattern"
		lappend adj_list $t_pattern
	}
	for {set i 0} {$i < $max_pat_length} {incr i} {
		set tmp_str -1

		for {set j 0} {$j < [llength $adj_list]} {incr j} {
			set p [lindex $adj_list $j]
			set t_p [string index $p $i]
			if { $tmp_str == -1 } {
				set tmp_str $t_p
			} else {
				set tmp_str ${tmp_str}$t_p
			}
			
		}
		#puts "aaaa $tmp_str"
		lappend t_list $tmp_str
	}
	return $t_list 

}

# @Brief given a string, reverse it

proc string_reverse str {
	set str_rev -1
	set len [expr ([strlen $str] -1)]
	for {set i $len} {$i >= 0} {set i [expr ($i -1)]} {
		set t_p [string index $str $i]
		if { $str_rev == -1 } {
			set str_rev $t_p
		} else {
			set str_rev ${str_rev}$t_p
		}
	}
	return $str_rev;
} 
