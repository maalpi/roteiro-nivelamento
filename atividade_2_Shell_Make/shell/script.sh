#!/bin/bash

DRY_RUN=0
if [ "$1" == "--dry-run" ]; then
    DRY_RUN=1
    echo "Dry-run ativado"
fi

DIRS_CRIADOS=0
ARQUIVOS_MOVIDOS=0

for dir in src tb include scripts docs; do
    if [ ! -d "$dir" ]; then
        if [ $DRY_RUN -eq 0 ]; then
            mkdir "$dir"
        fi
        echo "Diretorio criado: $dir"
        DIRS_CRIADOS=$((DIRS_CRIADOS + 1))
    fi
done

for f in *_tb.v *test*; do
    if [ -f "$f" ]; then
        if [ ! -e "tb/$f" ]; then
            if [ $DRY_RUN -eq 1 ]; then
                echo "[DRY-RUN] Moveria $f para tb/"
            else
                echo "Movendo $f para tb/"
                mv -n "$f" tb/
            fi
            ARQUIVOS_MOVIDOS=$((ARQUIVOS_MOVIDOS + 1))
        fi
    fi
done

for f in *.v; do
    if [ -f "$f" ]; then
        if [[ "$f" == *"_tb.v"* ]] || [[ "$f" == *"test"* ]]; then
            continue
        fi
        if [ ! -e "src/$f" ]; then
            if [ $DRY_RUN -eq 1 ]; then
                echo "[DRY-RUN] Moveria $f para src/"
            else
                echo "Movendo $f para src/"
                mv -n "$f" src/
            fi
            ARQUIVOS_MOVIDOS=$((ARQUIVOS_MOVIDOS + 1))
        fi
    fi
done

for f in *.vh; do
    if [ -f "$f" ]; then
        if [ ! -e "include/$f" ]; then
            if [ $DRY_RUN -eq 1 ]; then
                echo "[DRY-RUN] Moveria $f para include/"
            else
                echo "Movendo $f para include/"
                mv -n "$f" include/
            fi
            ARQUIVOS_MOVIDOS=$((ARQUIVOS_MOVIDOS + 1))
        fi
    fi
done

for f in *.tcl *.do *.sh; do
    if [ -f "$f" ]; then
        if [[ "$f" == $(basename "$0") ]]; then
            continue
        fi
        if [ ! -e "scripts/$f" ]; then
            if [ $DRY_RUN -eq 1 ]; then
                echo "[DRY-RUN] Moveria $f para scripts/"
            else
                echo "Movendo $f para scripts/"
                mv -n "$f" scripts/
            fi
            ARQUIVOS_MOVIDOS=$((ARQUIVOS_MOVIDOS + 1))
        fi
    fi
done

for f in *.md *.txt; do
    if [ -f "$f" ]; then
        if [ ! -e "docs/$f" ]; then
            if [ $DRY_RUN -eq 1 ]; then
                echo "[DRY-RUN] Moveria $f para docs/"
            else
                echo "Movendo $f para docs/"
                mv -n "$f" docs/
            fi
            ARQUIVOS_MOVIDOS=$((ARQUIVOS_MOVIDOS + 1))
        fi
    fi
done

echo ""
echo "--- Relatorio Final ---"
echo "Pastas criadas: $DIRS_CRIADOS"
echo "Arquivos movidos: $ARQUIVOS_MOVIDOS"