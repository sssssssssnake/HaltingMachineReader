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
    subroutine findImportantJavaFiles(lastLine)
        integer, intent(in) :: lastLine
        integer :: i
        integer :: nubmerOfImports, packageLine
        logical :: hasImport
        character(:), allocatable :: keyword
        character(:), allocatable :: lineContent

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

        lookForPackages: do i = 1, lastLine
            lineContent = mainFileContent(i)
            if ( index(lineContent, "package") > 0 ) then
                javaPackages = lineContent
                packageLine = i
                exit lookForPackages
            end if
        end do lookForPackages



        print *, "number of imports: ", nubmerOfImports
        print *, "location of javaPackages: "

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