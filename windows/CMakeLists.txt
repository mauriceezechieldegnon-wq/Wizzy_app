cmake_minimum_required(VERSION 3.14)

# 1. CORRECTIF POUR AUDIOPLAYERS (Indispensable sur GitHub)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

# 2. Politique de compatibilité pour Firebase
cmake_policy(SET CMP0048 NEW)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# 3. Charger les réglages Flutter (C'est ici que 'apply_standard_settings' est créé)
include(flutter/generated_plugins.cmake)

# 4. Définir l'exécutable
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

# 5. Appliquer les réglages (Maintenant la commande est reconnue ✅)
apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# 6. Assemblage Flutter
add_dependencies(${BINARY_NAME} flutter_assemble)

# 7. Liaison finale des plugins
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
