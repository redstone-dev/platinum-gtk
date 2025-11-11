public class TabBar : Gtk.Box {

    //  public Gee.ArrayList<Tab?> tabs;
    public Gtk.Button *current_tab;

    private Gtk.Button close_tab_button;
    public Gtk.Button new_tab_button;

    private WebKit.WebView* webview;
    private Gtk.Box tab_container;

    public TabBar () {
        // initialize the Box
        Object (orientation: Gtk.Orientation.HORIZONTAL, spacing: 4);
    }

    public void activate_ (WebKit.WebView* webview, string default_uri) {
        this.webview = webview;
        this.new_tab_button = new Gtk.Button.with_label ("New Tab");
        this.new_tab_button.clicked.connect(() => {
            new_tab(default_uri);
        });
        this.append(new_tab_button);

        this.close_tab_button = new Gtk.Button.with_label("Close Tab");
        this.close_tab_button.clicked.connect(() => this.close_tab());
        this.append(this.close_tab_button);

        var scrolledwindow = new Gtk.ScrolledWindow();
        scrolledwindow.set_hexpand(true);
        this.tab_container = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4);
        this.tab_container.set_hexpand(true);

        scrolledwindow.child = this.tab_container;
        this.append(scrolledwindow);
    }

    public string get_tab_title(Gtk.Button tab) {
        return tab.get_data<string>("title");
    }
    public string get_tab_uri  (Gtk.Button tab) {
        return tab.get_data<string>("uri");
    }

    private Gtk.Button create_tab_button(string title, string uri) {
        var button = new Gtk.Button.with_label (title);
        button.set_data<string>("title", title);
        button.set_data<string>("uri", uri);
        button.clicked.connect (() => {
            print ("Clicked %s (%s)\n", 
                get_tab_title(button), get_tab_uri(button));
            this.current_tab = button;
            this.webview->load_uri(get_tab_uri(button));
        });
        return button;  
    }

    public void new_tab(string uri) {
        this.webview->load_uri(uri);
        var title = this.webview->title;
        this.tab_container.append(create_tab_button(title, uri));
    }

    public void set_current_tab_uri(string new_uri) {
        this.current_tab->set_data<string> ("uri", new_uri);
    }

    public void close_tab() {
        this.current_tab->hide();
        this.current_tab = (Gtk.Button)this.tab_container.get_first_child();
    }
}