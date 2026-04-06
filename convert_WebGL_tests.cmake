cmake_minimum_required(VERSION 3.20)

set(webgl_tests ${CMAKE_CURRENT_LIST_DIR}/tests/WebGL/sdk/tests)

execute_process(COMMAND
    npm i
    WORKING_DIRECTORY ${webgl_tests}
    RESULT_VARIABLE rr)

if(rr)
    message(FATAL_ERROR "Failed to run npm: ${rr}")
endif()

execute_process(COMMAND
    node convert_to_hyperscript.mjs
    WORKING_DIRECTORY ${webgl_tests}
    RESULT_VARIABLE rr)

if(rr)
    message(FATAL_ERROR "Failed to run npm: ${rr}")
endif()
