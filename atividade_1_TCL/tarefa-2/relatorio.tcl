# ================================
# Leitura do arquivo
# ================================
set filename "netlist.v"

set fp [open $filename r]
set content [read $fp]
close $fp

# ================================
# Estruturas
# ================================
set current_module ""
set modules {}
array set hierarchy {}
array set count {}

# ================================
# Regex
# ================================
set module_regex {^\s*module\s+(\w+)}
set inst_regex {^\s*(\w+)\s*(#\s*\(.*\))?\s+\w+\s*\(}

# ================================
# Parse do arquivo
# ================================
foreach line [split $content "\n"] {

    set l [string trim $line]

    # Ignorar comentários
    if {[string match "//*" $l]} {
        continue
    }

    # Detectar módulo
    if {[regexp $module_regex $l -> mod]} {
        set current_module $mod
        lappend modules $mod
        set hierarchy($mod) {}
        continue
    }

    # Fim do módulo
    if {[string match "*endmodule*" $l]} {
        set current_module ""
        continue
    }

    # Detectar instâncias
    if {$current_module ne ""} {
        if {[regexp $inst_regex $l -> inst]} {

            # Guardar lista
            lappend hierarchy($current_module) $inst

            # Contagem por tipo dentro do módulo
            set key "$current_module,$inst"
            if {[info exists count($key)]} {
                incr count($key)
            } else {
                set count($key) 1
            }
        }
    }
}

# ================================
# Limpeza
# ================================
set modules [lsort -unique $modules]

foreach m $modules {
    if {[info exists hierarchy($m)]} {
        set hierarchy($m) [lsort -unique $hierarchy($m)]
    }
}

# ================================
# Identificar módulos instanciados
# ================================
set instantiated {}

foreach m $modules {
    foreach child $hierarchy($m) {
        if {[lsearch $modules $child] != -1} {
            lappend instantiated $child
        }
    }
}

set instantiated [lsort -unique $instantiated]

# ================================
# Impressão final
# ================================
puts "=== HIERARQUIA DO DESIGN ==\n"

foreach m $modules {

    puts "$m"

    # Verifica se tem submódulos reais
    set has_submodule 0

    foreach child $hierarchy($m) {
        if {[lsearch $modules $child] != -1} {
            set has_submodule 1

            set key "$m,$child"
            set n $count($key)

            puts "$child ($n instancias)"
        }
    }

    if {!$has_submodule} {

        # Se não instancia nada
        if {[llength $hierarchy($m)] == 0} {
            puts "($m modulo primitivo-sem submodulos)"
        } else {
            puts "(apenas celulas primitivas)"
        }
    } else {
        puts "(celulas primitivas)"
    }

    puts ""
}