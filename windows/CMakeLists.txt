cmake_minimum_required(VERSION 3.14)

project(wizzy LANGUAGES CXX)

# 1. FIX POUR AUDIOPLAYERS (Coroutine error)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

# 2. LE FIX MAGIQUE : On définit la commande qui manque au plugin
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

set(BINARY_NAME "wizzy")

# 3. CHARGER LES OUTILS FLUTTER
include(flutter/generated_plugins.cmake)

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

# 4. APPLIQUER LES RÉGLAGES
apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
