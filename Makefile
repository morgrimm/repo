#!/bin/sh

all: Release
.PHONY: debs Packages Packages.bz2 Release

depictions:
	./gen/depictions

debs:
	./gen/debs

Release: Packages Packages.bz2
	$(eval SIZE1 := $(shell wc -c Packages | sed 's/[[:space:]].*//'))
	$(eval SIZE2 := $(shell wc -c Packages.bz2 | sed 's/[[:space:]].*//'))
	@cp Release_ $@

	@echo MD5Sum: >> $@
	@echo " `md5sum Packages | sed "s/  / $(SIZE1) /"`" >> $@
	@echo " `md5sum Packages.bz2 | sed "s/  / $(SIZE2) /"`" >> $@

	@echo SHA1: >> $@
	@echo " `sha1sum Packages | sed "s/  / $(SIZE1) /"`" >> $@
	@echo " `sha1sum Packages.bz2 | sed "s/  / $(SIZE2) /"`" >> $@

	@echo SHA256: >> $@
	@echo " `sha256sum Packages | sed "s/  / $(SIZE1) /"`" >> $@
	@echo " `sha256sum Packages.bz2 | sed "s/  / $(SIZE2) /"`" >> $@

Packages: debs
	@dpkg-scanpackages -m . /dev/null > Packages

Packages.bz2: Packages
	@bzip2 -fk $^

clean:
	@rm -rf Packages Packages.bz2 Release ./debs/* &> /dev/null
