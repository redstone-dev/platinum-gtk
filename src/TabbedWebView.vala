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

        var tab_label = new Gtk.Label("Loading...");
        var close_tab_button = new Gtk.Button.with_label ("X");
        close_tab_button.add_css_class ("circular");
        var label_and_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 4);
        label_and_button_box.append (tab_label);
        label_and_button_box.append (close_tab_button);

        this.notebook.append_page (webview, label_and_button_box);

        close_tab_button.clicked.connect (() => {
            var page = this.notebook.page_num (webview);
            this.notebook.remove_page (page);
            webview.destroy ();
        });

        webview.load_changed.connect ((wv, event) => {
            if (event == WebKit.LoadEvent.STARTED)  {
                tab_label.set_text ("Loading...");
            }
            if (event == WebKit.LoadEvent.FINISHED) {
                this.url_bar->set_text (wv.get_uri());
                tab_label.set_text(wv.get_title());
            }
        });
    }
    
    public void set_uri(string uri) {
        this.current_webview->load_uri(uri);

    }
}