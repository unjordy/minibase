OPENSCADFLAGS = -q
TARGETS = $(shell scripts/make-targets.sh)
include $(wildcard out/.cache/*.deps)

all: ${TARGETS}

.SECONDEXPANSION:
out/%.stl: build=$(subst key-,,$(subst .stl,,$(@F)))
out/%.stl: $$(*D).scad
	@mkdir -p out/$(*D)
	@mkdir -p out/.cache/$(*D)
	openscad $(OPENSCADFLAGS) -m make -D build='"$(build)"' -o '$@' -d 'out/.cache/$(*D)/$(@F).deps' '$<'

.PHONY: autoplate
autoplate: out/.autoplate.ini
	@python scripts/autoplate/__main__.py

out/.autoplate.ini: ${TARGETS}
	scripts/autoplate-config.sh

.PHONY: clean
clean:
	@rm -r out
