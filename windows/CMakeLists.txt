cmake_minimum_required(VERSION 3.14)

# --- 1. L'ANTIDOTE : ON DÉFINIT LA COMMANDE MANQUANTE POUR LES PLUGINS ---
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()
# -----------------------------------------------------------------------

# 2. FIX POUR AUDIOPLAYERS
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# 3. CHARGER LES OUTILS FLUTTER
# On initialise FLUTTER_MANAGED_SOURCES pour éviter les erreurs de variables vides
set(FLUTTER_MANAGED_SOURCES "")
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

# 5. APPLIQUER LES RÉGLAGES (Utilise l'antidote défini plus haut)
apply_standard_settings(${BINARY_NAME})

# 6. LIAISON DES BIBLIOTHÈQUES
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# 7. LIAISON AUTOMATIQUE DES PLUGINS (Firebase, Audioplayers, etc.)
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
