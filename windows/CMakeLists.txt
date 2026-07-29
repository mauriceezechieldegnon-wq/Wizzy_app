cmake_minimum_required(VERSION 3.14)

# 1. FIX FIREBASE (Force la compatibilité 3.5)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

# 2. ANTIDOTE AUDIOPLAYERS (Défini ici pour être hérité par tout le monde)
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
    if(MSVC)
        target_compile_options(${TARGET} PRIVATE /W4 /WX /wd4201)
    endif()
endmacro()

add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# 3. CHARGEMENT DES OUTILS FLUTTER
# On ne charge QUE les outils, pas encore les liaisons
include(flutter/generated_plugins.cmake)

# 4. DIRECTION LE DOSSIER RUNNER
add_subdirectory(runner)
