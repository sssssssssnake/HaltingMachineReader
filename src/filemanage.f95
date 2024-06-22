module fileManager
    implicit none
    
    private
    public :: readFile, containsString


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
        character(:),dimension(:), allocatable, target :: filecontTest


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
        if ( status == 0 ) then
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

        if ( index(searchString, keyword) > 0 ) then
            isInString = .true.
        end if

    
    end function containsString



end module fileManager