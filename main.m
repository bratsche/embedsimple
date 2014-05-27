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

  window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
  gtk_widget_show (window);
  gdkwindow = gtk_widget_get_window (window);
  nsview = gdk_quartz_window_get_nsview (gdkwindow);
  nswindow = gdk_quartz_window_get_nswindow (gdkwindow);

  NSBox *box = [[NSBox alloc] initWithFrame:nswindow.frame];
  NSButton *nsbutton = [[NSButton alloc] initWithFrame:box.frame];
  NSGtkView *foo = [[NSGtkView alloc] initWithFrame:box.frame];
  //[box addSubview:nsbutton];
  [foo setNeedsDisplay:YES];

  gtknsview = gtk_ns_view_new (foo);
  gtk_widget_show_all (gtknsview);


  GtkWidget *bar = gtk_button_new_with_label ("gtk button");

  GtkWidget *embed = gtk_embed_container_new ();
  [foo setGtkParent:embed];
  [foo setGtkWidget:bar];
  gtk_embed_container_set_gtknsview (GTK_EMBED_CONTAINER (embed),
                                     GTK_NS_VIEW (gtknsview));
  gtk_widget_show_all (embed);


  // GtkWidget *embed = gtk_hbox_new (FALSE, 0);
  // gtk_container_add (GTK_CONTAINER (embed), gtknsview);
  // gtk_widget_show_all (embed);


  gtk_container_add (GTK_CONTAINER (window), embed);

  gtk_main ();

  return 0;
}
