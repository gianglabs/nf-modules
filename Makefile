.PHONY: lint clean

${HOME}/.pixi/bin/pixi:
	curl -sSL https://pixi.sh/install.sh | sh

# Lint
lint: ${HOME}/.pixi/bin/pixi
	${HOME}/.pixi/bin/pixi run nextflow lint $(shell find . -name "*.nf") -format

# Clean
clean:
	rm -rf work results .nextflow* *.log