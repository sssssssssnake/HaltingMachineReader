module JavaFilesAnalyzer
    use fileManager, only: containsString
    implicit none
    
    private
    public :: setMainFileContent, findImportantJavaFiles, printMainFileContent

    character(:), allocatable, dimension(:) :: javaImports
    character(:), allocatable, dimension(:) :: javaPackages

    character(:), dimension(:), allocatable :: mainFileContent

    
    contains

    !> Finds the important java files.
    !! @param lastLine The last line of the main file.
    !! 
    !! This subroutine finds the important java files in the main file.
    !! It looks for the number of imports and the package name.
    subroutine findImportantJavaFiles(lastLine)
        integer, intent(in) :: lastLine
        integer :: i
        integer :: nubmerOfImports, packageLine, packageLineTrue
        logical :: hasImport, hasPackage
        character(:), allocatable :: keyword
        character(:), allocatable :: lineContent
        character(:), allocatable :: keyPaths(:)

        nubmerOfImports = 0
        keyword = "import"

        
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
            if ( index(lineContent, "package") > 0 ) then
                javaPackages = lineContent
                packageLine = i
                hasPackage = .true.
                exit lookForPackages
            end if
        end do lookForPackages

        if ( packageLine .ne. 0 ) then
            packageLineTrue = 1
        end if

        ! now to look at the important filePaths
        allocate(character(100) :: keyPaths(nubmerOfImports + packageLineTrue))




        print *, "number of imports: ", nubmerOfImports
        print *, "location of javaPackages: ", packageLine

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

    

    
end module JavaFilesAnalyzer