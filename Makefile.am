AUTOMAKE_OPTIONS = foreign subdir-objects
bin_PROGRAMS = myprogram
myprogram_SOURCES = main.cpp funcA.cpp funcA.h
check_PROGRAMS = test
test_SOURCES = tests/test.cpp funcA.cpp
PACKAGE = myprogram
VERSION = 1.0
PACKAGE_BUGREPORT = mazurenkomyroslav@gmail.com

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

check: test
	@./test
