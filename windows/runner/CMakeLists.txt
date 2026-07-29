cmake_minimum_required(VERSION 3.14)

# 1. CRÉATION DE L'APP "WIZZY" ✅
# On la crée EN PREMIER pour que tout le monde la voie
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
)

# 2. CHARGER LES PLUGINS AVEC LE CHEMIN GPS (ABSOLU) ✅
# On utilise ${CMAKE_SOURCE_DIR} pour remonter à la racine du projet
include("${CMAKE_SOURCE_DIR}/flutter/generated_plugins.cmake")

# 3. RÉGLAGES ET LIAISONS
apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# On s'assure que la cible de compilation est là
add_dependencies(${BINARY_NAME} flutter_assemble)

# 4. LIAISON AUTOMATIQUE DES PLUGINS
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
