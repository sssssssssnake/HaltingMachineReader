

program HelloWorld
    use fileReader
    implicit none
    character(:), allocatable :: myFilePath
    character(:), allocatable :: myFileContents(:)
    integer :: printCounter, endingLine

    ! interface for readFile subroutine
    

    ! Main program
    myFilePath = "src/main.f95"

    call readFile(myFilePath, myFileContents, endingLine)
    


    do printCounter = 1, endingLine
        print *, trim(myFileContents(printCounter))
    end do


    deallocate(myFileContents)
    deallocate(myFilePath)
end program HelloWorld
