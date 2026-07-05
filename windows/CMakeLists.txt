cmake_minimum_required(VERSION 3.14)

# 1. DÉFINIR L'ANTIDOTE TOUT DE SUITE
# Cela permet aux plugins (audioplayers) de trouver la commande même s'ils sont chargés tôt
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

# 2. PARAMÈTRES DE BASE
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)
project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")
set(FLUTTER_MANAGED_SOURCES "")

# 3. CRÉER L'EXÉCUTABLE "WIZZY" D'ABORD ✅
# Comme ça, quand on chargera les plugins, la cible "wizzy" existera déjà
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

# 4. MAINTENANT, CHARGER LES PLUGINS
# Ils vont se lier à la cible "wizzy" qui vient d'être créée au dessus
include(flutter/generated_plugins.cmake)

# 5. APPLIQUER LES RÉGLAGES STANDARDS
apply_standard_settings(${BINARY_NAME})

# 6. LIAISON DES BIBLIOTHÈQUES FLUTTER
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# 7. LIAISON AUTOMATIQUE DES PLUGINS (Firebase, etc.)
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
