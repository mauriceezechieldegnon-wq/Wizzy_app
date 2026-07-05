cmake_minimum_required(VERSION 3.14)

# 1. FIX POUR AUDIOPLAYERS ET COROUTINES
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# 2. CHARGER LE DOSSIER FLUTTER (Indispensable pour le moteur)
add_subdirectory("flutter")

# 3. CHARGER LES PLUGINS FLUTTER
include(flutter/generated_plugins.cmake)

# 4. FIX MACRO APPLY_STANDARD_SETTINGS
if(NOT COMMAND apply_standard_settings)
    macro(apply_standard_settings TARGET)
        target_compile_features(${TARGET} PRIVATE cxx_std_17)
    endmacro()
endif()

# 5. DÉFINITION DE L'EXÉCUTABLE (Avec le préfixe runner/ ✅)
add_executable(${BINARY_NAME}
  "runner/main.cpp"
  "runner/resource.h"
  "runner/runner.rc"
  "runner/utils.cpp"
  "runner/utils.h"
  "runner/win32_window.cpp"
  "runner/win32_window.h"
  "runner/flutter_window.cpp"
  "runner/flutter_window.h"
  ${FLUTTER_MANAGED_SOURCES}
)

# Indiquer à Windows où lire les en-têtes (.h) dans runner/
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/runner")

# 6. APPLIQUER LES RÉGLAGES STANDARDS
apply_standard_settings(${BINARY_NAME})

# 7. LIAISON DES BIBLIOTHÈQUES
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# 8. LIAISON AUTOMATIQUE DES PLUGINS
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
