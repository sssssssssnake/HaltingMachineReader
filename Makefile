default: run

run: build
	@echo "Running the program..."
	@./program
	@#clean
	@$(MAKE) clean

build: clean
	@# compile the program
	@echo "Compiling the program..."
	@gfortran -c src/javaAnalysisTypes.f95
	@gfortran -c src/fileManage.f95
	@gfortran -c src/javaFilesAnalyzer.f95
	@gfortran -o program src/main.f95 fileManage.o javaFilesAnalyzer.o javaAnalysisTypes.o -g

clean:
	@# if the file exists, remove it
	@ echo "Cleaning up..."
	@if [ -f filemanager.mod ]; then rm -f filemanager.mod; fi
	@if [ -f program ]; then rm program; fi
	@if [ -f fileManage.o ]; then rm fileManage.o; fi
	@if [ -f javaFilesAnalyzer.o ]; then rm javaFilesAnalyzer.o; fi
	@if [ -f javafilesanalyzer.mod ]; then rm -f javafilesanalyzer.mod; fi
	@if [ -f javaanalysistypes.mod ]; then rm -f javaanalysistypes.mod; fi
	@if [ -f javaAnalysisTypes.o ]; then rm -f javaAnalysisTypes.o; fi
	@if [ -f file10 ]; then rm file10; fi


runkeep: build
	@echo "Running the program..."
	@./program

debug: build
	@echo "Running the program in debug mode..."
	@gdb ./program
	@#clean
	@$(MAKE) clean