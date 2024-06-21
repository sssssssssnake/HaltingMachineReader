default: run

run: build
	@./program

build: clean
	@gfortran -o program main.f95

clean:
	@# if the file exists, remove it
	@if [ -f program ]; then rm program; fi