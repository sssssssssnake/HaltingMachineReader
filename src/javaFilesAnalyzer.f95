module JavaFilesAnalyzer
    use fileManager, only: containsString, getTextBetweenStrings
    implicit none
    
    private
    public :: setMainFileContent, findImportantJavaFiles

    character(:), allocatable :: sourceDirectory
    character(:), allocatable, dimension(:) :: javaImports
    character(:), allocatable, dimension(:) :: javaPackages

    character(:), dimension(:), allocatable :: mainFileContent

    type :: JavaFile
        character(:), allocatable :: relativeFilePath
        character(:), allocatable :: className
        character(:), allocatable :: packageName
        character(:), allocatable, dimension(:) :: imports
    end type JavaFile

    
    contains

    !> Finds the important java files.
    !! @param lastLine The last line of the main file.
    !! 
    !! This subroutine finds the important java files in the main file.
    !! It looks for the number of imports and the package name.
    subroutine findImportantJavaFiles(lastLine)
        integer, intent(in) :: lastLine
        integer :: i, keyPathsCounter
        integer :: nubmerOfImports, packageLine, packageLineTrue
        logical :: hasImport, hasPackage
        character(:), allocatable :: keyword, packageKeyword
        character(:), allocatable :: lineContent
        character(:), allocatable :: keyPaths(:)
        character(:), allocatable :: javaPackageParsed, semiColon, packageContent

        nubmerOfImports = 0
        keyPathsCounter = 1
        keyword = "import "
        packageKeyword = "package "
        semiColon = ";"
        hasPackage = .false.

        
        do i = 1, lastLine
            lineContent = mainFileContent(i)
            ! use the containsString function from the fileManager module
            hasImport = containsString(keyword, lineContent)
            if ( hasImport ) then
                nubmerOfImports = nubmerOfImports + 1
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

        print *, "number of imports: ", nubmerOfImports
        print *, "hasPackage: ", packageLineTrue
        ! now to look at the important filePaths
        allocate(character(256) :: keyPaths(nubmerOfImports + packageLineTrue))

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

        print *, "Length of keyPaths: ", size(keyPaths)

        do i = 1, size(keyPaths)
            print *, trim(keyPaths(i))
        end do


        if ( hasPackage ) then
            allocate(character(256) :: javaImports(nubmerOfImports))
            do i= 1, nubmerOfImports
                javaImports(i) = keyPaths(i)
            end do
        end if

        ! print the imports and paths for debugging
        print *, "Length of javaImports: ", size(javaImports)
        do i = 1, size(javaImports)
            print *, trim(javaImports(i))
        end do

        print *, "Length of javaPackages: ", size(javaPackages)
        do i = 1, size(javaPackages)
            print *, trim(javaPackages(i))
        end do

        packageContent = javaPackages(1)
        packageKeyword = "package "
        javaPackageParsed = getTextBetweenStrings(packageContent, packageKeyword, semiColon)
        print *, "parsed package: '", javaPackageParsed, "'"



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