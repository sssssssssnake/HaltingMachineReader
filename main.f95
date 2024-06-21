program HelloWorld
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents
    ! Main program
    print *, "Hello, World!"
    myFilePath = "/home/sssssssssnake/Documents/FunProjects/FortranHalting/main.f95"

end program HelloWorld


subroutine readFile(filePath, fileContents)
    character(:),allocatable, intent(in) :: filePath
    character(:), allocatable, intent(out) :: fileContents
    ! now to read the file
    open(10, file=filePath, status='old', action='read')

    
end subroutine readFile