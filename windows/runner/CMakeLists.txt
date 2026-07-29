cmake_minimum_required(VERSION 3.14)

set(FLUTTER_MANAGED_SOURCES "")

# 1. CRÉER L'APP "WIZZY" D'ABORD ✅
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

# 2. CHARGER LES PLUGINS AVEC LE CHEMIN ABSOLU ✅
# On utilise CMAKE_SOURCE_DIR pour être sûr de trouver le dossier flutter/
include("${CMAKE_SOURCE_DIR}/flutter/generated_plugins.cmake")

# 3. RÉGLAGES ET LIAISONS
# La commande apply_standard_settings est maintenant connue car elle est dans l'include
apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# 4. LIAISON AUTOMATIQUE DES PLUGINS
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
