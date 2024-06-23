module javaAnalysisTypes
    use fileManager, only: replaceCharacterInString, getTextBetweenStrings
    implicit none
    

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
        procedure :: convertImportsToPaths
    end type JavaFile

    contains 

    !> Is essentially a constructor for the JavaFile type
    !! @param this The JavaFile object to be initialized you don't need to pass this in, it's done automatically by the compiler
    !! @param relativeFilePath The relative file path of the Java file
    !! @param className The name of the class in the Java
    !! @param packageName The package name of the Java file
    !! @param imports The imports of the Java file
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
        integer :: i

        print *, "JavaFile: ", this%relativeFilePath
        print *, "Class Name: ", this%className
        print *, "Package Name: ", this%packageName
        print *, "Imports: "
        do i = 1, size(this%imports)
            print *, trim(this%imports(i))
        end do
    end subroutine printJavaFile

    subroutine convertImportsToPaths(this)
        class(JavaFile), intent(inout) :: this
        character(:), allocatable :: workingImport
        character(:), allocatable :: keyword1, keyword2
        integer :: i
        i = 1
        keyword1 = "import "
        keyword2 = ";"

        ! workingImport = this%imports(i)
        ! workingImport = getTextBetweenStrings(workingImport, keyword1, keyword2)

        ! print *, "Working Import: ", workingImport
        ! print *, "Working Import: ", replaceCharacterInString(workingImport, ".", "/") // ".java"

        do i = 1, size(this%imports)
            workingImport = this%imports(i)
            workingImport = getTextBetweenStrings(workingImport, keyword1, keyword2)
            this%imports(i) = replaceCharacterInString(workingImport, ".", "/") // ".java"
        end do

    end subroutine convertImportsToPaths

    

end module javaAnalysisTypes