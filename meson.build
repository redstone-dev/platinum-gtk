project('vala app', 'vala', 'c')

dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gtk4'),
  dependency('webkitgtk-6.0'),
  dependency('gee-0.8'),
  dependency('libpeas-1.0')
]

sources = files(
  'src/IconButton.vala',
  'src/SegmentedButtonGroup.vala',
  'src/SettingsSidebar.vala',
  'src/TabbedWebView.vala',
  'src/main.vala',
) + files(
  'src/Plugin.vala',
) + files(
  'plugins/example.plugin/ExamplePlugin.vala'
)

executable('platinum-gtk', sources, dependencies: dependencies)
