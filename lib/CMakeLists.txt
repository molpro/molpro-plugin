FetchContent_GetProperties(fcidump_dep)
if (NOT fcidump_dep_POPULATED)
    FetchContent_Populate(fcidump_dep)
    add_subdirectory(${fcidump_dep_SOURCE_DIR} ${fcidump_dep_BINARY_DIR} EXCLUDE_FROM_ALL)
    list(APPEND DEPENDENCIES FCIdump)
endif ()

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

include(libconfig.cmake)
