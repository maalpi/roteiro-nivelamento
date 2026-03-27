# Arquivo Verilog
set filename "netlist.v"

# Ler arquivo
set fp [open $filename r]
set content [read $fp]
close $fp

# Contadores
set and2 0
set xor2 0
set dff 0

# Regex para instâncias
set regex {^\s*(\w+)\s*(#\s*\(.*\))?\s+\w+\s*\(}

# Percorrer linhas
foreach line [split $content "\n"] {

    if {[regexp $regex $line -> cell]} {

        switch -- $cell {
            "AND2"        { incr and2 }
            "XOR2"        { incr xor2 }
            "flipflop_D"  { incr dff }
        }
    }
}

# Total
set total [expr {$and2 + $xor2 + $dff}]

# Relatório
puts "\n=== Relatorio de instancias: ===\n"
puts "AND2: $and2 instancias"
puts "XOR2: $xor2 instancias"
puts "flipflop_D: $dff instancias"
puts "\nTOTAL: $total instancias\n"