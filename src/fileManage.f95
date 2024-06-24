module fileManager
    implicit none
    
    private
    public :: readFile, containsString, getTextBetweenStrings, replaceCharacterInString,&
     removeSubstring, getFilenameFromPathNoExtention, fileExisits, readJavaFile


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
            if ( iostat .ne. 0 ) then
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
        character(:), allocatable, intent(in) :: startString
        character(:), allocatable, intent(in) :: endString
        character(:), allocatable :: textBetweenStrings

        integer :: startStringIndex, endStringIndex

        startStringIndex = index(lineToAnalyze, startString) + len(trim(startString))
        endStringIndex = index(lineToAnalyze, endString, back=.true.) - 1

        textBetweenStrings = lineToAnalyze(startStringIndex:endStringIndex)

    end function getTextBetweenStrings

    function getFilenameFromPathNoExtention(filePath) result(filename)
        character(:), allocatable, intent(in) :: filePath
        character(:), allocatable :: filename

        integer :: lastSlashIndex, lastDotIndex

        lastSlashIndex = index(filePath, '/', back=.true.)
        lastDotIndex = index(filePath, '.', back=.true.)

        filename = filePath(lastSlashIndex + 1:lastDotIndex - 1)

    end function getFilenameFromPathNoExtention

    function removeSubstring(lineToModify, substringToRemove) result(modifiedLine)
        character(:), allocatable, intent(in) :: lineToModify
        character(:), allocatable, intent(in) :: substringToRemove
        character(:), allocatable :: modifiedLine

        integer :: substringIndex

        substringIndex = index(lineToModify, substringToRemove)

        if ( substringIndex .gt. 0 ) then
            modifiedLine = lineToModify(1:substringIndex-1) // lineToModify(substringIndex +&
             len(substringToRemove):)
        else
            modifiedLine = lineToModify
        end if

    end function removeSubstring

    function replaceCharacterInString(lineToReplace, characterToReplace, replacementCharacter)&
         result(replacedLine)
        character(:), allocatable, intent(in) :: lineToReplace
        character, intent(in) :: characterToReplace
        character, intent(in) :: replacementCharacter
        character(:), allocatable :: replacedLine

        integer :: i

        allocate(character(len(lineToReplace)) :: replacedLine)

        do i = 1, len(lineToReplace)
            if ( lineToReplace(i:i) .eq. characterToReplace ) then
                replacedLine(i:i) = replacementCharacter
            else
                replacedLine(i:i) = lineToReplace(i:i)
            end if
        end do
    end function replaceCharacterInString

    logical function fileExisits(filePath) result(exists)
        character(:), allocatable, intent(in) :: filePath
        integer :: fileUnit, iostat

        exists = .false.
        fileUnit = 14

        open(newunit=fileUnit, file=filePath, status='old', action='read', iostat=iostat)
        inquire(fileUnit, exist=exists)
        close(fileUnit)

    end function fileExisits

    subroutine readJavaFile(filePath, fileContents, lastLine, fileExists)
        character(:), allocatable, intent(in) :: filePath
        character(:), allocatable, dimension(:), intent(out) :: fileContents
        integer, intent(out) :: lastLine
        logical, optional, intent(out) :: fileExists

        character(:), allocatable, dimension(:) :: originalFile
        character(:), allocatable, dimension(:) :: modifiedFile
        character(:), allocatable :: workingLine, importkeyword, packageKeyword
        integer :: i, endingLine, lineCounter, lineSetter
        lineCounter = 0
        importkeyword = "import"
        packageKeyword = "package"
        
        if ( .not. fileExisits(filePath) ) then
            fileContents = "File does not exist"
            fileExists = .false.
            return
        end if
        if ( present(fileExists) ) then
            fileExists = .true.
        end if
        call readFile(filePath, originalFile, endingLine)
        print *, "Reading java file"

        ! in java, the lines can go on many lines, so we need to account for that

        ! look for how many lines have imports, packages, or are empty

        do i = 1, endingLine
            workingLine = originalFile(i)
            if ( containsString(importkeyword, workingLine) .or. &
                containsString(packageKeyword, workingLine) .or. &
                len(trim(originalFile(i)) ) .eq. 0 ) then
                cycle
            else
                lineCounter = lineCounter + 1
            end if
        end do

        print *, "Number of lines: ", lineCounter

        allocate(character(size(originalFile)) :: modifiedFile(lineCounter))

        lineSetter = 1
        do i = 1, endingLine
            workingLine = originalFile(i)
            if ( containsString(importkeyword, workingLine) .or. &
                containsString(packageKeyword, workingLine) .or. &
                len(trim(originalFile(i)) ) .eq. 0 ) then
                cycle
            else
                modifiedFile(lineSetter) = originalFile(i)
                lineSetter = lineSetter + 1
            end if
        end do

        print *, "Number of lines in modifiedFile: ", size(modifiedFile)

        fileContents = modifiedFile
        lastLine = lineCounter

        deallocate(originalFile)
        deallocate(modifiedFile)
        deallocate(workingLine)
        deallocate(importkeyword)
        deallocate(packageKeyword)



    end subroutine readJavaFile

    !> Converts a file into code blocks.
    !!
    !! @param fileContents The contents of the file to be converted.
    !! @param lastLine The last line of the file.
    !!
    !! @return the code blocks in the file.
    !! This basically reformats the java code to parser friendly code.
    subroutine convertFileToCodeBlocks(fileContents, lastLine)
        character(:), allocatable, dimension(:), intent(inout) :: fileContents
        integer, intent(in) :: lastLine
        integer :: i, bracketLayersDeep, lineCounter
        character(:), allocatable :: workingLine
        character(:), allocatable, dimension(:) :: codeBlocksLines
        ! assumes that the code only goes 100 layers deep (plz don't break)
        integer, dimension(2,100) :: beginningLine, endingLine
        logical, dimension(100) :: needsReformatting, needsToBeResolved

        bracketLayersDeep = 0

        ! if the line contains a semicolon, a curly bracket, or an at symbol, then move to the next line
        ! if the line contains a curly bracket, then increment the bracketLayersDeep
        ! if the line contains a closing curly bracket, then decrement the bracketLayersDeep

        goThroughFile: do i = 1, lastLine
            
            if ( index(workingLine, "{") .gt. 0 ) then
                bracketLayersDeep = bracketLayersDeep + 1
                beginningLine(bracketLayersDeep, 1) = i
            end if
            if ( index(workingLine, "}") .gt. 0 ) then
                endingLine(bracketLayersDeep, 1) = i
                bracketLayersDeep = bracketLayersDeep - 1
            end if
            deallocate(workingLine)

            workingLine = fileContents(i)
            if ( index(workingLine, ";") .gt. 0 ) then
                if (index(workingLine, ";") .eq. len(trim(workingLine)) ) then
                    ! if the semicolon is the last character in the line, then move to the next line
                    ! unless there is a previous line that is unresolved
                    cycle goThroughFile
                else

                end if
            else

            end if
        end do goThroughFile

        deallocate(workingLine)
        deallocate(codeBlocksLines)
        

    end subroutine convertFileToCodeBlocks


end module fileManager