cmake_minimum_required(VERSION 3.14)

# FIX POUR FIREBASE ET AUDIOPLAYERS
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

# On définit la macro ici pour qu'elle soit héritée par le dossier runner
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# ON NE CHARGE PAS LES PLUGINS ICI ❌
# On va directement dans le dossier qui crée l'exécutable
add_subdirectory(runner)
