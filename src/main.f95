

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

    call readFile(myFilePath, myFileContents, endingLine)
    call printMainFileContent(endingLine)
    
    deallocate(myFilePath)
end program HelloWorld
