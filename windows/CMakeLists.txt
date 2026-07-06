cmake_minimum_required(VERSION 3.14)

# --- 1. L'ANTIDOTE (DOIT ÊTRE ICI AU DÉBUT) ---
# On définit la macro AVANT que quoi que ce soit d'autre ne soit chargé
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

# On définit les politiques de sécurité
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)
# -----------------------------------------------

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# 2. INITIALISATION FLUTTER
set(FLUTTER_MANAGED_SOURCES "")

# 3. CHARGER LES PLUGINS (Maintenant ils connaissent l'Antidote ✅)
include(flutter/generated_plugins.cmake)

# 4. DÉFINITION DE L'EXÉCUTABLE
add_executable(${BINARY_NAME}
  "runner/main.cpp"
  "runner/utils.cpp"
  "runner/utils.h"
  "runner/win32_window.cpp"
  "runner/win32_window.h"
  "runner/flutter_window.cpp"
  "runner/flutter_window.h"
  "runner/runner.rc"
  "runner/resource.h"
  ${FLUTTER_MANAGED_SOURCES}
)

# 5. APPLIQUER LES RÉGLAGES
apply_standard_settings(${BINARY_NAME})

# 6. LIAISONS
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# LIAISON AUTOMATIQUE DES PLUGINS
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
