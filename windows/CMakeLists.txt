cmake_minimum_required(VERSION 3.14)

# 1. ANTIDOTE : Définir la macro avant tout chargement
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

# 2. POLITIQUES DE SÉCURITÉ
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# 3. CRÉATION DE L'EXÉCUTABLE ✅
# On utilise CMAKE_CURRENT_SOURCE_DIR pour pointer vers le dossier runner depuis la racine
add_executable(${BINARY_NAME}
  "${CMAKE_CURRENT_SOURCE_DIR}/runner/main.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/runner/utils.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/runner/utils.h"
  "${CMAKE_CURRENT_SOURCE_DIR}/runner/win32_window.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/runner/win32_window.h"
  "${CMAKE_CURRENT_SOURCE_DIR}/runner/flutter_window.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/runner/flutter_window.h"
  "${CMAKE_CURRENT_SOURCE_DIR}/runner/runner.rc"
  "${CMAKE_CURRENT_SOURCE_DIR}/runner/resource.h"
)

# 4. CHARGEMENT DES PLUGINS FLUTTER
# Comme on est à la racine, le chemin 'flutter/generated_plugins.cmake' est parfait
include(flutter/generated_plugins.cmake)

# 5. LIAISONS ET RÉGLAGES STANDARDS
apply_standard_settings(${BINARY_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# 6. GESTION DES DÉPENDANCES
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison automatique de tous les plugins (Firebase, Audioplayers, etc.)
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
