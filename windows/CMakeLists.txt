cmake_minimum_required(VERSION 3.14)

# 1. ANTIDOTE : On définit la macro avant tout le reste
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
    if(MSVC)
        target_compile_options(${TARGET} PRIVATE /W4 /WX /wd4201)
    endif()
endmacro()

# 2. POLITIQUES ET FIXES
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# 3. CRÉER L'ÉXÉCUTABLE "WIZZY" D'ABORD ✅
# On définit la cible AVANT d'inclure les plugins
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

# 4. MAINTENANT ON CHARGE LES PLUGINS
# Comme "wizzy" existe déjà (ligne 19), l'erreur de lien disparaît
include(flutter/generated_plugins.cmake)

# 5. AJOUTER LES SOURCES GÉRÉES PAR FLUTTER
# On injecte les fichiers des plugins dans l'exécutable
if (FLUTTER_MANAGED_SOURCES)
  target_sources(${BINARY_NAME} PRIVATE ${FLUTTER_MANAGED_SOURCES})
endif()

# 6. RÉGLAGES ET LIAISONS COEUR
apply_standard_settings(${BINARY_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# 7. GESTION DES DÉPENDANCES (Assemble)
if(NOT TARGET flutter_assemble)
    add_custom_target(flutter_assemble)
endif()
add_dependencies(${BINARY_NAME} flutter_assemble)

# 8. LIAISON AUTOMATIQUE DES PLUGINS
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  if(TARGET ${plugin})
    target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
    if(TARGET ${plugin}_assemble)
      add_dependencies(${BINARY_NAME} ${plugin}_assemble)
    endif()
  endif()
endforeach()
