
cmake_minimum_required(VERSION 3.14)

# --- 1. L'ANTIDOTE : ON DÉFINIT LA MACRO AVANT QUE LES PLUGINS NE LA CHERCHENT ---
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

# 3. INITIALISATION FLUTTER
set(FLUTTER_MANAGED_SOURCES "")

# 4. CHARGEMENT DES PLUGINS
# Maintenant, quand generated_plugins.cmake chargera Audioplayers, 
# la commande 'apply_standard_settings' existera déjà (grâce à la ligne 4).
include(flutter/generated_plugins.cmake)

# 5. CRÉATION DE L'EXÉCUTABLE ✅
# On pointe vers le dossier runner/ depuis la racine
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

# 6. RÉGLAGES ET LIAISONS
apply_standard_settings(${BINARY_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# 7. GESTION DES DÉPENDANCES (Fix pour les erreurs 'assemble')
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
