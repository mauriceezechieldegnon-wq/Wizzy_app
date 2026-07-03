cmake_minimum_required(VERSION 3.14)

# --- FIX POUR AUDIOPLAYERS ET COMPILATEURS RÉCENTS ---
# Cette ligne empêche l'erreur STL1011 sur GitHub Actions
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

# Réglage de politique pour la compatibilité Firebase
cmake_policy(SET CMP0048 NEW)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "WIZZY")

include(flutter/generated_plugins.cmake)

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
  "Run_configuration.cpp"
  "Run_configuration.h"
  ${FLUTTER_MANAGED_SOURCES}
)

apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})

flutter_get_bundle_flags(${BINARY_NAME} FLUTTER_BUNDLE_FLAGS)
add_dependencies(${BINARY_NAME} flutter_assemble)
target_compile_definitions(${BINARY_NAME} PRIVATE ${FLUTTER_BUNDLE_FLAGS})

# Liaison des plugins (Firebase, Audioplayers, etc.)
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()

# Gestion des ressources et icônes
get_target_property(target_type ${BINARY_NAME} TYPE)
if (target_type STREQUAL "EXECUTABLE")
  set_target_properties(${BINARY_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/runner"
  )
endif()
