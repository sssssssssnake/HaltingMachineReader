program HelloWorld
    use fileReader
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:, :)
    integer :: index

    ! interface for readFile subroutine
    

    ! Main program
    print *, "Hello, World!"
    myFilePath = "main.f95"

    call readFile(myFilePath, myFileContents)
    ! print *, myFileContents
    ! print *, len(myFileContents)

end program HelloWorld

module fileReader
    implicit none

    contains
    subroutine readFile(filePath, fileContents)
        character(:), allocatable, intent(in) :: filePath
        character(:), allocatable, intent(out) :: fileContents(:, :)

        integer :: counter, fileSize, fileUnit, iostat

        fileUnit = 10

        open(newunit=fileUnit, file=filePath, status='old', action='read', iostat=iostat)
        inquire(fileUnit, size=fileSize)
        print *, "fileSize: ", fileSize
        call printFileStatus(iostat)



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