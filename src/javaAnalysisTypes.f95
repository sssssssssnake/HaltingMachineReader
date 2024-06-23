module javaAnalysisTypes
    

    private
    public :: JavaFile
    type :: JavaFile
    character(:), allocatable :: relativeFilePath
    character(:), allocatable :: className
    character(:), allocatable :: packageName
    character(:), allocatable, dimension(:) :: imports
    end type JavaFile

end module javaAnalysisTypes