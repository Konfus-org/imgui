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

        -- Need to swap out backends depending on platform
        -- Default is GLFW and OpenGL
        "./backends/imgui_impl_glfw.h",
        "./backends/imgui_impl_glfw.cpp",
        "./backends/imgui_impl_opengl3.h",
        "./backends/imgui_impl_opengl3.cpp",

        "./**.md",
        "./**.lua",
	}
    includedirs
    {
        "./",
        "./backends",

        -- Default to GLFW backend
        _MAIN_SCRIPT_DIR .. "/Dependencies/GLFW/include"
    }
    links
    {
        -- Default to GLFW backend
        "GLFW"
    }