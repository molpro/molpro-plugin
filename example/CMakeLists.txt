message("examples ${CMAKE_Fortran_COMPILER_ID}")
add_executable(plugin-example-1 plugin-example-1.cpp)
add_executable(plugin-example-3 plugin-example-3.cpp)
add_executable(PluginHost PluginHost.cpp)

target_link_libraries(plugin-example-1 PRIVATE molpro_plugin)
target_link_libraries(plugin-example-3 PRIVATE molpro_plugin)
target_link_libraries(PluginHost PRIVATE molpro_plugin)

if (CMAKE_Fortran_COMPILER_ID)
    add_executable(plugin-example-2 plugin-example-2.F90)
    target_link_libraries(plugin-example-2 PRIVATE molpro_plugin)
endif ()

