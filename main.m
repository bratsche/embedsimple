#import <Cocoa/Cocoa.h>
#include <gtk/gtk.h>
#include <gdk/gdkquartz.h>
#include "gtkembedcontainer.h"
#import "NSGtkView.h"

int
main (int argc, char *argv[])
{
  GtkWidget *window;
  GtkWidget *gtknsview;
  GdkWindow *gdkwindow;
  NSView *nsview;
  NSWindow *nswindow;

  gtk_init (&argc, &argv);

  // Create top-level GtkWindow
  window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
  gtk_widget_show (window);
  gdkwindow = gtk_widget_get_window (window);
  nswindow = gdk_quartz_window_get_nswindow (gdkwindow);

  NSBox *box = [[NSBox alloc] initWithFrame:nswindow.frame];
  NSButton *nsbutton = [[NSButton alloc] initWithFrame:box.frame];
  NSRect nsrect = [nswindow frame];
  NSGtkView *foo = [[NSGtkView alloc] initWithFrame:box.frame];
  [box setContentView:foo];
  [foo setNeedsDisplay:YES];

  // Create a GtkNSView. This is our NSView top-level
  gtknsview = gtk_ns_view_new (box);

  GtkWidget *bar = gtk_button_new_with_label ("gtk button");

  GtkWidget *embed = gtk_embed_container_new ();
  [foo setGtkParent:embed];
  [foo setGtkWidget:bar];
  gtk_embed_container_set_gtknsview (GTK_EMBED_CONTAINER (embed),
                                     GTK_NS_VIEW (gtknsview));

  // Add the embed container to the window
  gtk_container_add (GTK_CONTAINER (window), embed);
  gtk_widget_show_all (window);

  gtk_main ();

  return 0;
}
