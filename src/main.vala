public class Platinum : Gtk.Application {
    private const string APP_ID = "io.github.redstone-dev.Platinum";

    private TabbedWebView tabbed_web_view;

    // HeaderBar contents
    private Gtk.Button settings_button;

    private Gtk.Button new_tab_button;
    private Gtk.Entry url_bar;
    private Gtk.Button go_button;

    private Gtk.Button back_button;
    private Gtk.Button forward_button;
    private Gtk.Button refresh_button;

    // private Gtk.MenuButton menu_button;
    private Regex protocol_regex;
    private Regex domain_regex;

    private SettingsSidebar settings_sidebar;

    private string search_engine_uri_format = "https://google.com/search?q=%s";
    private Gtk.Window window;

    private Gtk.ShortcutController shortcut_controller = new Gtk.ShortcutController ();

    public Platinum () {
        Object (application_id: APP_ID);

        try {
            this.protocol_regex = new Regex (".*://.*");
            this.domain_regex = new Regex (".*\\..*");
        } catch (RegexError e) {
            critical ("RegexError: %s", e.message);
        }
    }

    public override void activate () {

        this.window = new Gtk.ApplicationWindow (this) {
            title = "Platinum"
        };
        this.window.set_default_size (1000, 600);

        this.settings_sidebar = new SettingsSidebar ();

        // Header bar. Contains the search bar and the navigation buttons
        this.settings_button = new IconButton.flat ("open-menu-symbolic");

        settings_button.clicked.connect (() => {
            this.settings_sidebar.toggle ();
            if (this.settings_sidebar.is_open) {
                this.settings_button.remove_css_class ("flat");
            } else {
                this.settings_button.add_css_class ("flat");
            }
        });
        this.url_bar = new Gtk.Entry () {
            placeholder_text = "Search or enter URL",
        };
        this.url_bar.set_hexpand (true);
        this.url_bar.activate.connect (this.go_button_handler);
        this.go_button = new Gtk.Button.with_label ("Go");
        this.go_button.clicked.connect (this.go_button_handler);

        // this.menu_button = new Gtk.MenuButton ();

        var header = new Gtk.HeaderBar ();
        header.pack_start (this.settings_button);
        header.pack_start (this.new_tab_button);
        header.pack_start (this.url_bar);
        header.pack_start (this.go_button);

        this.new_tab_button = new IconButton.with_label ("tab-new-symbolic", "New Tab");
        this.new_tab_button.clicked.connect (() => {
            this.tabbed_web_view.add_new_tab ("https://google.com");
            this.tabbed_web_view.notebook.set_current_page (this.tabbed_web_view.notebook.get_n_pages () - 1);
        });
        this.back_button = new IconButton.flat ("go-previous-symbolic");
        this.back_button.add_css_class ("circular");
        this.back_button.clicked.connect (() =>
                                          this.tabbed_web_view.current_webview->go_back ());
        this.forward_button = new IconButton.flat ("go-next-symbolic");
        this.forward_button.add_css_class ("circular");
        this.forward_button.clicked.connect (() =>
                                             this.tabbed_web_view.current_webview->go_forward ());
        this.refresh_button = new IconButton.flat ("object-rotate-left-symbolic");
        this.refresh_button.clicked.connect (() =>
                                             this.tabbed_web_view.current_webview->reload ());


        header.pack_end (refresh_button);
        header.pack_end (forward_button);
        header.pack_end (back_button);
        header.pack_end (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        header.pack_end (new_tab_button);
        // End of header bar

        this.window.set_titlebar (header);

        this.tabbed_web_view = new TabbedWebView ();
        this.tabbed_web_view.add_new_tab ("file://" + Environment.get_current_dir () + "/../pages/quickstart.html");

        var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 4);
        vbox.append (this.tabbed_web_view);
        vbox.set_vexpand (true);

        var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 4);
        populate_settings_sidebar ();
        hbox.append (settings_sidebar);
        hbox.append (vbox);

        //  set_keyboard_shortcuts ();

        this.window.child = hbox;
        this.window.present ();
    }

    public void populate_settings_sidebar () {
        var tab_bar_edge = new SegmentedButton ({ "Top", "Bottom", "Left", "Right" }, "Bottom");
        tab_bar_edge.item_changed.connect ((_, item) => {
            this.settings_sidebar.set_field ("platinum.ui.tabBarEdge", item);
            switch (item) {
                case "Top":
                    this.tabbed_web_view.notebook.tab_pos = Gtk.PositionType.TOP;
                    break;
                case "Bottom":
                    this.tabbed_web_view.notebook.tab_pos = Gtk.PositionType.BOTTOM;
                    break;
                case "Left":
                    this.tabbed_web_view.notebook.tab_pos = Gtk.PositionType.LEFT;
                    break;
                case "Right":
                    this.tabbed_web_view.notebook.tab_pos = Gtk.PositionType.RIGHT;
                    break;
                default:
                    warning ("Tab Bar Edge: Invalid value %s".printf (item));
                    break;
            }
        });
        this.settings_sidebar.add_child ("platinum.ui.tabBarEdge", "Tab Bar Edge", tab_bar_edge);

        var search_engine = new Gtk.Entry () {
            placeholder_text = "https://google.com/search?q=%s"
        };
        search_engine.activate.connect (() => {
            if (search_engine.get_text ().contains ("%s"))
                this.search_engine_uri_format = search_engine.get_text ();
        });
        this.settings_sidebar.add_child
            ("platinum.searchEngineFormatString", "Search Engine Format String",
            search_engine, true);
    }

    public void go_button_handler () {
        if (!this.protocol_regex.match (this.url_bar.text)
            && this.domain_regex.match (this.url_bar.text)) {
            var fmt = "https://%s".printf (this.url_bar.text);

            this.tabbed_web_view.set_uri (fmt);
            return;
        }

        var fmt = this.search_engine_uri_format.printf (this.url_bar.text);
        this.tabbed_web_view.set_uri (fmt);
    }

    // TODO: fix segfaulting
    // private void set_keyboard_shortcuts () {
    // var new_tab_shortcut = new Gtk.Shortcut (new Gtk.KeyvalTrigger (Gdk.Key.T, Gdk.ModifierType.NO_MODIFIER_MASK), new Gtk.CallbackAction (() => {
    // print ("Hello world");

    // return true;
    // }));
    // this.shortcut_controller.add_shortcut (new_tab_shortcut);

    // this.window.add_controller (this.shortcut_controller);
    // }

    public static int main (string[] args) {
        var app = new Platinum ();
        return app.run (args);
    }
}
