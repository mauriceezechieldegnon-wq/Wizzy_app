cmake_minimum_required(VERSION 3.14)

# 1. FIX POUR FIREBASE ET AUDIOPLAYERS
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

# 2. NOM DU PROJET (Vérifie bien que c'est 'wizzy' dans ton pubspec)
set(BINARY_NAME "wizzy")

# 3. ON APPELLE LE DOSSIER RUNNER SANS RIEN CHARGER D'AUTRE ICI
add_subdirectory(runner)
