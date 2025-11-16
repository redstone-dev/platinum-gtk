class SegmentedButtonGroup : Gtk.Box {
    public string selected_item = null;
    public SegmentedButtonGroup (string[] items, string? default = null) {
        Object (orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);

        if (default != null) {
            selected_item = default;
            this.item_changed (default);
        }

        this.add_css_class ("linked");

        foreach (var item in items) {
            var button = new Gtk.Button.with_label (item);
            button.clicked.connect (() => {
                this.selected_item = item;
                this.item_changed (item);
            });

            // TODO: instead of flat, just show the button border with no background
            // this.item_changed.connect ((_, item_) => {
            // if (item == item_) {
            // button.remove_css_class ("flat");
            // } else {
            // button.add_css_class ("flat");
            // }
            // });
            this.append (button);
        }
    }

    public signal void item_changed (string item);

    public string get_current_item () {
        return this.selected_item;
    }
}
