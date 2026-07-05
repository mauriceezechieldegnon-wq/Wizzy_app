cmake_minimum_required(VERSION 3.14)

# 1. ANTIDOTE POUR AUDIOPLAYERS
macro(apply_standard_settings TARGET)
    if(MSVC)
        target_compile_options(${TARGET} PRIVATE /W4 /WX /wd4201)
    endif()
endmacro()

# 2. COMPATIBILITÉ FIREBASE
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# 3. INITIALISATION FLUTTER
set(FLUTTER_MANAGED_SOURCES "")
include(flutter/generated_plugins.cmake)

# 4. DÉFINITION DE L'EXÉCUTABLE AVEC LES BONS CHEMINS ✅
# On ajoute "runner/" devant chaque fichier car c'est là qu'ils se cachent
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

# 5. RÉGLAGES ET LIAISONS
apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison des plugins (Firebase, Audioplayers, etc.)
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
