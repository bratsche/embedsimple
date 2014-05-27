#import <Cocoa/Cocoa.h>
#include <gtk/gtk.h>

@interface NSGtkView : NSView
{
  NSTrackingRectTag trackingTag;
  GtkWidget *parent;
  GtkWidget *widget;
}

- (void)setGtkParent:(GtkWidget*)parent;
- (void)setGtkWidget:(GtkWidget*)child;

@end