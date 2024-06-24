module JavaFilesAnalyzer
    use fileManager, only: containsString, getTextBetweenStrings,&
     replaceCharacterInString, getFilenameFromPathNoExtention
    use javaAnalysisTypes, only: JavaFile
    implicit none
    
    private
    public :: setMainFileContent, findImportantJavaFiles, setSourceDirectory, mainFile

    character(:), allocatable :: sourceDirectory
    character(:), allocatable, dimension(:) :: javaImports
    character(:), allocatable, dimension(:) :: javaPackages

    character(:), dimension(:), allocatable :: mainFileContent
    
    
    
    type(JavaFile) :: mainFile
    
    contains

    !> Finds the important java files.
    !! @param lastLine The last line of the main file.
    !! 
    !! This subroutine finds the important java files in the main file.
    !! It looks for the number of imports and the package name.
    subroutine findImportantJavaFiles(lastLine)
        integer, intent(in) :: lastLine
        integer :: i, keyPathsCounter
        integer :: numberOfImports, packageLine, packageLineTrue
        logical :: hasImport, hasPackage
        character(:), allocatable :: keyword, packageKeyword
        character(:), allocatable :: lineContent
        character(:), allocatable :: keyPaths(:)
        character(:), allocatable :: javaPackageParsed, semiColon, packageContent, mainClassName
        character(:), allocatable :: parseFilePathKeyword1, parseFilePathKeyword2
        character(:), allocatable :: blankString

        numberOfImports = 0
        keyPathsCounter = 1
        keyword = "import "
        packageKeyword = "package "
        semiColon = ";"
        hasPackage = .false.
        parseFilePathKeyword1 = "/"
        parseFilePathKeyword2 = "."
        blankString = ""

        
        do i = 1, lastLine
            lineContent = mainFileContent(i)
            ! use the containsString function from the fileManager module
            hasImport = containsString(keyword, lineContent)
            if ( hasImport ) then
                numberOfImports = numberOfImports + 1
            end if
        end do

        packageLine = 0
        lookForPackages: do i = 1, lastLine
            lineContent = mainFileContent(i)
            if ( containsString(packageKeyword, lineContent) ) then
                allocate(character(256) :: javaPackages(1))
                javaPackages(1) = lineContent
                packageLine = i
                hasPackage = .true.
                exit lookForPackages
            end if
        end do lookForPackages

        if ( packageLine .ne. 0 ) then
            packageLineTrue = 1
        end if

        print *, "number of imports: ", numberOfImports
        print *, "hasPackage: ", packageLineTrue
        ! now to look at the important filePaths
        allocate(character(256) :: keyPaths(numberOfImports + packageLineTrue))

        do i = 1, lastLine
            lineContent = mainFileContent(i)
            hasImport = containsString(keyword, lineContent)
            if ( hasImport ) then
                keyPaths(keyPathsCounter) = lineContent
                keyPathsCounter = keyPathsCounter + 1
            end if
        end do

        if ( packageLineTrue .eq. 1 ) then
            keyPaths(keyPathsCounter) = javaPackages(1)
        end if



        if ( hasPackage ) then
            allocate(character(256) :: javaImports(numberOfImports))
            do i= 1, numberOfImports
                javaImports(i) = keyPaths(i)
            end do
            packageContent = javaPackages(1)
            packageKeyword = "package "
            javaPackageParsed = getTextBetweenStrings(packageContent, packageKeyword, semiColon)
            javaPackageParsed = trim(adjustl(replaceCharacterInString(javaPackageParsed, ".", "/")))
            allocate(character(256) :: mainClassName)
            mainClassName = getFilenameFromPathNoExtention(sourceDirectory)
            ! use the initializeJavaFile from the JavaFile module
            call mainFile%initializeJavaFile(sourceDirectory, mainClassName,&
             javaPackageParsed, javaImports)
            call mainFile%resolveImportsToPaths
            print *, "Printing the mainFile"
            call mainFile%printJavaFile
        else if ( .not. hasPackage ) then
            allocate(character(256) :: javaImports(numberOfImports))
            do i= 1, numberOfImports
                javaImports(i) = keyPaths(i)
            end do
            ! use the initializeJavaFile from the JavaFile module
            mainClassName = getFilenameFromPathNoExtention(sourceDirectory)
            call mainFile%initializeJavaFile(sourceDirectory, mainClassName, blankString, javaImports)
            call mainFile%resolveImportsToPaths
            print *, "Printing the mainFile"
            call mainFile%printJavaFile
                
        end if

        

        ! deallocate everything the subroutine has allocated
        deallocate(keyword)
        deallocate(packageKeyword)
        deallocate(lineContent)
        deallocate(keyPaths)
        ! deallocate(javaPackageParsed)
        deallocate(semiColon)
        ! deallocate(packageContent)
        deallocate(parseFilePathKeyword1)
        deallocate(parseFilePathKeyword2)

    end subroutine findImportantJavaFiles

    !> Sets the content of the main file.
    !! @param fileContent The content of the main file.
    subroutine setMainFileContent(fileContent)
        character(:), dimension(:), allocatable, intent(in) :: fileContent
        mainFileContent = fileContent
    end subroutine setMainFileContent

    subroutine printMainFileContent(endLine)
        integer, intent(in) :: endLine
        integer :: i
        do i = 1, endLine
            print *, trim(mainFileContent(i))
        end do
        print *, "location of main filecontents: ", loc(mainFileContent)
    end subroutine printMainFileContent

    subroutine setSourceDirectory(directory)
        character(:), allocatable, intent(in) :: directory
        sourceDirectory = directory
    end subroutine setSourceDirectory

     
end module JavaFilesAnalyzer