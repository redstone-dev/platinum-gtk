project('vala app', 'vala', 'c')

dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gtk4'),
  dependency('webkitgtk-6.0'),
  dependency('gee-0.8'),
]

sources = files(
  'src/IconButton.vala',
  'src/SegmentedButton.vala',
  'src/SettingsSidebar.vala',
  'src/TabbedWebView.vala',
  'src/main.vala',
)

executable('platinum-gtk', sources, dependencies: dependencies)
