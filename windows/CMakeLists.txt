cmake_minimum_required(VERSION 3.14)

# 1. FIX POUR FIREBASE ET AUDIOPLAYERS
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

# 2. NOM DU PROJET
project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# 3. DÉFINIR L'ANTIDOTE AVANT TOUT
macro(apply_standard_settings TARGET)
    if(MSVC)
        target_compile_options(${TARGET} PRIVATE /W4 /WX /wd4201)
    endif()
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

# 4. CRÉER L'EXÉCUTABLE "WIZZY" D'ABORD ✅
# On liste les fichiers manuels. On ne met pas encore les sources gérées.
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
)

# 5. MAINTENANT, CHARGER LES PLUGINS FLUTTER
# À ce stade, "wizzy" existe, donc le fichier généré ne fera plus d'erreur.
include(flutter/generated_plugins.cmake)

# 6. AJOUTER LES SOURCES GÉRÉES PAR FLUTTER À L'EXÉCUTABLE
if (FLUTTER_MANAGED_SOURCES)
  target_sources(${BINARY_NAME} PRIVATE ${FLUTTER_MANAGED_SOURCES})
endif()

# 7. RÉGLAGES ET LIAISONS FINALES
apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison automatique de tous les plugins (Firebase, Audioplayers, etc.)
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
