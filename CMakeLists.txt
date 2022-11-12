cmake_minimum_required(VERSION 3.16)

project(Velocimetro VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_INSTALL_LIBDIR "lib")

message("CMAKE_CURRENT_SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(appVelocimetro
    main.cpp Imagens.qrc Privacy_Policy.txt android/AndroidManifest.xml
    MANUAL_FINALIZATION
)

qt_add_qml_module(appVelocimetro
    URI Velocimetro
    VERSION 1.0
    QML_FILES main.qml 
)

set_target_properties(appVelocimetro PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

set_property(TARGET appVelocimetro APPEND PROPERTY
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
)

target_link_libraries(appVelocimetro
    PRIVATE Qt6::Quick)

install(TARGETS appVelocimetro
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

qt_finalize_executable(appVelocimetro)
