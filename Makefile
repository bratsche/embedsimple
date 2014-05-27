CFLAGS = -D_REENTRANT -I/Users/cody/xam/bockbuild/profiles/monodevelop-mac-dev/build-root/_install/include/gtk-2.0 -I/Users/cody/xam/bockbuild/profiles/monodevelop-mac-dev/build-root/_install/lib/gtk-2.0/include -I/Users/cody/xam/bockbuild/profiles/monodevelop-mac-dev/build-root/_install/include/atk-1.0 -I/Users/cody/xam/bockbuild/profiles/monodevelop-mac-dev/build-root/_install/include/cairo -I/Users/cody/xam/bockbuild/profiles/monodevelop-mac-dev/build-root/_install/include/gdk-pixbuf-2.0 -I/Users/cody/xam/bockbuild/profiles/monodevelop-mac-dev/build-root/_install/include/pango-1.0 -I/Users/cody/xam/bockbuild/profiles/monodevelop-mac-dev/build-root/_install/include/glib-2.0 -I/Users/cody/xam/bockbuild/profiles/monodevelop-mac-dev/build-root/_install/lib/glib-2.0/include -I/Users/cody/xam/bockbuild/profiles/monodevelop-mac-dev/build-root/_install/include/pixman-1 -I/Users/cody/xam/bockbuild/profiles/monodevelop-mac-dev/build-root/_install/include/freetype2 -I/Users/cody/xam/bockbuild/profiles/monodevelop-mac-dev/build-root/_install/include/libpng14

LDFLAGS = -L/Users/cody/xam/bockbuild/profiles/monodevelop-mac-dev/build-root/_install/lib -lgtk-quartz-2.0 -lgdk-quartz-2.0 -latk-1.0 -lgio-2.0 -lpangocairo-1.0 -lgdk_pixbuf-2.0 -lpango-1.0 -lcairo -lgobject-2.0 -lglib-2.0 -lintl


all:
	mkdir -p hello.app
	mkdir -p hello.app/Contents
	mkdir -p hello.app/Contents/MacOS
	gcc main.m gtkembedcontainer.c NSGtkView.m $(CFLAGS) $(LDFLAGS) -ObjC -g -arch i386 -framework Cocoa -framework Foundation -o hello.app/Contents/MacOS/hello
	cp Info.plist hello.app/Contents/
clean:
	rm -r *.app
