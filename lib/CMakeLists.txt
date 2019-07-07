include(libconfig.cmake)
get_dependency(ON fcidump_dep)
list(APPEND DEPENDENCIES FCIdump)

if (CMAKE_Fortran_COMPILER_ID)
    add_library(molpro_plugin STATIC PluginGuest.cpp PluginGuest.h PluginGuestF.F90)
else ()
    add_library(molpro_plugin STATIC PluginGuest.cpp PluginGuest.h)
endif ()
target_link_libraries(molpro_plugin PUBLIC FCIdump)

set_target_properties(${PROJECT_NAME} PROPERTIES PUBLIC_HEADER "PluginGuest.h;${CMAKE_CURRENT_BINARY_DIR}/molpro_plugin-config.h")


if (CMAKE_Fortran_COMPILER_ID AND MPI_Fortran_FOUND)
    target_link_libraries(molpro_plugin PUBLIC MPI::MPI_CXX MPI::MPI_Fortran)
else ()
    target_link_libraries(molpro_plugin PUBLIC MPI::MPI_CXX)
endif ()

configure_library(${PROJECT_NAME} "${DEPENDENCIES}")
