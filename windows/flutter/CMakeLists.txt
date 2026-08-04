set(FLUTTER_LIBRARY "${CMAKE_CURRENT_SOURCE_DIR}/ephemeral/flutter_windows.dll")
set(FLUTTER_ICU_DATA "${CMAKE_CURRENT_SOURCE_DIR}/ephemeral/icudtl.dat")
set(FLUTTER_LIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ephemeral")

list(APPEND FLUTTER_LIBRARY_HEADERS
  "${FLUTTER_LIB_DIR}/flutter_export.h"
  "${FLUTTER_LIB_DIR}/flutter_messenger.h"
  "${FLUTTER_LIB_DIR}/flutter_plugin_registrar.h"
  "${FLUTTER_LIB_DIR}/flutter_texture_registrar.h"
  "${FLUTTER_LIB_DIR}/flutter_windows.h"
)

set(FLUTTER_MANAGED_SOURCES
  "flutter/generated_plugin_registrant.cc"
  "flutter/generated_plugin_registrant.h"
)

function(apply_standard_settings TARGET)
  target_compile_features(${TARGET} PRIVATE cxx_std_17)
  target_compile_options(${TARGET} PRIVATE /W4 /WX /wd4201)
endfunction()
