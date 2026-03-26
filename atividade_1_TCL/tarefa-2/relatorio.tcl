set canal [open "netlist.v" r]
set linhas [split [read $canal] "\n"]
close $canal

# variaveis
array set submodulos {}
set lista_todos_modulos {}
set modulo_atual ""

# percorrendo para identificar os modulos
foreach linha $linhas {
    set linha [string trim $linha]

    # pula coments e linhas vazias
    if {$linha == "" || [string match "/*" $linha] || [string match "//*" $linha]} {
        continue
    }

    # identifica modulo
    if {[string match "module *" $linha]} {
        # pega a segunda palavra da linha
        set modulo_atual [lindex $linha 1]
        lappend lista_todos_modulos $modulo_atual
        set submodulos($modulo_atual) {} 
        continue
    }

    # identifica o fim do modulo
    if {[string match "endmodule*" $linha]} {
        set modulo_atual ""
        continue
    }

    # pega instancias(se estamos dentro de um módulo e a linha tem um parênteses)
    if {$modulo_atual != "" && [string match "*(*)*" $linha]} {
        set tipo_instancia [lindex $linha 0]

        # ignrorando oq nao é componente
        set reservadas {input output wire reg always assign if else}
        if {$tipo_instancia ni $reservadas} {
            lappend submodulos($modulo_atual) $tipo_instancia
        }
    }
}

puts "\n=== ARVORE HIERARQUICA DO DESIGN ==="

foreach modulo $lista_todos_modulos {
    puts "\n$modulo"

    set lista_instancias $submodulos($modulo)
    
    if {[llength $lista_instancias] == 0} {
        puts "L___(sem instancias)"
        continue
    }

    array set contador {}
    foreach item $lista_instancias {
        if {![info exists contador($item)]} { set contador($item) 0 }
        incr contador($item)
    }

    set tem_primitiva 0
    foreach tipo [array names contador] {
        set qtd $contador($tipo)
        
        # se o tipo está na lista de módulos, é um sub-módulo
        if {$tipo in $lista_todos_modulos} {
            puts "L___$tipo ($qtd instancias)"
        } else {
            # se não, é uma célula básica
            set tem_primitiva 1
        }
    }

    if {$tem_primitiva} {
        puts "L___(celulas primitivas)"
    }
    
    # Limpa o contador para o próximo módulo
    array unset contador
}