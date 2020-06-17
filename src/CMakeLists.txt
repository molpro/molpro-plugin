LibraryManager_Add(${PROJECT_NAME} NAMESPACE molpro)

if (NOT NOFORTRAN AND CMAKE_Fortran_COMPILER)
    find_package(MPI COMPONENTS CXX Fortran REQUIRED)
else ()
    find_package(MPI COMPONENTS CXX REQUIRED)
endif ()

add_subdirectory(molpro)

LibraryManager_Install(${PROJECT_NAME} PKG_CONFIG)
LibraryManager_Export(${PROJECT_NAME})
