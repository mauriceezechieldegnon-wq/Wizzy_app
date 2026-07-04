cmake_minimum_required(VERSION 3.14)

# 1. FIX POUR AUDIOPLAYERS (Coroutine error)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

# 2. CONFIGURATION DE BASE
set(BINARY_NAME "wizzy")
set(FLUTTER_MANAGED_SOURCES "")

# 3. DÉFINITION DE L'EXÉCUTABLE D'ABORD ✅
# On crée la cible "wizzy" pour que les plugins puissent s'y attacher
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

# 4. CHARGER LES OUTILS ET PLUGINS FLUTTER MAINTENANT
# Maintenant que "wizzy" existe, le fichier suivant ne fera plus d'erreur
include(flutter/generated_plugins.cmake)

# 5. APPLIQUER LES RÉGLAGES STANDARDS
# Si la commande est inconnue (bug rare sur GitHub), on la définit à vide
if(NOT COMMAND apply_standard_settings)
    macro(apply_standard_settings TARGET)
    endmacro()
endif()

apply_standard_settings(${BINARY_NAME})

# 6. LIAISON DES BIBLIOTHÈQUES
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison automatique de tous les plugins (Firebase, Audioplayers, etc.)
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
