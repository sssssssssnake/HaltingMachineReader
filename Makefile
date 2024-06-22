default: run

run: build
	@echo "Running the program..."
	@./program
	@#clean
	@$(MAKE) clean

build: clean
	@# compile the program
	@echo "Compiling the program..."
	@gfortran -c src/filemanage.f95
	@gfortran -c src/javaFilesAnalyzer.f95
	@gfortran -o program src/main.f95 filemanage.o javaFilesAnalyzer.o

clean:
	@# if the file exists, remove it
	@ echo "Cleaning up..."
	@if [ -f *.mod ]; then rm *.mod; fi
	@if [ -f program ]; then rm program; fi
	@if [ -f *.o ]; then rm *.o; fi
	@if [ -f *.10 ]; then rm *.10; fi