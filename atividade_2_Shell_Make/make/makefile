RELATORIO = relatorio.txt
SCRIPT_TCL = script.tcl
SCRIPT_SHELL = shell/script.sh

all: organizar $(RELATORIO)

$(RELATORIO): $(SCRIPT_TCL)
	@echo "Relatório não encontrado. Criando o relatório..."
	touch $(RELATORIO)

organizar:
	@echo "Organizando o projeto..."
	./$(SCRIPT_SHELL)

clean:
	@echo "Removendo o relatório..."
	rm -f $(RELATORIO)

.PHONY: all organizar clean