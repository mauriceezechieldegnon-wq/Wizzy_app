cmake_minimum_required(VERSION 3.14)

# 1. FIX POUR FIREBASE ET AUDIOPLAYERS (Doit être AVANT 'project')
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

# On définit l'antidote ICI pour qu'il soit connu avant de charger les plugins
macro(apply_standard_settings TARGET)
    if(MSVC)
        target_compile_options(${TARGET} PRIVATE /W4 /WX /wd4201)
    endif()
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# 2. CHARGEMENT DES PLUGINS (Ici les chemins seront corrects ✅)
include(flutter/generated_plugins.cmake)

# 3. DIRECTION LE DOSSIER RUNNER
add_subdirectory(runner)
