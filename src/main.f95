

program HelloWorld
    use fileManager, only: readFile, replaceCharacterInString, readJavaFile
    use JavaFilesAnalyzer, only: findImportantJavaFiles, setMainFileContent,&
     setSourceDirectory, mainFile, javaFiles
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:), testFileContents(:)
    character(:), allocatable :: combinedDirectory
    integer :: endingLine, i, characterCounter, lineCounter

    

    myFilePath = "javacode/Main.java"

    
    ! Read the file
    call readFile(myFilePath, myFileContents, endingLine)

    ! Analyze the file
    call setMainFileContent(myFileContents)
    call setSourceDirectory(myFilePath)
    call findImportantJavaFiles(endingLine)

    ! Test the file
    if (mainFile%packageName .eq. "") then
        print *, "The package name is empty. ", mainFile%className
        combinedDirectory = mainFile%className // ".java"
    else if (allocated(mainFile%className)) then
        print *, "The package name is not empty. ", mainFile%packageName
        combinedDirectory = mainFile%packageName // "/" // mainFile%className // ".java"
    end if
    print *, "The classname is: ", mainFile%className

    print *, combinedDirectory
    if (combinedDirectory .ne. myFilePath) then
        print *, "You are in the wrong directory! Please go to the root directory of the Java project."
    else if ( combinedDirectory .eq. myFilePath ) then
        print *, "Welcome to the root directory!"
    end if


    call readJavaFile(myFilePath, testFileContents, endingLine)
    do i = 1, endingLine
        print *, trim(testFileContents(i)), len(trim(testFileContents(i)))
        characterCounter = characterCounter + len(trim(adjustl(testFileContents(i))))
        lineCounter = lineCounter + 1
    end do
    print *, "The number of characters in the file is: ", characterCounter
    print *, "The number of lines in the file is: ", lineCounter

    allocate(javaFiles(1))
    javaFiles(1)%className = mainFile%className
    javaFiles(1)%packageName = mainFile%packageName
    javaFiles(1)%codeLines = testFileContents

    call javaFiles(1)%readJavaCodeBlocks()


    ! Deallocate the memory
    deallocate(myFileContents)
    deallocate(myFilePath)
end program HelloWorld
