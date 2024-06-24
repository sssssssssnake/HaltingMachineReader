

program HelloWorld
    use fileManager, only: readFile, replaceCharacterInString, readJavaFile
    use JavaFilesAnalyzer, only: findImportantJavaFiles, setMainFileContent,&
     setSourceDirectory, mainFile
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:), testFileContents(:)
    character(:), allocatable :: combinedDirectory
    integer :: endingLine, i

    

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
    end do


    ! Deallocate the memory
    deallocate(myFileContents)
    deallocate(myFilePath)
end program HelloWorld
