module JavaFilesAnalyzer
    ! use fileManager, only: readFile
    implicit none
    
    private
    public :: setMainFileContent

    character(:), allocatable, dimension(:) :: javaImports
    character(:), allocatable, dimension(:) :: javaPackages

    character(:), dimension(:), allocatable :: mainFileContent

    
    contains

    subroutine findImportantJavaFiles()

    end subroutine findImportantJavaFiles

    subroutine setMainFileContent(fileContent)
        character(:), dimension(:), allocatable, intent(in) :: fileContent
        mainFileContent = fileContent
    end subroutine setMainFileContent

    

    
end module JavaFilesAnalyzer