project "ImGui"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    staticruntime "Off"

    local vulkan_sdk = os.getenv("VULKAN_SDK")
    assert(vulkan_sdk, "Vulkan SDK not found! Make sure you have Vulkan installed! After install restart PC to make the SDK env path to be available.")

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

        "./**.md"
	}
    libdirs
    {
        vulkan_sdk .. "/Lib" 
    }
    includedirs
    {
        "./",
        "./backends",
        vulkan_sdk .. "/Include",
        _MAIN_SCRIPT_DIR .. "/Dependencies/GLFW/include"
    }
    links
    {
        "GLFW",
        "vulkan-1"
    }
    
    filter "system:windows"
        systemversion "latest"
        files
        {
            "./backends/imgui_impl_dx12.h",
            "./backends/imgui_impl_dx12.cpp",
        }
