

program HelloWorld
    use fileManager
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:)
    integer :: printCounter, endingLine

    ! interface for readFile subroutine
    

    ! Main program
    myFilePath = "src/main.f95"

    call readFile(myFilePath, myFileContents, endingLine)
    



    deallocate(myFileContents)
    deallocate(myFilePath)
end program HelloWorld
