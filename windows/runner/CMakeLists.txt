cmake_minimum_required(VERSION 3.14)

set(FLUTTER_MANAGED_SOURCES "")

# 1. CRÉER L'APPLICATION "WIZZY" ✅
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

# 2. CHARGER LES PLUGINS MAINTENANT ✅
# En le mettant ici, le fichier generated_plugins trouvera la cible "wizzy"
include("../flutter/generated_plugins.cmake")

# 3. APPLIQUER LES RÉGLAGES (Hérités du parent)
apply_standard_settings(${BINARY_NAME})

# 4. LIAISONS COEUR
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# 5. LIAISON AUTOMATIQUE DES PLUGINS
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
