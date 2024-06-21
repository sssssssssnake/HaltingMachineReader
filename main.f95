program HelloWorld
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:, :)
    integer :: index

    ! interface for readFile subroutine
    interface
        subroutine readFile(filePath, fileContents)
            character(:), allocatable, intent(in) :: filePath
            character(:), allocatable, intent(out) :: fileContents (:, :)
                    
        end subroutine readFile
    end interface

    ! Main program
    print *, "Hello, World!"
    myFilePath = "main.f95"

    call readFile(myFilePath, myFileContents)
    ! print *, myFileContents
    ! print *, len(myFileContents)

end program HelloWorld

subroutine readFile(filePath, fileContents)
    character(:), allocatable, intent(in) :: filePath
    character(:), allocatable, intent(out) :: fileContents(:, :)

    integer :: counter, fileSize, fileUnit

    fileUnit = 10

    open(newunit=fileUnit, file=filePath, status='old', action='read')
    inquire(fileUnit, size=fileSize)
    print *, "fileSize: ", fileSize


end subroutine readFile