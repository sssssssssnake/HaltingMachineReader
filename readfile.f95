program read_file
    implicit none
    character(len=100) :: line
    integer :: iounit, iostat

    ! Open the file
    open(newunit=iounit, file='main.f95', status='old', action='read', iostat=iostat)
    if (iostat /= 0) then
        print *, 'Error opening file!'
        stop
    end if

    ! Read the file line by line
    do
        read(iounit, '(A)', iostat=iostat) line
        if (iostat /= 0) exit  ! Exit loop on end of file or error
        print *, trim(line)
    end do

    ! Close the file
    close(iounit)
end program read_file
