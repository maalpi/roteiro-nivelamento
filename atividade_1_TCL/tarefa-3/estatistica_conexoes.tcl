# estatisticas_conexoes.tcl

set filename "netlist.v"

array set fanout {}
array set nets {}

set fp [open $filename r]

while {[gets $fp line] >= 0} {

    regsub {//.*} $line "" line

    # Captura wires
    if {[regexp {wire\s+(.+);?} $line -> wires]} {
        foreach net [split $wires ","] {
            set net [string trim $net]
            set nets($net) 1
            if {![info exists fanout($net)]} {
                set fanout($net) 0
            }
        }
    }

    # Captura conexões .porta(net)
    set matches [regexp -all -inline {\.\w+\((\w+)\)} $line]

    foreach match $matches {
        regexp {\((\w+)\)} $match -> net

        if {[info exists fanout($net)]} {
            incr fanout($net)
        } else {
            set fanout($net) 1
            set nets($net) 1
        }
    }
}

close $fp

# Lista para ordenação
set fanout_list {}
foreach net [array names fanout] {
    lappend fanout_list [list $net $fanout($net)]
}

set sorted [lsort -integer -decreasing -index 1 $fanout_list]

# ===== SAÍDA FORMATADA =====

puts "=== TOP 10 REDES COM MAIOR FANOUT ===\n"

set count 0
foreach item $sorted {
    set net [lindex $item 0]
    set fo  [lindex $item 1]

    puts "$net: fanout = $fo\n"

    incr count
    if {$count == 10} { break }
}

puts "=== REDES COM FANOUT ZERO (POSSÍVEIS ERROS) ===\n"

foreach net [lsort [array names fanout]] {
    if {$fanout($net) == 0} {
        puts "$net"
    }
}