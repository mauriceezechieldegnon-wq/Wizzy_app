cmake_minimum_required(VERSION 3.14)
project(wizzy LANGUAGES CXX)

# Correctif de rétrocompatibilité pour les plugins audio/media (ex: audioplayers)
macro(apply_standard_settings TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_17)
endmacro()

set(BINARY_NAME "wizzy")

include(flutter/generated_plugins.cmake)

add_subdirectory(flutter)

add_executable(${BINARY_NAME} WIN32
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "flutter_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "runner.rc"
)

apply_standard_settings(${BINARY_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")

add_dependencies(${BINARY_NAME} flutter_assemble)
