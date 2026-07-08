cmake_minimum_required(VERSION 3.14)

# On récupère les sources gérées par Flutter
set(FLUTTER_MANAGED_SOURCES "")

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

# On applique l'antidote défini dans le fichier parent
apply_standard_settings(${BINARY_NAME})

# Liaisons obligatoires
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# C'est ici que 'flutter_assemble' devient valide ✅
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison automatique des plugins
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
