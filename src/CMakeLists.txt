#
# Application
#
add_executable(noto
    main.cpp
)

target_link_libraries(noto
    Qt5::Quick
    Qt5::Widgets
    Qt5::Qml
    KF5::ConfigCore
    KF5::I18n
)

install(TARGETS noto ${INSTALL_TARGETS_DEFAULT_ARGS})

install (FILES org.kde.noto.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})
