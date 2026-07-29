cmake_minimum_required(VERSION 3.14)

# 1. ANTIDOTE : On définit la macro AVANT tout pour qu'elle soit visible partout
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
    if(MSVC)
        target_compile_options(${TARGET} PRIVATE /W4 /WX /wd4201)
    endif()
endmacro()

# 2. POLITIQUES ET FIXES
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# 3. CHARGER LES OUTILS FLUTTER (Standard)
include(flutter/generated_plugins.cmake)

# 4. APPELER LE DOSSIER RUNNER (Standard)
add_subdirectory(runner)
