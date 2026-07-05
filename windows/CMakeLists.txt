cmake_minimum_required(VERSION 3.14)

# --- LE FIX SUPREME : ON DEFINIT LA MACRO AVANT TOUT ---
macro(apply_standard_settings TARGET)
    if(MSVC)
        target_compile_options(${TARGET} PRIVATE /W4 /WX /wd4201)
    endif()
endmacro()

# On force la compatibilité Firebase
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
# ------------------------------------------------------

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# Initialisation Flutter
set(FLUTTER_MANAGED_SOURCES "")

# ON CREE L'EXECUTABLE AVANT D'INCLURE LES PLUGINS
add_executable(${BINARY_NAME}
  "main.cpp"
  "resource.h"
  "runner.rc"
  "utils.cpp"
  "utils.h"
  "win32_window.cpp"
  "win32_window.h"
  "flutter_window.cpp"
  "flutter_window.h"
  ${FLUTTER_MANAGED_SOURCES}
)

# MAINTENANT ON CHARGE LES PLUGINS
include(flutter/generated_plugins.cmake)

# On applique les réglages à notre exécutable
apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison des plugins
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
