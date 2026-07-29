cmake_minimum_required(VERSION 3.14)

# 1. ANTIDOTE : On définit la macro ici pour qu'elle soit visible par tous les plugins
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
    if(MSVC)
        target_compile_options(${TARGET} PRIVATE /W4 /WX /wd4201)
    endif()
endmacro()

# 2. POLITIQUES
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# 3. ON CONSTRUIT L'APPLICATION D'ABORD ✅
# Cela permet de créer la cible "wizzy" avant que les plugins ne la cherchent
add_subdirectory(runner)

# 4. ON CHARGE LES PLUGINS APRÈS ✅
# Maintenant que "wizzy" existe, le fichier suivant peut s'y lier sans erreur
include(flutter/generated_plugins.cmake)
