#!/usr/bin/tclsh

# **scan chain patterns max size regexp**
set SC_PAT_SIZE {ScanLength\s(\d+)}

# **scan chain pattern max size**
set max_scan_pat_size 0

# **source aux functions**
source my_func.tcl

# @Brief Read .spf (STIL) file format containing ATPG patters and saves the pattern into a file.mem"

# **Regex for scan chains patterns**
set SC_PAT_REGEXP {"instr_rdata_i\[(\d+)\]"=(\d+)}

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

# **File .txt where patterns are saved"
set SC_OUT_NAME "patterns.txt"

# **File .mem where transposed patterns are saved
set SC_T_OUT_NAME "t_patterns.txt"

set fd_out [open $SC_OUT_NAME "w"]
set fd_out_t [open $SC_T_OUT_NAME "w"]

set fd [open $SC_FILE_NAME "r"]
set EOF [gets $fd line]

# **pattern counter**
set ch_count 0
set ch_number 0
set counter 0

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
			if { $ch_number == $ch_max_number} {
				set DONE 1
			}
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
	} else {
		set match_flag [regexp $SC_PAT_SIZE $line pattern_line pattern ]
		if { $match_flag == 1 } {
			if { $pattern > $max_scan_pat_size } {
				set max_scan_pat_size $pattern
			} 
		}

	}
	
	set EOF [gets $fd line]
} 

close $fd
close $fd_out
# **integrity check**
set checksum [expr ($ch_number * $scan_chains)]
if { $checksum != $counter } {
	puts "Integrity check failed!"
	puts "Number of scan chains = $scan_chains"
	puts "Numebr of pattern read = $ch_number"
	return -1
}

puts "Max pattern size: $max_scan_pat_size"
