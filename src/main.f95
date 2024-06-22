

program HelloWorld
    use fileManager, only: readFile
    use JavaFilesAnalyzer, only: findImportantJavaFiles
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:)
    integer :: endingLine

    ! interface for readFile subroutine
    

    ! Main program
    myFilePath = "src/main.f95"

    call readFile(myFilePath, myFileContents, endingLine)

    deallocate(myFileContents)
    deallocate(myFilePath)
end program HelloWorld
