cmake_minimum_required(VERSION 3.15)
project(molpro-plugin LANGUAGES CXX)

include(FetchContent)
FetchContent_Declare(
        LibraryManager
        GIT_REPOSITORY https://github.com/molpro/library-manager.git
        GIT_TAG 0.11.3
)
FetchContent_MakeAvailable(LibraryManager)

LibraryManager_Project(FORTRAN_OPTION)

add_subdirectory(dependencies)

add_subdirectory(src)

if (${CMAKE_PROJECT_NAME} STREQUAL ${PROJECT_NAME})
    add_subdirectory(examples)
    enable_testing()
    add_subdirectory(test)
endif ()

# Documentation has to come last to make sure all dependencies have been added
include(DependencyManagerDocs)

DependencyManagerDocs_Add(${PROJECT_NAME}
        FILES README.md
        DOC_URL "https://molpro.github.io/${PROJECT_NAME}"
        DEPENDS fcidump # projects whose documentation has to be built before current project.
        )
