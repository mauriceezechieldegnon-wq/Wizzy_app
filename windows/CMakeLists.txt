cmake_minimum_required(VERSION 3.14)

# FIX POUR AUDIOPLAYERS
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

# On inclut les outils Flutter AVANT de les utiliser
set(FLUTTER_MANAGED_SOURCES "")
include(flutter/generated_plugins.cmake)

set(BINARY_NAME "WIZZY")

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

# Appliquer les réglages standards
apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# Configuration des dépendances
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison des plugins
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
