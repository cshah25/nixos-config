cmake_minimum_required(VERSION 3.21)
project(pond LANGUAGES CXX)
find_package(Qt6 6.11 REQUIRED COMPONENTS Gui Qml Quick DBus)
find_package(KF6NetworkManagerQt REQUIRED)
qt_standard_project_setup(REQUIRES 6.7)

set(POND_QML_DIR "lib/qt-6/qml/Pond")

# Pond.System: logind, network and caps-lock state for the shell and lockscreen
qt_add_qml_module(pond_system
    URI Pond.System
    VERSION 1.0
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Pond/System"
    SOURCES lockscreen/frontend/system/NetworkStatus.h lockscreen/frontend/system/Logind.h lockscreen/frontend/system/CapsLock.h
)
target_include_directories(pond_system PRIVATE lockscreen/frontend/system)
target_link_libraries(pond_system PRIVATE KF6::NetworkManagerQt Qt6::DBus Qt6::Gui wayland-client)

# Pond.Screenshot.Native: drag the screenshot preview out as a file
qt_add_qml_module(pond_screenshot_drag
    URI Pond.Screenshot.Native
    VERSION 1.0
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Pond/Screenshot/Native"
    SOURCES screenshot/native/ScreenshotDrag.h
)
target_include_directories(pond_screenshot_drag PRIVATE screenshot/native)
target_link_libraries(pond_screenshot_drag PRIVATE Qt6::Quick)

function(pond_install_plugin target module)
    install(TARGETS ${target} ${target}plugin LIBRARY DESTINATION "${POND_QML_DIR}/${module}")
    install(FILES "${CMAKE_BINARY_DIR}/Pond/${module}/qmldir" "${CMAKE_BINARY_DIR}/Pond/${module}/${target}.qmltypes"
        DESTINATION "${POND_QML_DIR}/${module}")
endfunction()
pond_install_plugin(pond_system System)
pond_install_plugin(pond_screenshot_drag Screenshot/Native)

# Plain QML modules
install(DIRECTORY wallpaper/ DESTINATION "${POND_QML_DIR}/Wallpaper" PATTERN daylight EXCLUDE)
install(DIRECTORY wallpaper/daylight/ DESTINATION "${POND_QML_DIR}/Daylight")
install(DIRECTORY screenshot/ DESTINATION "${POND_QML_DIR}/Screenshot" PATTERN native EXCLUDE)

# Quickshell configs
install(DIRECTORY shell lockscreen DESTINATION share/pond)
