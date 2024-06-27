module javaAnalysisTypes
    use fileManager, only: replaceCharacterInString, getTextBetweenStrings, removeSubstring
    implicit none
    

    private
    public :: JavaFile, PrepareTokeizedFile
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

    type :: PrepareTokeizedFile
        character(:), allocatable :: relativeFilePath
        character(:), allocatable :: className
        character(:), allocatable :: packageName
        type(Import), allocatable, dimension(:) :: imports
        integer, allocatable, dimension(:) :: importLines
        character(:), allocatable, dimension(:) :: codeLines
        character(:), allocatable :: preTokenizedCode
        contains 
        procedure :: initializePrepareTokeizedFile
        procedure :: readJavaCodeBlocks
        ! procedure :: printPreTokenizedJavaFile
    end type PrepareTokeizedFile

    type :: bracket
        integer :: startingCharacter
        integer :: occurence
        integer :: depth
        logical :: isClosing
        type(bracket), pointer :: matchingBracket
    end type bracket

    type :: Object
        character(len=256) :: Name          ! name of the class, method, or variable
        character(len=256) :: Location      ! file path or directory location where it's defined
        type(Object), dimension(:), allocatable :: Variables    ! array of variable objects (encapsulated in the object)
        type(Method), dimension(:), allocatable :: Methods      ! array of method objects
        type(Method), pointer, dimension(:) :: Constructors => null()          ! pointer to the constructor

        logical :: HasCode  ! indicates if this object has code
        logical :: javaProvided  ! indicates if this object is provided by Java

    end type Object

    type :: Method
        character(len=256) :: Name          ! name of the method
        character(len=256) :: ReturnType    ! return type (e.g., "integer", "real")
        logical :: ReturnsSomething         ! indicates if this method returns something
        logical :: IsConstructor            ! indicates if this method is a constructor

        type(Parameter), dimension(:), allocatable :: Parameters ! array of parameter objects
        ! type
        integer :: LocationIndex   ! index into the file paths array
    end type Method

    type :: Parameter
        type(Object), pointer :: inputObject => null()  ! pointer to parameter type (e.g., a class)
        character(len=256) :: Name         ! name of the parameter
    end type Parameter


    type :: CodeBlock
        character(len=256) :: Name          ! name of the code block (e.g., a method or constructor)
        logical :: ReturnsSomething         ! indicates if this code block returns something
        type(Object), dimension(:), allocatable :: LocalObjects
        type(Parameter), pointer, dimension(:) :: InParamaters => null() ! pointer to the parameters
        integer :: LocationIndex            ! index into the file paths array
        character(len=256) :: CodeString    ! string representation of the code block (e.g., a constructor's implementation)
    end type CodeBlock




    contains

    !> Is essentially a constructor for the JavaFile type
    !! @param this The JavaFile object to be initialized you don't need to pass this in,
    !! it's done automatically by the compiler
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

    !> Is essentially a constructor for the PrepareTokeizedFile type
    !! @param this The PrepareTokeizedFile object to be initialized you don't need to pass this in,
    !! it's done automatically by the compiler
    !! @param relativeFilePath The relative file path of the Java file
    !! @param className The name of the class in the Java
    !! @param packageName The package name of the Java file
    !! @param imports The imports of the Java file
    !! @param importLines The import lines of the Java file
    !! @param codeLines The code lines of the Java file
    subroutine initializePrepareTokeizedFile(this, relativeFilePath, className, packageName, imports, importLines, codeLines)
        class(PrepareTokeizedFile), intent(inout) :: this
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
    end subroutine initializePrepareTokeizedFile


    !> Reads the Java code blocks and pretokenizes them
    !! @param this The PrepareTokeizedFile object to be initialized you don't need to pass this in,
    !! it's done automatically by the compiler
    subroutine readJavaCodeBlocks(this)
        class(PrepareTokeizedFile), intent(inout) :: this

        character(:), allocatable :: originalFile
        character(:), allocatable :: workingLine
        integer :: i
        integer :: bracketCounter, bracketDepth, reverseBracketCounter, reverseBracketDepth,&
         braceCounter, braceDepth, reverseBraceCounter, reverseBraceDepth
        integer :: numberOfCharacters, workingCharacterNumber, workingCharacterAnalysis
        logical :: characterIsBracket, characterIsBrace
        type(bracket), target, dimension(1000) :: brackets, braces

        numberOfCharacters = 1
        do i= 1, size(this%codeLines)
            if ( len(trim(adjustl(this%codeLines(i)))) .gt. 0) then
                workingLine = this%codeLines(i)
                numberOfCharacters = numberOfCharacters + len(trim(adjustl(workingLine))) + 1
            end if
        end do
        print *, "There are ", numberOfCharacters, " characters in the file ", this%relativeFilePath

        allocate(character(numberOfCharacters) :: originalFile)

        workingCharacterNumber = 1
        do i = 1, size(this%codeLines)
            if ( len(trim(adjustl(this%codeLines(i)))) .gt. 0) then
                originalFile(workingCharacterNumber:workingCharacterNumber + len(trim(adjustl(this%codeLines(i)))) + 1) = trim(adjustl(this%codeLines(i))) // " "
                workingCharacterNumber = workingCharacterNumber + len(trim(adjustl(this%codeLines(i)))) + 1
            end if
        end do
        print *, "The size of the new file is ", size(this%codeLines), " : ", workingCharacterNumber

        bracketCounter = 0
        bracketDepth = 0
        do i= 1, numberOfCharacters
            workingCharacterAnalysis = index(originalFile(i:i), "{")
            characterIsBracket = workingCharacterAnalysis .gt. 0

            if (characterIsBracket) then
                bracketCounter = bracketCounter + 1
                bracketDepth = bracketDepth + 1
                brackets(bracketCounter)%startingCharacter = i
                brackets(bracketCounter)%occurence = bracketCounter
                brackets(bracketCounter)%isClosing = .false.
            end if

            characterIsBracket = .false.
        end do

        reverseBracketCounter = 0
        reverseBracketDepth = 0
        do i = numberOfCharacters, 1, -1
            workingCharacterAnalysis = index(originalFile(i:i), "}")
            characterIsBracket = workingCharacterAnalysis .gt. 0

            if (characterIsBracket) then
                reverseBracketCounter = reverseBracketCounter + 1
                reverseBracketDepth = reverseBracketDepth + 1
                brackets(reverseBracketCounter)%startingCharacter = i
                brackets(reverseBracketCounter)%occurence = reverseBracketCounter
                brackets(reverseBracketCounter)%isClosing = .true.
            end if

            characterIsBracket = .false.
        end do

        if (bracketCounter .ne. reverseBracketCounter) then
            print *, "Bracket Counter: ", bracketCounter, " Reverse Bracket Counter: ",&
             reverseBracketCounter
            print *, "Bracket Depth: ", bracketDepth, " Reverse Bracket Depth: ", reverseBracketDepth
            print *, "Brackets do not match"
            return
        end if


        braceCounter = 0
        braceDepth = 0
        do i= 1, numberOfCharacters
            workingCharacterAnalysis = index(originalFile(i:i), "{")
            characterIsbrace = workingCharacterAnalysis .gt. 0

            if (characterIsbrace) then
                braceCounter = braceCounter + 1
                braceDepth = braceDepth + 1
                braces(braceCounter)%startingCharacter = i
                braces(braceCounter)%occurence = braceCounter
                braces(braceCounter)%isClosing = .false.
            end if

            characterIsbrace = .false.
        end do

        reversebraceCounter = 0
        reversebraceDepth = 0
        do i = numberOfCharacters, 1, -1
            workingCharacterAnalysis = index(originalFile(i:i), "}")
            characterIsbrace = workingCharacterAnalysis .gt. 0

            if (characterIsbrace) then
                reversebraceCounter = reversebraceCounter + 1
                reversebraceDepth = reversebraceDepth + 1
                braces(reversebraceCounter)%startingCharacter = i
                braces(reversebraceCounter)%occurence = reversebraceCounter
                braces(reversebraceCounter)%isClosing = .true.
            end if

            characterIsbrace = .false.
        end do

        if (braceCounter .ne. reversebraceCounter) then
            print *, "brace Counter: ", braceCounter, " Reverse brace Counter: ", reversebraceCounter
            print *, "brace Depth: ", braceDepth, " Reverse brace Depth: ", reversebraceDepth
            print *, "braces do not match"
            return
        end if

        print *, originalFile
        this%preTokenizedCode = originalFile


    end subroutine readJavaCodeBlocks

    

end module javaAnalysisTypes