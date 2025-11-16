public class SettingsSidebar : Gtk.Box {
    private Gtk.Box vbox;
    public bool is_open;
    public SettingsSidebar () {

        Object (orientation: Gtk.Orientation.HORIZONTAL, spacing: 4);
        this.vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 4);
        var scrolled_window = new Gtk.ScrolledWindow();
        scrolled_window.set_hexpand(true);

        this.vbox.append(new Gtk.Label("Settings"));

        scrolled_window.child = this.vbox;
        this.append(scrolled_window);

        this.hide();
        this.is_open = false;
    }

    public void toggle() {
        if (this.is_open) {
            this.is_open = false;
            this.hide();
        } else {
            this.is_open = true;
            this.show();
        }
    }

    public void add_child (string key, string display_name, Gtk.Widget widget) {
        var hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4);
        hbox.append(new Gtk.Label(display_name));
        hbox.append(widget);
        this.vbox.append(hbox);
    }

    public void set_field (string key, Variant value) {
        this.set_data<Variant> ("settings:" + key, value);
        this.settings_changed (key);
    }

    public Variant get_field (string key) {
        return this.get_data<Variant> ("settings:" + key);
    }

    public signal void settings_changed(string key);
}