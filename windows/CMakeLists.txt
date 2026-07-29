cmake_minimum_required(VERSION 3.14)

# 1. FIX AUDIOPLAYERS & FIREBASE
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# 2. ON NE CHARGE RIEN ICI, ON VA DIRECTEMENT DANS LE RUNNER
add_subdirectory(runner)
