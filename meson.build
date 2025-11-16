project('vala app', 'vala', 'c')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk4'),
    dependency('webkitgtk-6.0'),
    dependency('gee-0.8'),
    dependency('json-glib-1.0')
]

sources = files('src/main.vala', 
                'src/TabbedWebView.vala',
                'src/SettingsSidebar.vala',
                'src/SegmentedButton.vala')

executable('platinum-gtk', sources, dependencies: dependencies)