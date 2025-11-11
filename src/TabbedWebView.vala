public class TabbedWebView : Gtk.Box {
    private Gtk.Notebook notebook;
    public WebKit.WebView* current_webview;
    public Gtk.Entry* url_bar;
    public uint current_tab_id;
    public TabbedWebView () {
        Object (orientation: Gtk.Orientation.VERTICAL, spacing: 4);

        this.notebook = new Gtk.Notebook ();
        
        this.notebook.set_tab_pos (Gtk.PositionType.BOTTOM);
        this.notebook.scrollable = true;
        this.notebook.switch_page.connect ((page, page_num) => {
            this.current_webview = (WebKit.WebView)page;
            this.current_tab_id = page_num;
        });

        this.append(notebook);
    }

    public void add_new_tab (string uri) {
        var webview = new WebKit.WebView ();
        webview.load_uri(uri);
        webview.set_hexpand (true);
        webview.set_vexpand (true);
        webview.load_changed.connect ((wv, event) => {
            url_bar->text = wv.get_uri();
        });
        var tab_label = new Gtk.Label("New Tab");
        this.notebook.append_page (webview, tab_label);
    }

    public void set_uri(string uri) {
        this.current_webview->load_uri(uri);

    }
}