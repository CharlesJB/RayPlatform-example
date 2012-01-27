MPICXX=mpicxx

DIRECTORY := $(shell pwd)

RAY_APPLICATION_SCRIPTS=$(DIRECTORY)/scripting
RAY_PLATFORM=$(DIRECTORY)/RayPlatform
J=1

OPTIONS=
#-D ASSERT -D CONFIG_DEBUG_CORE -D CONFIG_SWITCHMAN_VERBOSITY

all:
	echo $(DIRECTORY)

	# compile the application
	$(MPICXX) program.cpp -c -o program.o -I . -I $(RAY_APPLICATION_SCRIPTS) -I $(RAY_PLATFORM)
	$(MPICXX) Test.cpp -c -o Test.o -I . -I $(RAY_APPLICATION_SCRIPTS) -I $(RAY_PLATFORM)
	$(MPICXX) Test_adapters.cpp -c -o Test_adapters.o -I . -I $(RAY_APPLICATION_SCRIPTS) -I $(RAY_PLATFORM)

	# compile the platform
	cd $(RAY_PLATFORM); make clean; make CXXFLAGS="-O3 -g $(OPTIONS)" RAY_APPLICATION_SCRIPTS=$(RAY_APPLICATION_SCRIPTS) -j $(J)
	
	# link them
	$(MPICXX) program.o Test.o Test_adapters.o $(RAY_PLATFORM)/libRayPlatform.a -o program

