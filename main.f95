module fileReader
    implicit none


    
    contains
    subroutine readFile(filePath, fileContents, endingLine)
        character(:), allocatable, intent(in) :: filePath
        character(:), allocatable, intent(out) :: fileContents(:)
        integer, intent(out) :: endingLine

        integer :: counter, fileSize, fileUnit, iostat

        fileUnit = 10

        open(newunit=fileUnit, file=filePath, status='old', action='read', iostat=iostat)
        inquire(fileUnit, size=fileSize)
        print *, "fileSize: ", fileSize
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



    end subroutine readFile

    subroutine printFileStatus(status)
        integer, intent(in) :: status
        if ( status == 0 ) then
            print *, "File status: OK"
        else
            print *, "File status: ", status
        end if
    end subroutine printFileStatus
end module fileReader

program HelloWorld
    use fileReader
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:)
    integer :: printCounter, endingLine

    ! interface for readFile subroutine
    

    ! Main program
    myFilePath = "main.f95"

    call readFile(myFilePath, myFileContents, endingLine)
    


    do printCounter = 1, endingLine
        print *, trim(myFileContents(printCounter))
    end do


    deallocate(myFileContents)
    deallocate(myFilePath)
end program HelloWorld
