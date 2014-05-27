#import "NSGtkView.h"

@implementation NSGtkView

static void update_allocation (GtkWidget *widget, NSGtkView *nsview)
{
  GdkScreen *screen = gtk_widget_get_screen (widget);
  int height = gdk_screen_get_height (screen);
  GtkAllocation allocation;
  NSRect fr = [nsview frame];
  NSRect rect = [nsview convertRect:fr toView:nsview];
  NSPoint pt = [nsview convertPointFromBacking:rect.origin];

  allocation.x = pt.x;
  allocation.y = pt.y; // height - (int)pt.y - rect.size.height;
  allocation.width = rect.size.width;
  allocation.height = rect.size.height;

  gtk_widget_size_allocate (widget, &allocation);

  //g_print ("allocation [%d,%d,%d,%d]\n", allocation.x, allocation.y, allocation.width, allocation.height);
}

- (id)initWithFrame:(NSRect)frameRect
{
  if ((self = [super initWithFrame:frameRect]) == nil)
    {
      return self;
    }

  trackingTag = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];

  return self;
}

- (void)dealloc
{
  [self removeTrackingRect:trackingTag];
  [super dealloc];
}

- (void)viewWillDraw
{
  update_allocation (widget, self);
}

- (void)internalMouseEvent:(NSEvent *)evt
{
  GdkWindow *gdkwindow = gtk_widget_get_window (widget);
  NSWindow *nswindow = gdk_quartz_window_get_nswindow (gdkwindow);
  NSView *nsview = [nswindow contentView];
  NSEvent *event = [NSEvent mouseEventWithType: [evt type]
                                      location: [evt locationInWindow]
                                 modifierFlags: [evt modifierFlags]
                                     timestamp: [[NSApp currentEvent] timestamp]
                                  windowNumber: [nswindow windowNumber]
                                       context: nil
                                   eventNumber: 0
                                    clickCount: [evt clickCount]
                                      pressure: 1.0];

  [NSApp postEvent:event atStart: NO];

  gtk_widget_queue_draw (widget);

  [self setNeedsDisplay:YES];
}

- (void)mouseMoved:(NSEvent *)evt
{
  [self internalMouseEvent:evt];
}

- (void)mouseDown:(NSEvent *)evt
{
  [self internalMouseEvent:evt];
}

- (void)mouseUp:(NSEvent *)evt
{
  [self internalMouseEvent:evt];
}

- (BOOL)acceptsFirstResponder
{
  return YES;
}

- (void)setGtkParent:(GtkWidget*)parent_widget
{
  parent = parent_widget;
}

static void
queue_draw (GtkWidget *widget, NSGtkView *nsview)
{
  update_allocation (widget, nsview);
  gtk_widget_queue_draw (widget);
}

- (void)setGtkWidget:(GtkWidget*)child_widget
{
  widget = child_widget;
  gtk_container_add (GTK_CONTAINER (parent), child_widget);

  g_signal_connect (widget, "realize", G_CALLBACK (queue_draw), self);

  setNeedsDisplay:YES;
}

- (BOOL)isOpaque
{
  return NO;
}

@end
