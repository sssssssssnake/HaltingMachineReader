module javaAnalysisTypes
    use fileManager, only: replaceCharacterInString, getTextBetweenStrings, removeSubstring
    implicit none
    

    private
    public :: JavaFile
    type :: JavaFile
        character(:), allocatable :: relativeFilePath
        character(:), allocatable :: className
        character(:), allocatable :: packageName
        character(:), allocatable, dimension(:) :: imports
        type(Import), allocatable, dimension(:) :: importObjects

        contains
        procedure :: initializeJavaFile
        procedure :: printJavaFile
        procedure :: resolveImportsToPaths
    end type JavaFile

    type :: Import
        character(:), allocatable :: originalImportText
        logical :: isStatic
        logical :: isWildcard
        character(:), allocatable :: importPath
        character(:), allocatable :: importName

    end type Import

    type :: TokenizedJavaFile
        character(:), allocatable :: relativeFilePath
        character(:), allocatable :: className
        character(:), allocatable :: packageName
        type(Import), allocatable, dimension(:) :: imports
        integer, allocatable, dimension(:) :: importLines
        character(:), allocatable, dimension(:) :: codeLines
        character(:), allocatable, dimension(:, :) :: tokenizedCodeLines
        contains 
        procedure :: initializeTokenizedJavaFile
        ! procedure :: printTokenizedJavaFile
        ! procedure :: tokenizeCodeLines
    end type TokenizedJavaFile

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
            print *, "'", trim(this%importObjects(i)%importPath), "'"
            print *, "Is Static: ", this%importObjects(i)%isStatic, " Is Wildcard: ",&
             this%importObjects(i)%isWildcard
        end do
    end subroutine printJavaFile


    !> Converts the imports to paths and names
    !! @param this The JavaFile object to be initialized you don't need to pass this in,
    !! it's done automatically by the compiler
    subroutine resolveImportsToPaths(this)
        class(JavaFile), intent(inout) :: this
        character(:), allocatable :: workingImport
        character(:), allocatable :: keyword1, keyword2
        character(:), allocatable :: javaDotKeyword1, javaDotKeyword2
        character(:), allocatable :: staticKeyword, staticKeyword2
        integer :: i
        i = 1
        keyword1 = "import "
        keyword2 = ";"
        javaDotKeyword1 = "."
        javaDotKeyword2 = ";"
        staticKeyword = "static"
        staticKeyword2 = "/"

        print *, "Converting imports to paths"
        allocate(this%importObjects(size(this%imports)))

        do i = 1, size(this%imports)
            workingImport = this%imports(i)
            workingImport = getTextBetweenStrings(workingImport, keyword1, keyword2)
            this%importObjects(i)%originalImportText = workingImport
            this%importObjects(i)%isWildcard = index(workingImport, "*") .gt. 0
            this%importObjects(i)%isStatic = index(workingImport, "static") .gt. 0
            if (this%importObjects(i)%isWildcard) then
                this%importObjects(i)%importPath = trim(adjustl(replaceCharacterInString(workingImport,&
                 ".", "/")))
                this%importObjects(i)%importName = ""
            else
                this%importObjects(i)%importPath = trim(adjustl(replaceCharacterInString(workingImport,&
                 ".", "/"))) // ".java"
                this%importObjects(i)%importName = getTextBetweenStrings(workingImport, javaDotKeyword1,&
                 javaDotKeyword2)
            end if
            if (this%importObjects(i)%isStatic) then
                this%importObjects(i)%importPath = trim(adjustl(removeSubstring(workingImport,&
                 staticKeyword)))
            end if
        end do

    end subroutine resolveImportsToPaths

    !> Is essentially a constructor for the TokenizedJavaFile type
    !! @param this The TokenizedJavaFile object to be initialized you don't need to pass this in, it's done automatically by the compiler
    !! @param relativeFilePath The relative file path of the Java file
    !! @param className The name of the class in the Java
    !! @param packageName The package name of the Java file
    !! @param imports The imports of the Java file
    !! @param importLines The import lines of the Java file
    !! @param codeLines The code lines of the Java file
    subroutine initializeTokenizedJavaFile(this, relativeFilePath, className, packageName, imports, importLines, codeLines)
        class(TokenizedJavaFile), intent(inout) :: this
        character(:), allocatable, intent(in) :: relativeFilePath
        character(:), allocatable, intent(in) :: className
        character(:), allocatable, intent(in) :: packageName
        type(Import), allocatable, dimension(:), intent(in) :: imports
        integer, allocatable, dimension(:), intent(in) :: importLines
        character(:), allocatable, dimension(:), intent(in) :: codeLines

        this%relativeFilePath = relativeFilePath
        this%className = className
        this%packageName = packageName
        this%imports = imports
        this%importLines = importLines
        this%codeLines = codeLines
    end subroutine initializeTokenizedJavaFile

    

end module javaAnalysisTypes