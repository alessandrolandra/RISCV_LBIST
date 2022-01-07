#!/usr/bin/tclsh

# **scan chain patterns max size regexp**
set SC_PAT_SIZE {ScanLength\s(\d+)}

# **scan chain pattern max size**
set max_scan_pat_size 0

# **source aux functions**
source my_func.tcl

# @Brief Read .spf (STIL) file format containing ATPG patters and saves the pattern into a file.mem"

# **Regex for scan load/unload patterns**
set SC_PAT_REGEXP {"instr_rdata_i\[(\d+)\]"=(\d+)}

# **Regex for scan capture patterns**
set CAP_PAT_REGEXP {"_pi"=(\w+)}

# **File .spf (STIL)**
set SC_FILE_NAME "atpg_gen_patt.spf"
set SC_FILE_ORIGINAL "../../syn/output/$SC_FILE_NAME"
if {![file exists $SC_FILE_NAME]} {
	puts "file doesn't exist, trying to find it.."
	if {![file exists $SC_FILE_ORIGINAL]} {
		puts "cannot proceed, please generate the STIL file using ../../tmax.sh"
		exit -1
	} else {
		puts [exec cp $SC_FILE_ORIGINAL .]
	}
}

#####################################################
###########pre processing############################
#####################################################
puts [exec cat $SC_FILE_NAME | tr ";" "\n" > test.txt]
set SC_FILE_NAME "test.txt"

# **File .txt where load/unload patterns are saved"
set SC_OUT_NAME "patterns.txt"

# **File .txt where transposed and ordered (decreasing order --> "downto") load/unload patterns are saved
set SC_T_OUT_NAME "t_patterns.txt"

# **File .txt where capture and ordered (increasing order --> "upto") patterns are saved
set CAP_OUT_NAME "c_patterns_upto.txt"

# **File .txt where capture and ordered (decreasing order --> "downto") patterns are saved
set CAP_OUT_NAME_R "c_patterns_downto.txt"

set fd_out [open $SC_OUT_NAME "w"]
set fd_out_t [open $SC_T_OUT_NAME "w"]
set fd_out_c [open $CAP_OUT_NAME "w"]
set fd_out_cc [open $CAP_OUT_NAME_R "w"]

set fd [open $SC_FILE_NAME "r"]
set EOF [gets $fd line]

# **pattern counter**

set ch_count 0
set ch_number 0
set counter 0 
set counter2 0

# **number of scan chains**
set scan_chains 12

# **number of patterns that will be parsed**
## *PUT -1 IF YOU WANT TO READ ALL PATTERNS**
set ch_max_number 5

# **List of patterns
set p_list [list]

# **Parsing**
set DONE 0
while { $EOF >=0 && $DONE == 0 } {
	set match_flag [regexp $SC_PAT_REGEXP $line pattern_line index pattern ]
	if { $match_flag == 1 } {
		if { [strlen $pattern] == 1 } {
			set ch_count 0
			set EOF [gets $fd line]
			continue
		}
		incr ch_count
		if { $ch_count == $scan_chains } {
			puts $pattern
			#puts $fd_out $pattern
			lappend p_list [list $index $pattern]
			set ch_count 0
			incr counter
			# order the list and save it on file
			set p_list [lsort -index 0 -integer -decreasing $p_list]
			set tmp_p_list [list]
			foreach pat $p_list {
				puts $fd_out [lindex $pat 1]
				puts [lindex $pat 1]
				lappend tmp_p_list [lindex $pat 1]
			}

			set tmp_p_list [transpose_list $tmp_p_list $max_scan_pat_size]
			set tmp_p_list [lreverse $tmp_p_list]
			foreach pat $tmp_p_list {
				puts $fd_out_t $pat
			}
			set p_list [list]
			puts "Chain $ch_number END"
		} elseif { $ch_count == 1 } {
			incr ch_number
			puts "Chain $ch_number START"
			lappend p_list [list $index $pattern]
			incr counter
		} else {
			lappend p_list [list $index $pattern]
			incr counter
		}
	} elseif { [regexp $SC_PAT_SIZE $line pattern_line pattern ] == 1} {
			if { $pattern > $max_scan_pat_size } {
				set max_scan_pat_size $pattern
			} 
	} elseif {[regexp $CAP_PAT_REGEXP $line pattern_line pattern] == 1} {	
			puts "CHAIN $ch_number CAPTURE PATTERN: $pattern"
			puts $fd_out_c $pattern
			set pattern [string_reverse $pattern]
			puts $fd_out_cc $pattern
			incr counter2
			if { $ch_number == $ch_max_number} {
				set DONE 1
			}
	}
	
	set EOF [gets $fd line]
} 

close $fd
close $fd_out
close $fd_out_c
close $fd_out_cc

# **integrity checks**
set checksum1 [expr ($ch_number * $scan_chains)]
set checksum2 $counter2
if { ($checksum1 != $counter) || ($checksum2 != $ch_number)} {
	puts "Integrity checks ERROR, one (or both) of the following conditions failed"
	puts "Condition 1: NUMBER OF LOAD/UNLOAD PATTERNS == $counter, BUT IT IS: $checksum1"
	puts "Condition 2: NUMBER OF CAPTURE PATTERNS == $ch_number, BUT IT IS: $checksum2"
	return -1
}

puts "Max pattern size: $max_scan_pat_size"
