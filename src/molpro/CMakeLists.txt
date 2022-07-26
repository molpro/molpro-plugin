# Source files at this level define the public interface to the library
LibraryManager_Append(${PROJECT_NAME}
        SOURCES PluginGuest.cpp
        PUBLIC_HEADER PluginGuest.h
        )
if (FORTRAN)
    LibraryManager_Append(${PROJECT_NAME}
            SOURCES PluginGuestF.F90
            )
endif ()

target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_14)
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_EXTENSIONS OFF)

if (MPI_CXX_FOUND)
    message(STATUS "MPI_CXX")
    target_link_libraries(${PROJECT_NAME} PUBLIC MPI::MPI_CXX)
    target_compile_definitions(${PROJECT_NAME} PUBLIC HAVE_MPI)
    if (FORTRAN)
        message(STATUS "MPI_Fortran")
        target_link_libraries(molpro-plugin PUBLIC MPI::MPI_Fortran)
    endif ()
endif ()

include(DependencyManager)
DependencyManager_Populate(fcidump)
target_link_libraries(${PROJECT_NAME} PUBLIC molpro::fcidump)
