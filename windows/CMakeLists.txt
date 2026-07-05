cmake_minimum_required(VERSION 3.14)

# --- LE FIX SUPRÊME POUR FIREBASE ET CMAKE MODERNE ---
# Cette ligne doit être AVANT 'project'
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
# ----------------------------------------------------

# FIX POUR AUDIOPLAYERS
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# CHARGER LES OUTILS FLUTTER
# On initialise les variables Flutter
set(FLUTTER_MANAGED_SOURCES "")
include(flutter/generated_plugins.cmake)

# DÉFINITION DE L'EXÉCUTABLE
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

# APPLIQUER LES RÉGLAGES STANDARDS
# On définit la macro si elle manque (sécurité pour certains environnements)
if(NOT COMMAND apply_standard_settings)
    macro(apply_standard_settings TARGET)
        target_compile_features(${TARGET} PRIVATE cxx_std_17)
    endmacro()
endif()

apply_standard_settings(${BINARY_NAME})

# LIAISON DES BIBLIOTHÈQUES
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison automatique de tous les plugins
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
