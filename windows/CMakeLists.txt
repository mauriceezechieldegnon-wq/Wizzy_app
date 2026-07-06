cmake_minimum_required(VERSION 3.14)

# --- LE CODE DE TRICHE POUR AUDIOPLAYERS ---
macro(apply_standard_settings TARGET)
endmacro()
# -------------------------------------------

add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

set(FLUTTER_MANAGED_SOURCES "")
include(flutter/generated_plugins.cmake)

add_executable(${BINARY_NAME}
  "runner/main.cpp"
  "runner/utils.cpp"
  "runner/utils.h"
  "runner/win32_window.cpp"
  "runner/win32_window.h"
  "runner/flutter_window.cpp"
  "runner/flutter_window.h"
  "runner/runner.rc"
  "runner/resource.h"
  ${FLUTTER_MANAGED_SOURCES}
)

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
