cmake_minimum_required(VERSION 3.14)

# 1. FIX SUPRÊME POUR FIREBASE
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

# 2. ANTIDOTE POUR AUDIOPLAYERS (Défini ici pour être vu par tout le monde)
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# 3. CHARGEMENT DES OUTILS FLUTTER
include(flutter/generated_plugins.cmake)

# 4. ON APPELLE LE DOSSIER RUNNER
add_subdirectory(runner)
