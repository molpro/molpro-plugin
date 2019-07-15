get_dependency(fcidump)

if (CMAKE_Fortran_COMPILER_ID)
    add_library(molpro_plugin STATIC PluginGuest.cpp PluginGuest.h PluginGuestF.F90)
else ()
    add_library(molpro_plugin STATIC PluginGuest.cpp PluginGuest.h)
endif ()

set_target_properties(${PROJECT_NAME} PROPERTIES PUBLIC_HEADER "PluginGuest.h")


if (CMAKE_Fortran_COMPILER_ID AND MPI_Fortran_FOUND)
    target_link_libraries(molpro_plugin PUBLIC MPI::MPI_CXX MPI::MPI_Fortran)
else ()
    target_link_libraries(molpro_plugin PUBLIC MPI::MPI_CXX)
endif ()

configure_library(${PROJECT_NAME} FCIdump)
