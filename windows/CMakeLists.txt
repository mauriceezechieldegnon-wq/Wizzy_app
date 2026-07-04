cmake_minimum_required(VERSION 3.14)

# 1. FIX POUR AUDIOPLAYERS (Coroutine error)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# 2. CHARGER LES OUTILS FLUTTER
include(flutter/generated_plugins.cmake)

# 3. LE FIX MAGIQUE : Si le plugin ne trouve pas la commande, on la crée à vide
if(NOT COMMAND apply_standard_settings)
    macro(apply_standard_settings TARGET)
        # On ne fait rien, mais on empêche l'erreur fatale
    endmacro()
endif()

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

# 5. APPLIQUER LES RÉGLAGES STANDARDS
apply_standard_settings(${BINARY_NAME})

# 6. LIAISON DES BIBLIOTHÈQUES
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison automatique de tous les plugins
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
