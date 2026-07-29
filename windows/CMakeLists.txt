cmake_minimum_required(VERSION 3.14)

# FIX POUR AUDIOPLAYERS ET FIREBASE
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# On définit l'antidote pour les plugins
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

# 1. DÉFINITION DE L'EXÉCUTABLE D'ABORD ✅
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

# 2. CHARGEMENT DES PLUGINS ENSUITE ✅
# Maintenant que 'wizzy' existe, ce fichier pourra s'y lier
include(flutter/generated_plugins.cmake)

# 3. RÉGLAGES ET LIAISONS
apply_standard_settings(${BINARY_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# Gestion des dépendances de compilation
if(NOT TARGET flutter_assemble)
    add_custom_target(flutter_assemble)
endif()
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison automatique de tous les plugins
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  if(TARGET ${plugin})
    target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
    if(TARGET ${plugin}_assemble)
      add_dependencies(${BINARY_NAME} ${plugin}_assemble)
    endif()
  endif()
endforeach()
