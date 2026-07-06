cmake_minimum_required(VERSION 3.14)

# 1. FIX POUR FIREBASE (Force la compatibilité avec CMake moderne)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

# 2. FIX POUR AUDIOPLAYERS (Silence l'erreur STL1011)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# 3. INITIALISATION DES OUTILS FLUTTER (Indispensable)
set(FLUTTER_MANAGED_SOURCES "")

# On charge les plugins qui vont remplir les variables de build
include(flutter/generated_plugins.cmake)

# 4. DÉFINITION DE L'EXÉCUTABLE ✅
# Note l'utilisation de runner/ pour pointer au bon endroit
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

# 5. CHARGEMENT DE LA MACRO MANQUANTE (L'erreur "Unknown command")
# Si la commande n'est pas trouvée dans les plugins, on la crée nous-mêmes
if(NOT COMMAND apply_standard_settings)
    macro(apply_standard_settings TARGET)
        target_compile_features(${TARGET} PRIVATE cxx_std_17)
    endmacro()
endif()

apply_standard_settings(${BINARY_NAME})

# 6. LIAISONS DES BIBLIOTHÈQUES COEUR
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# 7. GESTION DES DÉPENDANCES (Fix pour l'erreur "assemble does not exist")
# On vérifie si la cible existe avant de l'ajouter pour éviter le crash
if(TARGET flutter_assemble)
    add_dependencies(${BINARY_NAME} flutter_assemble)
endif()

# Liaison automatique de tous les plugins détectés (Firebase, Audioplayers, etc.)
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
