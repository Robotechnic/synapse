VERSION := $(shell sed -n 's/^version\s*=\s*"\(.*\)"/\1/p' typst.toml)
PACKAGE_NAME := $(shell sed -n 's/^name\s*=\s*"\(.*\)"/\1/p' typst.toml)
TARGET_DIR=./$(PACKAGE_NAME)/$(VERSION)

check:
	typst compile ./lib.typ
	rm ./lib.pdf

link :
	mkdir -p ~/.cache/typst/packages/preview/$(PACKAGE_NAME)
	ln -s "$(CURDIR)" ~/.cache/typst/packages/preview/$(PACKAGE_NAME)/$(VERSION)

clean-link:
	rm -rf ~/.cache/typst/packages/preview/$(PACKAGE_NAME)

module:
	mkdir -p $(TARGET_DIR)
	mkdir -p $(TARGET_DIR)/src
	cp ./typst.toml $(TARGET_DIR)/typst.toml
	cp ./LICENSE $(TARGET_DIR)/
	cp ./lib.typ $(TARGET_DIR)/
	cp -r ./src/* $(TARGET_DIR)/src/
	sed 's|https://typst.app/universe/package/$(PACKAGE_NAME)|https://github.com/Typsium/$(PACKAGE_NAME)|g' ./README.md > $(TARGET_DIR)/README.md
	sed -i "s/\/main\//\/$(VERSION)\//g" $(TARGET_DIR)/README.md
	sed -E -i 's/:[0-9]+\.[0-9]+\.[0-9]+/:$(VERSION)/g' $(TARGET_DIR)/README.md
	

manual:
	typst compile ./doc/manual.typ --root .

watch:
	typst watch ./doc/manual.typ --root .

test:
	tt run -F -j15

format:
	typstyle -i $$(find . -type f -name "*.typ")
