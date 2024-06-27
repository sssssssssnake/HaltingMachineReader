module analyzeJavaProject
    use javaAnalysisTypes
    implicit none
    
    type(JavaFile), pointer :: mainFile
    type(JavaFile), dimension(:), allocatable, target :: allFiles
    integer :: numFiles


    contains
    subroutine SetMainFile(file)
        type(JavaFile), target, intent(in) :: file
        mainFile => file
    end subroutine SetMainFile





end module analyzeJavaProject