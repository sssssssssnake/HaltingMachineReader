

program HelloWorld
    use fileManager, only: readFile
    use JavaFilesAnalyzer, only: findImportantJavaFiles, setMainFileContent
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:)
    integer :: endingLine

    

    myFilePath = "../test.txt"

    ! Read the file
    call readFile(myFilePath, myFileContents, endingLine)

    ! Analyze the file
    call setMainFileContent(myFileContents)
    call findImportantJavaFiles(endingLine)


    ! Deallocate the memory
    deallocate(myFileContents)
    deallocate(myFilePath)
end program HelloWorld
