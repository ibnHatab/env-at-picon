
SRCDIR=.
BINDIR=.
TARGET=$(BINDIR)/test.exe 

CC=gcc
CXX=g++
CXXLINK=g++

DEFS=
CXXFLAGS= -g
INCLUDES= -I$(SRCDIR)/include
LDFLAGS=
CXXCOMPILE= $(CXX) $(DEFS) $(INCLUDES) $(CXXFLAGS) 

SOURCES=$(wildcard *.cpp)
OBJECTS=$(patsubst %.cpp,%.o,$(wildcard *.cpp))

all: $(TARGET)

$(TARGET): $(OBJECTS)
	@echo 'Link $(OBJECTS) > $@ '
	$(CXXLINK) $(LDFLAGS) -o $@ $(OBJECTS)

%.o: %.cpp %.h
	@echo 'Compile $(CXXCOMPILE) -c $<'
	$(CXXCOMPILE) -c $<

depend:
	makedepend -- $(CXXFLAGS) -- $(SOURCES)

install:
	-cp $(TARGET) $(BINDIR)

clean:
	-rm -f *.o core *.core $(TARGET)
