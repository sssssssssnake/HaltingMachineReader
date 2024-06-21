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
    integer :: iostat, unitNumber, i, fileSize
    character(100) :: testChar

    ! Use a named constant for the unit number
    unitNumber = 10

    ! Open the file and get its size
    open(unitNumber, file=filePath, status="old", iostat=iostat)
    if ( iostat /= 0 ) then
        print *, "Error opening file"
        stop
    end if

    ! Get the file size
    inquire(unitNumber, size=fileSize) 

    ! Allocate the fileContents variable
    allocate(character(fileSize) :: fileContents)
    print *, "File size: ", fileSize
    print *, "File contents length: ", len(fileContents)


    print *, "Reading file"
    print *, "error status: ", iostat

    ! Read the file 
    read(unitNumber, '(A)', iostat=iostat) fileContents
    read(unitNumber, '(A)', iostat=iostat) testChar
    print *, "error status: ", iostat
    print *, "testChar: ", testChar
  

end subroutine readFile
