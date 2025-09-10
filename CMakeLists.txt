cmake_minimum_required(VERSION 3.20)
project(imgui_backends LANGUAGES C CXX)

# --------------------------- Options -----------------------------------------
option(IMGUI_BUILD_DEMO "Build imgui_demo.cpp" ON)

# Choose the platform backend
# Supported: SDL3 | GLFW | Win32 | None
set(IMGUI_PLATFORM "SDL3" CACHE STRING "ImGui platform backend")
set_property(CACHE IMGUI_PLATFORM PROPERTY STRINGS SDL3 GLFW Win32 None)

# Choose the renderer backend
# Supported: OpenGL3 | SDLRenderer3 | Vulkan | DX11 | None
set(IMGUI_RENDERER "OpenGL3" CACHE STRING "ImGui renderer backend")
set_property(CACHE IMGUI_RENDERER PROPERTY STRINGS OpenGL3 SDLRenderer3 Vulkan DX11 None)

# OpenGL function loader (only when IMGUI_RENDERER=OpenGL3)
# Supported: GLAD | GLEW | GL3W | CUSTOM | NONE
set(IMGUI_GL_LOADER "GLAD" CACHE STRING "OpenGL loader")
set_property(CACHE IMGUI_GL_LOADER PROPERTY STRINGS GLAD GLEW GL3W CUSTOM NONE)

# If using GLFW, you can hint the target name (varies by package)
# e.g. "glfw" or "glfw3"
set(IMGUI_GLFW_TARGET "" CACHE STRING "GLFW imported target name (optional)")

# --------------------------- Target ------------------------------------------
add_library(imgui STATIC)

target_compile_features(imgui PUBLIC cxx_std_17)
target_include_directories(imgui
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/backends
)

# Core ImGui sources
set(IMGUI_CORE
  imgui.cpp
  imgui_draw.cpp
  imgui_tables.cpp
  imgui_widgets.cpp
)
if(IMGUI_BUILD_DEMO)
  list(APPEND IMGUI_CORE imgui_demo.cpp)
endif()
target_sources(imgui PRIVATE ${IMGUI_CORE})

# ---------------------- Platform backend selection ---------------------------
if(IMGUI_PLATFORM STREQUAL "SDL3")
  target_sources(imgui PRIVATE backends/imgui_impl_sdl3.cpp)
  target_link_libraries(imgui PUBLIC SDL3::SDL3)

elseif(IMGUI_PLATFORM STREQUAL "GLFW")
  target_sources(imgui PRIVATE backends/imgui_impl_glfw.cpp)
  target_link_libraries(imgui PUBLIC ${IMGUI_GLFW_TARGET})

elseif(IMGUI_PLATFORM STREQUAL "Win32")
  if(NOT WIN32)
    message(FATAL_ERROR "IMGUI_PLATFORM=Win32 requires Windows")
  endif()
  target_sources(imgui PRIVATE backends/imgui_impl_win32.cpp)
  # Win32 backend itself usually doesn’t require extra libs here;
  # renderers (DX11 etc.) link their own system libs.

elseif(IMGUI_PLATFORM STREQUAL "None")
  message(STATUS "No platform backend selected for ImGui.")
else()
  message(FATAL_ERROR "Unsupported IMGUI_PLATFORM='${IMGUI_PLATFORM}'")
endif()

# ---------------------- Renderer backend selection ---------------------------
if(IMGUI_RENDERER STREQUAL "OpenGL3")
  target_sources(imgui PRIVATE backends/imgui_impl_opengl3.cpp)
  find_package(OpenGL REQUIRED)
  target_link_libraries(imgui PUBLIC OpenGL::GL)

  # Loader define + linking
  if(IMGUI_GL_LOADER STREQUAL "GLAD")
    target_compile_definitions(imgui PUBLIC IMGUI_IMPL_OPENGL_LOADER_GLAD)
    # Expect a 'glad' target to exist (add_subdirectory(glad) in your tree)
    target_link_libraries(imgui PUBLIC glad)

  elseif(IMGUI_GL_LOADER STREQUAL "GLEW")
    find_package(GLEW REQUIRED)
    target_compile_definitions(imgui PUBLIC IMGUI_IMPL_OPENGL_LOADER_GLEW)
    target_link_libraries(imgui PUBLIC GLEW::GLEW)

  elseif(IMGUI_GL_LOADER STREQUAL "GL3W")
    target_compile_definitions(imgui PUBLIC IMGUI_IMPL_OPENGL_LOADER_GL3W)
    # Provide a 'gl3w' target yourself if you choose this
    target_link_libraries(imgui PUBLIC gl3w)

  elseif(IMGUI_GL_LOADER STREQUAL "CUSTOM")
    target_compile_definitions(imgui PUBLIC IMGUI_IMPL_OPENGL_LOADER_CUSTOM)
    # Link your custom loader here if needed

  elseif(IMGUI_GL_LOADER STREQUAL "NONE")
    # Some platforms don’t need a loader; nothing to add
  else()
    message(FATAL_ERROR "Unsupported IMGUI_GL_LOADER='${IMGUI_GL_LOADER}'")
  endif()

elseif(IMGUI_RENDERER STREQUAL "SDLRenderer3")
  if(NOT IMGUI_PLATFORM STREQUAL "SDL3")
    message(FATAL_ERROR "SDLRenderer3 requires IMGUI_PLATFORM=SDL3")
  endif()
  target_sources(imgui PRIVATE backends/imgui_impl_sdlrenderer3.cpp)
  # (SDL3 already linked above)

elseif(IMGUI_RENDERER STREQUAL "Vulkan")
  target_sources(imgui PRIVATE backends/imgui_impl_vulkan.cpp)
  find_package(Vulkan REQUIRED)
  target_link_libraries(imgui PUBLIC Vulkan::Vulkan)

elseif(IMGUI_RENDERER STREQUAL "DX11")
  if(NOT WIN32)
    message(FATAL_ERROR "DX11 renderer requires Windows")
  endif()
  target_sources(imgui PRIVATE backends/imgui_impl_dx11.cpp)
  target_link_libraries(imgui PUBLIC d3d11 dxgi)

elseif(IMGUI_RENDERER STREQUAL "None")
  message(STATUS "No renderer backend selected for ImGui.")
else()
  message(FATAL_ERROR "Unsupported IMGUI_RENDERER='${IMGUI_RENDERER}'")
endif()

# Windows niceties (harmless elsewhere if compiled on Windows)
if(WIN32)
  target_compile_definitions(imgui PUBLIC WIN32_LEAN_AND_MEAN NOMINMAX)
endif()

# Handy alias for consumers
add_library(ImGui::imgui ALIAS imgui)