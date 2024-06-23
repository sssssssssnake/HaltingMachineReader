

program HelloWorld
    use fileManager, only: readFile, getTextBetweenStrings
    use JavaFilesAnalyzer, only: findImportantJavaFiles, setMainFileContent, setSourceDirectory
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:)
    character(:), allocatable :: testParse
    character(:), allocatable :: keyword1, keyword2
    integer :: endingLine

    

    myFilePath = "javacode/Main.java"
    keyword1 = "javacode/"
    keyword2 = ".java"
    testParse = getTextBetweenStrings(myFilePath, keyword1, keyword2)
    print *, testParse

    ! ! Read the file
    ! call readFile(myFilePath, myFileContents, endingLine)

    ! ! Analyze the file
    ! call setMainFileContent(myFileContents)
    ! call setSourceDirectory(myFilePath)
    ! call findImportantJavaFiles(endingLine)
    


    ! ! Deallocate the memory
    ! deallocate(myFileContents)
    ! deallocate(myFilePath)
end program HelloWorld
