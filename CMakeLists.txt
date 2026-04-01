cmake_minimum_required(VERSION 3.20)

project(runwebgltests)
set(USE_BUNDLED_ANGLE ON)

# NCCCSupport
include(${CMAKE_CURRENT_LIST_DIR}/nccc/stubsupport/cmake/NcccStubMacros.cmake)

# cwgl (PlatformGLES)
set(CWGL_LEVEL_L2 ON)
if(USE_BUNDLED_ANGLE)
    set(CWGL_KHRONOS_HEADER_DIR
        ${CMAKE_CURRENT_LIST_DIR}/grpbase/ext/angle/include)
endif()
set(YFRM_CWGL_USE_PLATFORMGLES ON)
add_subdirectory(cwgl)

# nccc stubsupport
add_subdirectory(nccc/stubsupport stubsupport)

# node-nccc
set(NCCC_DEBUG_MODULES_PREFIX ${CMAKE_CURRENT_LIST_DIR}/_nccc)
set(NCCC_DEBUG_NODE_MODULES ${CMAKE_CURRENT_LIST_DIR}/_nccc)
set(WITH_NODE_API_HEADERS ${CMAKE_CURRENT_LIST_DIR}/node-api-headers)
add_subdirectory(nccc/js/node/node-nccc node-nccc)

# cwgl nccc module
include(${CMAKE_CURRENT_LIST_DIR}/cwgl/nccc/stub_cwgl.cmake)
nccc_stub_generate(cwgl) # => $(bindir)/stubdata_cwgl.h

add_library(nccc_cwgl MODULE
    stubs/nccc_cwgl.c)
target_compile_definitions(nccc_cwgl
    PRIVATE
    CWGL_LEVEL_L2)
target_include_directories(nccc_cwgl
    PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_LIST_DIR}/nccc/stubsupport)

if(USE_BUNDLED_ANGLE)
    target_link_directories(nccc_cwgl
        PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}/_nccc)
endif()
if(NOT TARGET cwgl)
    message(FATAL_ERROR "No cwgl target?")
endif()
target_link_libraries(nccc_cwgl 
    cwgl 
    # PlatformGLES
    EGL GLESv2)

if(APPLE)
    set_target_properties(nccc_cwgl
        PROPERTIES
        MACOSX_RPATH ON
        BUILD_RPATH "@loader_path"
        INSTALL_RPATH "@loader_path"
        BUILD_WITH_INSTALL_RPATH ON)
endif()

