set filename "netlist.v"
set reportFile "relatorio_contagem.txt"

set fd [open $filename r]
set content [read $fd]
close $fd

# iniciando as variaveis dos contadores
set count_AND2 0
set count_XOR2 0
set count_flipflop_D 0

# Percorrendo linha por linha para contar as portas logicas
set lines [split $content "\n"]
foreach line $lines {
    if {[regexp {^\s*AND2\s+\w+\s*\(} $line]} {
        incr count_AND2
    } elseif {[regexp {^\s*XOR2\s+\w+\s*\(} $line]} {
        incr count_XOR2
    } elseif {[regexp {^\s*flipflop_D\s+\w+\s*\(} $line]} {
        incr count_flipflop_D
    }
}

set report ""
append report "Relatório de contagem de células em $filename\n"
append report "---------------------------------------------\n"
append report "AND2: $count_AND2\n"
append report "XOR2: $count_XOR2\n"
append report "flipflop_D: $count_flipflop_D\n"

puts $report

set out [open $reportFile w]
puts -nonewline $out $report
close $out

puts "Arquivo de relatório gerado: $reportFile"