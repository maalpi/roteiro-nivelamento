set canal [open "netlist.v" r]
set linhas [split [read $canal] "\n"]
close $canal

array set contagem_fanout {}

# perccorrend linha por linha
foreach linha $linhas {
    set linha [string trim $linha]

    if {$linha == "" || [string match "/*" $linha] || [string match "//*" $linha]} {
        continue
    }

    # procurando o caractere "." que indica uma porta
    set inicio_busca 0
    while {[set pos [string first "." $linha $inicio_busca]] != -1} {
        
        # pegar onde começa e termina o ( )
        set abrindo [string first "(" $linha $pos]
        set fechando [string first ")" $linha $abrindo]

        if {$abrindo != -1 && $fechando != -1} {
            # extrai o nome da porta
            set porta [string range $linha $pos [expr {$abrindo - 1}]]
            set porta [string trim $porta]

            # extrai a net entre os parenteses 
            set net [string range $linha [expr {$abrindo + 1}] [expr {$fechando - 1}]]
            set net [string trim $net]

            # pula constantes
            if {[string match "*'b*" $net]} {
                set inicio_busca [expr {$fechando + 1}]
                continue
            }

            # se a net nao existir no array, cria com 0
            if {![info exists contagem_fanout($net)]} {
                set contagem_fanout($net) 0
            }

            # se a porta NÃO for saída, conta fanout
            set eh_saida 0
            foreach p {".Y" ".Q" ".out" ".S" ".Cout"} {
                if {[string match -nocase "$p*" $porta]} {
                    set eh_saida 1
                    break
                }
            }

            if {!$eh_saida} {
                incr contagem_fanout($net)
            }
        }

        set inicio_busca [expr {$fechando + 1}]
    }
}

# 3. Preparar a lista para ordenar
set lista_final {}
foreach nome [array names contagem_fanout] {
    lappend lista_final [list $nome $contagem_fanout($nome)]
}

# ordenar do maior pro menor
set lista_ordenada [lsort -integer -decreasing -index 1 $lista_final]

# printando
puts "\n=== TOP 10 NETS POR FANOUT ==="
set i 0
foreach item $lista_ordenada {
    set nome [lindex $item 0]
    set valor [lindex $item 1]
    
    if {$valor > 0} {
        puts "$nome: fanout = $valor"
        incr i
    }
    if {$i == 10} { break }
}

puts "\n=== NETS COM FANOUT ZERO (POSSIVEIS ERROS) ==="
foreach item $lista_ordenada {
    if {[lindex $item 1] == 0} {
        puts "[lindex $item 0]"
    }
}