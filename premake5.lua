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

        "./backends/imgui_impl_glfw.h",
        "./backends/imgui_impl_glfw.cpp",
        "./backends/imgui_impl_vulkan.h",
        "./backends/imgui_impl_vulkan.cpp",

        "./**.md",
        "./**.lua",
	}
    includedirs
    {
        "./",
        "./backends",
        _MAIN_SCRIPT_DIR .. "/Dependencies/GLFW/include"
    }
    links
    {
        "GLFW"
    }
    
    filter "system:windows"
        systemversion "latest"
        files
        {
            "./backends/imgui_impl_dx12.h",
            "./backends/imgui_impl_dx12.cpp",
        }
