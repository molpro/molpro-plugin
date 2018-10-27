cmake_minimum_required(VERSION 3.11)

project(plugin-examples CXX Fortran)
set(CMAKE_CXX_STANDARD 11)


########## Dependencies ##########

find_package(MPI REQUIRED)

include(FetchContent)
file(STRINGS "dependencies/FCIdump_SHA1" FCIdump_GIT_TAG)
message("FCIdump_GIT_TAG = ${FCIdump_GIT_TAG}")
FetchContent_Declare(
        fcidump_dep
        SOURCE_DIR "${CMAKE_SOURCE_DIR}/dependencies/FCIdump"
        GIT_REPOSITORY https://mxs531@bitbucket.org/pjknowles/fcidump.git
        GIT_TAG ${FCIdump_GIT_TAG}
)


########## Targets ##########

add_subdirectory(lib)
add_subdirectory(example)


########## Documentation ##########

find_package(Doxygen)
if(DOXYGEN_FOUND)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.src ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
add_custom_target(${PROJECT_NAME}-doc ALL
    DEPENDS  ${CMAKE_CURRENT_BINARY_DIR}/html/index.html
    )
file(GLOB headers *.h *.fh)
add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/html/index.html
COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
DEPENDS ${SRC_LIST} ${headers} ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
COMMENT "Generating API documentation with Doxygen" VERBATIM
)
endif(DOXYGEN_FOUND)
