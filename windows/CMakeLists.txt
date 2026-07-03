cmake_minimum_required(VERSION 3.14)

# 1. FIX POUR AUDIOPLAYERS (Doit être tout en haut)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "WIZZY")

# 2. CONFIGURATION FLUTTER
# On initialise les variables Flutter avant toute chose
set(FLUTTER_MANAGED_SOURCES "")

# 3. INCLUSION DES PLUGINS
# C'est ici que 'apply_standard_settings' et les autres macros sont chargées
include(flutter/generated_plugins.cmake)

# 4. DÉFINITION DE L'EXÉCUTABLE
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
# Maintenant que generated_plugins.cmake est chargé, cette commande est reconnue ✅
apply_standard_settings(${BINARY_NAME})

# 6. LIAISON DES BIBLIOTHÈQUES
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# 7. DÉPENDANCES ET ASSEMBLAGE
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison automatique de tous les plugins (Firebase, Audioplayers, etc.)
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
