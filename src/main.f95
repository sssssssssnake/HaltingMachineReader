

program HelloWorld
    use fileManager, only: readFile
    use JavaFilesAnalyzer, only: printMainFileContent
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:)
    integer :: endingLine

    ! interface for readFile subroutine
    

    ! Main program
    myFilePath = "javacode/Main.java"

    call readFile(myFilePath, myFileContents, endingLine)

    deallocate(myFileContents)
    deallocate(myFilePath)
end program HelloWorld
