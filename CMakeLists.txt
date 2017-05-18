project(plugin-examples)
cmake_minimum_required(VERSION 3.1)
enable_language(CXX Fortran)
set(CMAKE_CXX_STANDARD 11)

add_executable(plugin-example-1 plugin-example-1.cpp PluginGuest.cpp FCIdump.cpp)
add_executable(plugin-example-2 plugin-example-2.F90 PluginGuestF.F90 FCIdumpF.F90 FCIdump.cpp)
add_executable(plugin-example-3 plugin-example-3.cpp PluginGuest.cpp)
add_executable(PluginHost PluginHost.cpp)

find_package(MPI REQUIRED)

include_directories(${MPI_INCLUDE_PATH})

target_link_libraries(plugin-example-1 ${MPI_LIBRARIES})
target_link_libraries(plugin-example-2 ${MPI_Fortran_LIBRARIES})
target_link_libraries(plugin-example-3 ${MPI_LIBRARIES})
target_link_libraries(PluginHost ${MPI_LIBRARIES})

if(MPI_COMPILE_FLAGS)
  set_target_properties(plugin-example-1 PROPERTIES COMPILE_FLAGS "${MPI_COMPILE_FLAGS}")
  set_target_properties(plugin-example-2 PROPERTIES COMPILE_FLAGS "${MPI_Fortran_COMPILE_FLAGS}")
  set_target_properties(plugin-example-3 PROPERTIES COMPILE_FLAGS "${MPI_COMPILE_FLAGS}")
  set_target_properties(PluginHost PROPERTIES COMPILE_FLAGS "${MPI_COMPILE_FLAGS}")
endif()

if(MPI_LINK_FLAGS)
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
set(MPI_Fortran_LINK_FLAGS "${MPI_Fortran_LINK_FLAGS} -l mpifort")
endif()
  set_target_properties(plugin-example-1 PROPERTIES LINK_FLAGS "${MPI_LINK_FLAGS}")
  set_target_properties(plugin-example-2 PROPERTIES LINK_FLAGS "${MPI_Fortran_LINK_FLAGS}")
  set_target_properties(plugin-example-3 PROPERTIES LINK_FLAGS "${MPI_LINK_FLAGS}")
  set_target_properties(PluginHost PROPERTIES LINK_FLAGS "${MPI_LINK_FLAGS}")
endif()

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
