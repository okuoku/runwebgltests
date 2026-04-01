# Tentative. Copy and (re) sign ANGLE binary on macOS

set(anglebin
    ${CMAKE_CURRENT_LIST_DIR}/grpbase/ext/angle/out)

set(angleout ${CMAKE_CURRENT_LIST_DIR}/_nccc)

set(libs
    libEGL.dylib
    libGLESv2.dylib)

file(MAKE_DIRECTORY ${angleout})

foreach(l IN LISTS libs)
    file(COPY_FILE
        ${anglebin}/${l}
        ${angleout}/${l})

    # Adjust Id
    execute_process(
        COMMAND install_name_tool
        -id @rpath/${l}
        ${angleout}/${l}
        RESULT_VARIABLE rr)
    if(rr)
        message(FATAL_ERROR "Failed to rewrite id")
    endif()

    # Adjust rpath
    execute_process(
        COMMAND install_name_tool
        -rpath @executable_path/ @loader_path/
        ${angleout}/${l}
        RESULT_VARIABLE rr)
    if(rr)
        message(FATAL_ERROR "Failed to adjust rpath")
    endif()

    # Ad-hoc sign the dylib
    execute_process(
        COMMAND codesign -f -s - ${angleout}/${l}
        RESULT_VARIABLE rr
    )
    if(rr)
        message(FATAL_ERROR "Failed to codesign dylib")
    endif()
endforeach()


