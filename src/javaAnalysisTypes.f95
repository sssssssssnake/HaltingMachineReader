module javaAnalysisTypes
    

    private
    public :: JavaFile
    type :: JavaFile
        character(:), allocatable :: relativeFilePath
        character(:), allocatable :: className
        character(:), allocatable :: packageName
        character(:), allocatable, dimension(:) :: imports

        contains
        procedure :: initializeJavaFile
        procedure :: printJavaFile
    end type JavaFile

    contains 

    subroutine initializeJavaFile(this, relativeFilePath, className, packageName, imports)
        class(JavaFile), intent(inout) :: this
        character(:), allocatable, intent(in) :: relativeFilePath
        character(:), allocatable, intent(in) :: className
        character(:), allocatable, intent(in) :: packageName
        character(:), allocatable, dimension(:), intent(in) :: imports

        this%relativeFilePath = relativeFilePath
        this%className = className
        this%packageName = packageName
        this%imports = imports
    end subroutine initializeJavaFile

    subroutine printJavaFile(this)
        class(JavaFile), intent(in) :: this

        print *, "JavaFile: ", this%relativeFilePath
        print *, "Class Name: ", this%className
        print *, "Package Name: ", this%packageName
        print *, "Imports: "
        do i = 1, size(this%imports)
            print *, trim(this%imports(i))
        end do
    end subroutine printJavaFile

    

end module javaAnalysisTypes