program HelloWorld
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents

    ! needs interface to be able to use the subroutine
    interface myInt
        subroutine readFile(filePath, fileContents)
            character(:), allocatable, intent(in) :: filePath
            character(:), allocatable, intent(out) :: fileContents
        end subroutine readFile
    end interface myInt
    ! Main program
    print *, "Hello, World!"
    myFilePath = "main.f95"
    call readFile(myFilePath, myFileContents)
    print *, myFileContents
    print *, len(myFileContents)

end program HelloWorld




subroutine readFile(filePath, fileContents)
    character(:), allocatable, intent(in) :: filePath
    character(:), allocatable, intent(out) :: fileContents
    ! now to read the file
    ! allocate the fileContents for the size of the file
    allocate(character(1000) :: fileContents)
    open(10, file=filePath, status='old', action='read')
    read(10, '(A)') fileContents
    close(10)

    
end subroutine readFile