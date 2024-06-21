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
  

end subroutine readFile
