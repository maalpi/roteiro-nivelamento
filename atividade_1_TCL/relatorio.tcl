set filename "netlist.v"; #abrindo o arquivo

set file [open $filename r]
set content [read $file]
close $file

array set count_AND2 {}
array set count_XOR2 {}
array set count_fp_D {}

set lines [split $content "\n"]
foreach line $lines {
    if {[regexp {AND2} $line]} {
        set count_AND2([lindex [split $line " "] 1]) [expr {$count_AND2([lindex [split $line " "] 1]) + 1}]
    } elseif {[regexp {XOR2} $line]} {
        set count_XOR2([lindex [split $line " "] 1]) [expr {$count_XOR2([lindex [split $line " "] 1]) + 1}]
    } elseif {[regexp {fp_D} $line]} {
        set count_fp_D([lindex [split $line " "] 1]) [expr {$count_fp_D([lindex [split $line " "] 1]) + 1}] 
    }
}
puts "Contagem de AND2:"
foreach key [array names count_AND2] {
    puts "$key: $count_AND2($key)"
}   
puts "Contagem de XOR2:"
foreach key [array names count_XOR2] {
    puts "$key: $count_XOR2($key)"
}   
puts "Contagem de fp_D:"
foreach key [array names count_fp_D] {
    puts "$key: $count_fp_D($key)"
}  