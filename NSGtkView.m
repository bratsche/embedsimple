#import "NSGtkView.h"

@implementation NSGtkView

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

- (void)drawRect:(NSRect)rect
{
  GtkAllocation allocation;

  allocation.x = (int)rect.origin.x;
  allocation.y = (int)(rect.origin.y);
  allocation.width = rect.size.width;
  allocation.height = rect.size.height;

  gtk_widget_size_allocate (widget, &allocation);

  gtk_widget_queue_draw (widget);
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

- (void)setGtkWidget:(GtkWidget*)child_widget
{
  widget = child_widget;
  gtk_container_add (GTK_CONTAINER (parent), child_widget);
  setNeedsDisplay:YES;
}

- (BOOL)isOpaque
{
  return NO;
}

@end
