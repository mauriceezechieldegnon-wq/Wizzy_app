cmake_minimum_required(VERSION 3.14)

# --- LE FIX ULTIME POUR AUDIOPLAYERS ---
# On définit manuellement la commande manquante avant que le plugin ne la cherche
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()
# ---------------------------------------

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# On charge les plugins (ils vont trouver la macro définie au dessus)
include(flutter/generated_plugins.cmake)

add_subdirectory(runner)
