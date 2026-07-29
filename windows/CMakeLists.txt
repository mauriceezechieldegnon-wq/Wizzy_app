cmake_minimum_required(VERSION 3.14)

# 1. ANTIDOTE GLOBAL (Doit être avant le projet pour protéger les plugins)
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

# 2. CHARGER LE CŒUR DE FLUTTER (Celui du dossier windows/flutter)
include(flutter/CMakeLists.txt)

# 3. CHARGER LES PLUGINS (Audioplayers, Firebase, etc.)
include(flutter/generated_plugins.cmake)

# 4. ENTRER DANS LE DOSSIER RUNNER
add_subdirectory(runner)
