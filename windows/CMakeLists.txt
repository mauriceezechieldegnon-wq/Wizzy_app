cmake_minimum_required(VERSION 3.14)

# 1. ANTIDOTE : Définir la macro AVANT tout le reste
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

# 4. CRÉATION DE L'EXÉCUTABLE ICI ✅
# On pointe vers le dossier runner/ pour trouver les fichiers C++
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

# 5. CHARGER LES PLUGINS MAINTENANT
# Comme 'wizzy' a été créé juste au-dessus, l'include va enfin fonctionner !
include(flutter/generated_plugins.cmake)

# On injecte les sources gérées par Flutter (si le fichier plugins en a généré)
if (FLUTTER_MANAGED_SOURCES)
  target_sources(${BINARY_NAME} PRIVATE ${FLUTTER_MANAGED_SOURCES})
endif()

# 6. RÉGLAGES ET LIAISONS
apply_standard_settings(${BINARY_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

# Gestion des dépendances de compilation
if(NOT TARGET flutter_assemble)
    add_custom_target(flutter_assemble)
endif()
add_dependencies(${BINARY_NAME} flutter_assemble)

# 7. LIAISON AUTOMATIQUE DES PLUGINS (Firebase, Audioplayers, etc.)
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  if(TARGET ${plugin})
    target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
    if(TARGET ${plugin}_assemble)
      add_dependencies(${BINARY_NAME} ${plugin}_assemble)
    endif()
  endif()
endforeach()
