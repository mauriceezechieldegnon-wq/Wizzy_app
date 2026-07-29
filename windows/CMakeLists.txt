cmake_minimum_required(VERSION 3.14)

# 1. FIX POUR FIREBASE ET AUDIOPLAYERS
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

# 2. L'ANTIDOTE : Doit être défini ici pour être vu par les plugins
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

# 3. NOM DU PROJET (Vérifie bien que c'est 'wizzy')
project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# 4. CHARGER LES OUTILS FLUTTER
include(flutter/generated_plugins.cmake)

# 5. APPELER LE DOSSIER RUNNER
add_subdirectory(runner)
