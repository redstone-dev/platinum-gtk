public class Platinum : Gtk.Application {
    private const string APP_ID = "io.github.redstone-dev.Platinum";

    private TabbedWebView tabbed_web_view;

    // HeaderBar contents
    private Gtk.Button new_tab_button;
    private Gtk.Entry  url_bar;
    private Gtk.Button go_button;

    private Gtk.Button back_button;
    private Gtk.Button forward_button;
    private Gtk.Button refresh_button;

    //  private Gtk.MenuButton menu_button;
    private Regex protocol_regex;
    private Regex domain_regex;

    private string search_engine_uri_format = "https://google.com/search?q=%s";

    public Platinum () {
        Object (application_id: APP_ID);

        try {
            this.protocol_regex = new Regex (".*://.*");
            this.domain_regex = new Regex(".*\\..*");
        } catch (RegexError e) {
            critical("RegexError: %s", e.message);
        }
    }

    public override void activate () {
        
        var window = new Gtk.ApplicationWindow (this) {
            title = "Platinum"
        };
        window.set_default_size (800, 600);
        
        // Header bar. Contains the search bar and the navigation buttons
        this.new_tab_button = new Gtk.Button.with_label ("New Tab");
        this.new_tab_button.clicked.connect (() => {
            this.tabbed_web_view.add_new_tab (
                "https://google.com"
            );
        });
        this.url_bar = new Gtk.Entry() {
            placeholder_text = "Search or enter URL",
        };
        this.url_bar.set_hexpand (true);
        this.url_bar.activate.connect (this.go_button_handler);
        this.go_button = new Gtk.Button.with_label ("Go");
        this.go_button.clicked.connect (this.go_button_handler);

        //this.menu_button = new Gtk.MenuButton ();

        var header = new Gtk.HeaderBar();
        header.pack_start (this.new_tab_button);
        header.pack_start (this.url_bar);
        header.pack_start (this.go_button);

        this.back_button = new Gtk.Button.with_label("<-");
        this.back_button.add_css_class ("circular");
        this.back_button.clicked.connect(() => 
            this.tabbed_web_view.current_webview->go_back ());
        this.forward_button = new Gtk.Button.with_label("->");
        this.forward_button.add_css_class ("circular");
        this.forward_button.clicked.connect(() => 
            this.tabbed_web_view.current_webview->go_forward ());
        this.refresh_button = new Gtk.Button.with_label ("Refresh");
        this.refresh_button.clicked.connect(() => 
            this.tabbed_web_view.current_webview->reload ());

        header.pack_end (refresh_button);
        header.pack_end (forward_button);
        header.pack_end (back_button);
        // End of header bar

        window.set_titlebar (header);

        this.tabbed_web_view = new TabbedWebView();
        this.tabbed_web_view.add_new_tab ("file://" + Environment.get_current_dir () + "/../pages/new_window.html");
        
        
        var vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 4);
        vbox.append(this.tabbed_web_view);
        vbox.set_vexpand (true);

        window.child = vbox;
        window.present ();
    }

    public void go_button_handler() {
        if (!this.protocol_regex.match (this.url_bar.text) 
            && this.domain_regex.match (this.url_bar.text)) 
        {
            var fmt = "https://%s".printf (this.url_bar.text);

            this.tabbed_web_view.set_uri (fmt);
            return;
        } 

        var fmt = this.search_engine_uri_format.printf (this.url_bar.text);
        this.tabbed_web_view.set_uri (fmt);
    }

    public static int main (string[] args) {
        var app = new Platinum ();
        return app.run (args);
    }
}