project "ImGui"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    staticruntime "Off"

    files
    {
        "imconfig.h",
        "imgui.h",
        "imgui.cpp",
        "imgui_draw.cpp",
        "imgui_internal.h",
        "imgui_tables.cpp",
        "imgui_widgets.cpp",
        "imstb_rectpack.h",
        "imstb_textedit.h",
        "imstb_truetype.h",
        "imgui_demo.cpp",

        "./backends/imgui_impl_sdl3.h",
        "./backends/imgui_impl_sdl3.cpp",
        "./backends/imgui_impl_sdlgpu3.h",
        "./backends/imgui_impl_sdlgpu3.cpp",
        "./backends/imgui_impl_sdlgpu3_shaders.h",
        "./backends/imgui_impl_sdlrenderer3.h",
        "./backends/imgui_impl_sdlrenderer3.cpp",

        "./**.md"
    }
    includedirs
    {
        "./",
        "./backends",
        _MAIN_SCRIPT_DIR .. "/Dependencies/SDL/include"
    }
    links
    {
        "SDL3"
    }
