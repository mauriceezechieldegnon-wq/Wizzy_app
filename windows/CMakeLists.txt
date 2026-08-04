cmake_minimum_required(VERSION 3.14)

# --- LE FIX : ON DÉFINIT LA COMMANDE MANQUANTE ICI ---
macro(apply_standard_settings TARGET)
endmacro()
# ----------------------------------------------------

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

include(flutter/generated_plugins.cmake)

add_subdirectory(runner)
