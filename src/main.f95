

program HelloWorld
    use fileManager, only: readFile, replaceCharacterInString
    use JavaFilesAnalyzer, only: findImportantJavaFiles, setMainFileContent, setSourceDirectory
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:)
    character(:), allocatable :: testParse
    integer :: endingLine

    

    myFilePath = "javacode/Main.java"

    testParse = replaceCharacterInString(myFilePath, "/", ".")
    print *, testParse
    
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
