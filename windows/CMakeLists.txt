cmake_minimum_required(VERSION 3.14)

# 1. FIX CRITIQUE POUR AUDIOPLAYERS
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

# 2. NOM DU PROJET (DOIT MATCH AVEC LE DOSSIER)
project(wizzy LANGUAGES CXX)

# 3. CONFIGURATION FLUTTER
set(BINARY_NAME "wizzy")

# On charge les outils Flutter
include(flutter/generated_plugins.cmake)

# 4. DÉFINITION DE L'EXÉCUTABLE
# Note : FLUTTER_MANAGED_SOURCES est rempli par generated_plugins.cmake
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

# 5. APPLIQUER LES RÉGLAGES STANDARDS
# On définit la macro si elle manque (sécurité GitHub)
if(NOT COMMAND apply_standard_settings)
    macro(apply_standard_settings TARGET)
        target_compile_features(${TARGET} PRIVATE cxx_std_17)
    endmacro()
endif()

apply_standard_settings(${BINARY_NAME})

# 6. LIAISON DES BIBLIOTHÈQUES
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# 7. ASSEMBLAGE DES DÉPENDANCES
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison de tous les plugins (Firebase, Audioplayers, etc.)
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
