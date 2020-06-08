LibraryManager_Add(${PROJECT_NAME} NAMESPACE molpro)

if (CMAKE_Fortran_COMPILER)
    find_package(MPI COMPONENTS CXX Fortran REQUIRED)
else ()
    find_package(MPI COMPONENTS CXX REQUIRED)
endif ()
message(STATUS "MPI_FOUND ${MPI_FOUND}")
message(STATUS "MPI_CXX_FOUND ${MPI_CXX_FOUND}")
message(STATUS "MPI_Fortran_FOUND ${MPI_Fortran_FOUND}")

add_subdirectory(molpro)

LibraryManager_Install(${PROJECT_NAME} PKG_CONFIG)
LibraryManager_Export(${PROJECT_NAME})
