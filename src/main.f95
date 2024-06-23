

program HelloWorld
    use fileManager, only: readFile
    use JavaFilesAnalyzer, only: findImportantJavaFiles, setMainFileContent, setSourceDirectory
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:)
    integer :: endingLine

    

    myFilePath = "javacode/Main.java"

    ! Read the file
    call readFile(myFilePath, myFileContents, endingLine)

    ! Analyze the file
    call setMainFileContent(myFileContents)
    call setSourceDirectory(myFilePath)
    call findImportantJavaFiles(endingLine)


    ! Deallocate the memory
    deallocate(myFileContents)
    deallocate(myFilePath)
end program HelloWorld
