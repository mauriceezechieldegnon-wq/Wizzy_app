cmake_minimum_required(VERSION 3.14)

# 1. FIX POUR FIREBASE ET AUDIOPLAYERS
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# 2. INITIALISATION DES OUTILS FLUTTER
# On force le chargement du moteur Flutter avant tout le reste
include(flutter/generated_plugins.cmake)

# On définit les sources gérées par Flutter (si le fichier plugins ne l'a pas fait)
if(NOT DEFINED FLUTTER_MANAGED_SOURCES)
    set(FLUTTER_MANAGED_SOURCES "")
endif()

# 3. DÉFINITION DE L'EXÉCUTABLE ✅
# On utilise les chemins relatifs au dossier runner
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

# 4. CRÉATION DES CIBLES FANTÔMES (Le fix pour les erreurs 'assemble')
# Si CMake ne voit pas les dépendances, on lui dit qu'elles existent
if(NOT TARGET flutter_assemble)
    add_custom_target(flutter_assemble)
endif()

# 5. ANTIDOTE POUR LA COMMANDE MANQUANTE
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
    if(MSVC)
        target_compile_options(${TARGET} PRIVATE /W4 /WX /wd4201)
    endif()
endmacro()

apply_standard_settings(${BINARY_NAME})

# 6. LIAISONS ET DÉPENDANCES
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

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
