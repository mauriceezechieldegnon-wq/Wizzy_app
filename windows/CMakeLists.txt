cmake_minimum_required(VERSION 3.14)

# 1. L'ANTIDOTE : On définit la commande pour les plugins avant tout le reste
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

# 2. RÉGLAGES DE SÉCURITÉ
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# 3. CRÉER L'EXÉCUTABLE D'ABORD ✅
# On crée la cible "wizzy" ici pour qu'elle existe quand on chargera les plugins
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
)

# 4. MAINTENANT, CHARGER LES PLUGINS
# Le fichier 'generated_plugins.cmake' va maintenant trouver la cible "wizzy" sans erreur
include(flutter/generated_plugins.cmake)

# 5. APPLIQUER LES RÉGLAGES ET LIAISONS
apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# 6. LIAISON AUTOMATIQUE DES PLUGINS (Firebase, Audioplayers, etc.)
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
