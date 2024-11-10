AUTOMAKE_OPTIONS = foreign
bin_PROGRAMS = myprogram
myprogram_SOURCES = main.cpp funcA.cpp funcA.h

PACKAGE = myprogram
VERSION = 1.0
PACKAGE_BUGREPORT = mazurenkomyroslav@gmail.com

CTRLF_DIR = $(CURDIR)/debian
CTRLF_NAME = $(CTRLF_DIR)/control

.PHONY: deb debug

deb:
    echo "Package: $(PACKAGE)" > deb/DEBIAN/control
    echo "Version: $(VERSION)" >> deb/DEBIAN/control
    echo "Architecture: all" >> deb/DEBIAN/control
    echo "Maintainer: $(PACKAGE_BUGREPORT)" >> deb/DEBIAN/control
    echo "Description: MyProgram does amazing things" >> deb/DEBIAN/control


debug:
	@echo "${PACKAGE}"
	@echo "${VERSION}"
	@echo "${PACKAGE_BUGREPORT}"
