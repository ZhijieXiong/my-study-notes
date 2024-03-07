main: main.o tool1.o tool2.o
	gcc -o main.exe main.o tool1.o tool2.o
main.o: main.c tool1.h tool2.h
	gcc -w -c main.c
tool1.o: tool1.c tool1.h
	gcc -w -c tool1.c
tool2.o: tool2.c tool2.h
	gcc -w -c tool2.c
clean:
	rm -rf *.o *.exe

