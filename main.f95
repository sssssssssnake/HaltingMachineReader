program HelloWorld
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents
    integer :: index

    ! interface for readFile subroutine
    interface
        subroutine readFile(filePath, fileContents)
            character(:), allocatable, intent(in) :: filePath
            character(:), allocatable, intent(out) :: fileContents
        end subroutine readFile
    end interface

    ! Main program
    print *, "Hello, World!"
    myFilePath = "main.f95"
    call readFile(myFilePath, myFileContents)
    print *, myFileContents
    print *, len(myFileContents)
    ! do index = 1, 1000
    !     if ( myFileContents(index:index) == "" ) then
    !         print *, "End of file"
    !     else
    !         print *, myFileContents(index:index)
    !     end if
    ! end do

end program HelloWorld

subroutine readFile(filePath, fileContents)
    character(:), allocatable, intent(in) :: filePath
    character(:), allocatable, intent(out) :: fileContents
    integer :: iostat, unitNumber, i
    integer :: fileSize

    ! Use a named constant for the unit number
    unitNumber = 10

    ! Open the file and get its size
    open(unit=unitNumber, file=filePath, status='old', action='read', iostat=iostat)
    if (iostat /= 0) then
        print *, "Error opening file!"
        return
    endif

    ! Get the size of the file
    inquire(unit=unitNumber, size=fileSize)
    
    ! Allocate fileContents based on the actual size of the file
    allocate(character(fileSize) :: fileContents)

    ! Read the entire contents of the file into fileContents
    rewind(unitNumber)
    do i = 1, fileSize
        read(unitNumber, '(A)', iostat=iostat) fileContents(i:i)
        if (iostat /= 0) exit
    end do

    close(unit=unitNumber)
end subroutine readFile
