

program HelloWorld
    use fileManager, only: readFile
    use JavaFilesAnalyzer, only: findImportantJavaFiles, printMainFileContent
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:)
    integer :: printCounter, endingLine

    ! interface for readFile subroutine
    

    ! Main program
    myFilePath = "src/main.f95"
    print *, "location of myFileContents1: ", loc(myFileContents)

    call readFile(myFilePath, myFileContents, endingLine)
    print *, "location of myFileContents2: ", loc(myFileContents)
    call printMainFileContent(endingLine)
    print *, "location of myFileContents: ", loc(myFileContents)
    
    deallocate(myFilePath)
end program HelloWorld
