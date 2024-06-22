module JavaFilesAnalyzer
    ! use fileManager, only: readFile
    implicit none
    
    private
    public :: setMainFileContent, findImportantJavaFiles, printMainFileContent

    character(:), allocatable, dimension(:) :: javaImports
    character(:), allocatable, dimension(:) :: javaPackages

    character(:), dimension(:), allocatable :: mainFileContent

    
    contains

    subroutine findImportantJavaFiles()

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