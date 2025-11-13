public errordomain SidebarItemError {
    NOT_UNIQUE,
    NULL_VALUE,
    UNSUPPORTED_TYPE,
}

public enum InputWidgetType {
    CHECKBOX,
    ENTRY,

}

public struct SettingsSidebarItem<T> {
    string key;
    string displayName;
    T value;
    InputWidgetType widgetType;
}

public class SettingsSidebarModel {
    public Gee.ArrayList<SettingsSidebarItem?> items 
        = new Gee.ArrayList<SettingsSidebarItem?> ();

    public SettingsSidebarModel () {}
    public SettingsSidebarItem? get_item(string key) {
        return items.first_match((item) => {
            return item.key == key;
        });
    }
    public void add_item<T>(string key, string displayname, 
                            InputWidgetType widgetType) 
                            throws SidebarItemError {
        if (this.get_item(key) != null) {
            throw new SidebarItemError.NOT_UNIQUE
                ("Sidebar key '%s' is not unique".printf(key));
        }
        this.items.add(SettingsSidebarItem<T>() {
            key = key,
            displayName = displayname,
            value = null,
            widgetType = widgetType,
        });
    }
    public Gee.ArrayList<SettingsSidebarItem?> get_items() {
        return this.items;
    }
}

public class SettingsSidebar : Gtk.Box {
    public SettingsSidebarModel model;
    public Gtk.Box vbox;
    public bool is_open;
    public SettingsSidebar (SettingsSidebarModel model) {
        Object (orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);
        this.model = model;
        this.vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 4);
        var scrolled_window = new Gtk.ScrolledWindow();
        scrolled_window.set_hexpand(true);

        this.vbox.append(new Gtk.Label("Settings"));

        foreach (var item in this.model.items) {
            print("Added item '%s' (%s)".printf(item.key, item.displayName));
            switch (item.widgetType) {
                
                case InputWidgetType.CHECKBOX:
                    print("(checkbox)");
                    var checkbox = new Gtk.CheckButton();
                    checkbox.label = item.displayName;
                    checkbox.toggled.connect(() => {
                        item.value = checkbox.get_active();
                        this.settings_changed(item.key);
                    });
                    //  checkbox.set_hexpand(true);
                    this.vbox.append(checkbox);
                    break;
                case InputWidgetType.ENTRY:
                    print("(entry)");
                    var label = new Gtk.Label(item.displayName);
                    var entry = new Gtk.Entry();
                    var hbox  = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4);

                    hbox.append(label);
                    hbox.append(entry);

                    this.vbox.append(hbox);
                    
                    break;
            }
        }

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

    public signal void settings_changed(string key);
}