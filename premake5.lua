project "ImGui"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    staticruntime "Off"

    if OutputIntermediateDir == nil or OutputTargetDir == nil then
        targetdir ("Build/bin/%{prj.name}/")
        objdir    ("Build/obj/%{prj.name}/")

    else
        targetdir ("../../../" .. OutputTargetDir .. "")
        objdir    ("../../../" .. OutputIntermediateDir .. "")
    end

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
        "%{IncludeDir.GLFW}"
    }

    links
    {
        -- Default to GLFW backend
        "GLFW"
    }

    filter "configurations:Debug"
        runtime "Debug"
        buildoptions { "/MDd" } 
        symbols "On"

    filter "configurations:Optimized"
        runtime "Release"
        buildoptions { "/MDd" } 
        optimize "On"

    filter "configurations:Release"
        runtime "Release"
        optimize "On"
        buildoptions { "/MD" } 
        symbols "Off"