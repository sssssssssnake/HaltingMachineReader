

program HelloWorld
    use fileManager, only: readFile, replaceCharacterInString
    use JavaFilesAnalyzer, only: findImportantJavaFiles, setMainFileContent, setSourceDirectory, mainFile
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:)
    character(:), allocatable :: testParse
    integer :: endingLine

    

    myFilePath = "FunTest.java"

    
    ! Read the file
    call readFile(myFilePath, myFileContents, endingLine)

    ! Analyze the file
    call setMainFileContent(myFileContents)
    call setSourceDirectory(myFilePath)
    call findImportantJavaFiles(endingLine)

    ! Test the file
    if (mainFile%packageName .eq. "") then
        testParse = mainFile%className // ".java"
    else if (allocated(mainFile%className)) then
        testParse = mainFile%packageName // "/" // mainFile%className // ".java"
    end if

    print *, testParse
    if (testParse .ne. myFilePath) then
        print *, "You are in the wrong directory! Please go to the root directory of the Java project."
    else if ( testParse .eq. myFilePath ) then
        print *, "Welcome to the root directory!"
    end if


    ! Deallocate the memory
    deallocate(myFileContents)
    deallocate(myFilePath)
end program HelloWorld
