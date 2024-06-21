default: run

run: build
	@echo "Running the program..."
	@./program
	@#clean
	@make clean

build: clean
	@# compile the program
	@echo "Compiling the program..."
	@gfortran -o program src/main.f95

clean:
	@# if the file exists, remove it
	@if [ -f program ]; then rm program; fi
	@if [ -f *.mod ]; then rm *.mod; fi
	@if [ -f *.10 ]; then rm *.10; fi