cmake_minimum_required(VERSION 3.14)

project(wizzy LANGUAGES CXX)

set(BINARY_NAME "wizzy")

include(flutter/generated_plugins.cmake)

add_subdirectory(runner)
