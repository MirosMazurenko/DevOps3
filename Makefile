CXX = g++
CXXFLAGS = -Wall -std=c++11
TARGET = funcA
all: $(TARGET)
$(TARGET): main.o funcA.o
	$(CXX) $(CXXFLAGS) -o $(TARGET) main.o funcA.o
main.o: main.cpp funcA.h
	$(CXX) $(CXXFLAGS) -c main.cpp
funcA.o: funcA.cpp funcA.h
	$(CXX) $(CXXFLAGS) -c funcA.cpp
clean:
	rm -f *.o $(TARGET)
