cmake_minimum_required(VERSION 3.14)

# FIX POUR FIREBASE ET AUDIOPLAYERS (DOIT ETRE ICI)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

include(flutter/generated_plugins.cmake)

add_subdirectory(runner)
