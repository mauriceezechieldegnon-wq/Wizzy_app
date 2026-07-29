cmake_minimum_required(VERSION 3.14)

# 1. ANTIDOTE GLOBAL (Doit être en haut)
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# 2. INITIALISATION FLUTTER
set(FLUTTER_MANAGED_SOURCES "")

# 3. CRÉATION DE L'EXÉCUTABLE ✅
# On force CMake à créer l'app ici à la racine en pointant vers runner/
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

# 4. CHARGEMENT DES PLUGINS (Ici à la racine, les chemins sont parfaits ✅)
include(flutter/generated_plugins.cmake)

# 5. LIAISONS ET RÉGLAGES
apply_standard_settings(${BINARY_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# On vérifie la cible pour éviter l'erreur assemble
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
