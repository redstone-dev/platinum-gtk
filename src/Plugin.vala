namespace Plugins {
    public interface Plugin : Object {
        public abstract bool activate();
        public abstract bool deactivate();

        public signal void loaded();
        public signal void unloaded();
    }
}