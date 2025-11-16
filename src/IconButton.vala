class IconButton : Gtk.Button {
    public IconButton (string icon_name) {
        Object ();
        var image = new Gtk.Image ();
        image.icon_name = icon_name;
        this.child = image;
    }

    public IconButton.flat (string icon_name) {
        Object ();
        var image = new Gtk.Image ();
        image.icon_name = icon_name;
        this.child = image;
        this.add_css_class ("flat");
    }

    public IconButton.with_label (string icon_name, string label) {
        Object ();
        var image = new Gtk.Image ();
        image.icon_name = icon_name;
        var text = new Gtk.Label (label);

        var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        hbox.append (image);
        hbox.append (text);

        this.child = hbox;
    }
}
