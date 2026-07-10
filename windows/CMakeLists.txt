cmake_minimum_required(VERSION 3.14)

# FIX POUR FIREBASE ET AUDIOPLAYERS
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# On définit ici la macro pour qu'elle soit visible partout
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

# On appelle le dossier runner qui va construire l'app
add_subdirectory(runner)
