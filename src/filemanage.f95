module fileManager
    implicit none
    
    private
    public :: readFile, containsString, getTextBetweenStrings, replaceCharacterInString


    character(:), allocatable :: reusableFilePath
    character(:), allocatable, dimension(:) :: mainFileContent


    contains
    !> Reads the contents of a file specified by the given file path.
    !! 
    !! @param filePath The path of the file to be read.
    !! @param fileContents The contents of the file.
    !! @param endingLine The line number where the file reading should stop.
    !! 
    !! @return the file contents in the second argument and the line number where the file reading stopped in the third argument.
    !! 
    !! Note: This subroutine assumes that the file exists and is accessible.
    !! The file contents are stored in the `fileContents` variable.
    !! The file reading stops at the line specified by `endingLine`.
    !!
    subroutine readFile(filePath, fileContents, endingLine)
        character(:), allocatable, intent(in) :: filePath
        character(:), allocatable, intent(out) :: fileContents(:)
        integer, intent(out) :: endingLine

        integer :: counter, fileSize, fileUnit, iostat


        fileUnit = 10

        open(newunit=fileUnit, file=filePath, status='old', action='read', iostat=iostat)
        inquire(fileUnit, size=fileSize)
        call printFileStatus(iostat)

        ! allocate the worst case scenarios at the same time
        ! There could be one long line in the file or many one character lines
        allocate(character(fileSize) :: fileContents(fileSize))

        counter = 1
        do counter = 1, 100
            read(fileUnit, '(A)', iostat=iostat) fileContents(counter)
            if ( iostat /= 0 ) then
                endingLine = counter - 1
                exit
            end if
        end do

        reusableFilePath = filePath
        mainFileContent = fileContents

        print *, "Read file: ", reusableFilePath


    end subroutine readFile



    subroutine printFileStatus(status)
        integer, intent(in) :: status
        if ( status .eq. 0 ) then
            print *, "File status: OK"
        else
            print *, "File status: ", status
        end if
    end subroutine printFileStatus


    !> Checks if a keyword is in a string.
    !! 
    !! @param keyword The keyword to be checked.
    !! @param searchString The string to be checked.
    !!
    !! @return true if the keyword is in the string, false otherwise.
    logical function containsString(keyword, searchString) result(isInString)
        character(:), allocatable, intent(in) :: keyword
        character(:), allocatable, intent(in) :: searchString
        ! default value is false
        isInString = .false.

        if ( index(searchString, keyword) .gt. 0 ) then
            isInString = .true.
        end if

    
    end function containsString

    !> Gets the text between two strings.
    !!
    !! @param lineToAnalyze The line to be analyzed.
    !! @param startString The string that marks the start of the text to be extracted.
    !! @param endString The string that marks the end of the text to be extracted.
    !!
    !! @return the text between the two strings.
    function getTextBetweenStrings(lineToAnalyze, startString, endString) result(textBetweenStrings)
        character(:), allocatable, intent(in) :: lineToAnalyze
        character(256), intent(in) :: startString
        character(256), intent(in) :: endString
        character(:), allocatable :: textBetweenStrings

        integer :: startStringIndex, endStringIndex

        startStringIndex = index(lineToAnalyze, startString) + len(startString)
        endStringIndex = index(lineToAnalyze, endString) - 1

        textBetweenStrings = lineToAnalyze(startStringIndex:endStringIndex)
    end function getTextBetweenStrings

    function replaceCharacterInString(lineToReplace, characterToReplace, replacementCharacter) result(replacedLine)
        character(:), allocatable, intent(in) :: lineToReplace
        character, intent(in) :: characterToReplace
        character, intent(in) :: replacementCharacter
        character(:), allocatable :: replacedLine

        integer :: i

        allocate(character(len(lineToReplace)) :: replacedLine)

        do i = 1, len(lineToReplace)
            if ( lineToReplace(i:i) == characterToReplace ) then
                replacedLine(i:i) = replacementCharacter
            else
                replacedLine(i:i) = lineToReplace(i:i)
            end if
        end do
    end function replaceCharacterInString



end module fileManager