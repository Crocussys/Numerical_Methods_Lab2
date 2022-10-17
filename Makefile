all: main.o
	g++ main.o -o Lab2
	
main.o: main.cpp
	g++ -c main.cpp
	
clean:
	rm -rf *.o