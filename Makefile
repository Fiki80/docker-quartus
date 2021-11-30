# Links taken from https://aur.archlinux.org/packages/quartus-free-quartus/

FILES =  QuartusLiteSetup-20.1.1.720-linux.run 
FILES += max10-20.1.1.720.qdz
FILES += ModelSimSetup-20.1.1.720-linux.run


.PHONY: all build install clean

all: build

$(FILES):
	$(foreach var,$(FILES),curl -O https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_installers/$(var);)
	chmod +x *.run

build: $(FILES)
	docker build -t quartus:latest \
		--build-arg uid=$$(id -u) \
		--build-arg gid=$$(id -g) .

install:
	@chmod +x _quartus
	@cp _quartus ${HOME}/.local/bin/quartus
	@echo "Done."

clean:
	@rm -f *.run
	@rm -f *.qdz
