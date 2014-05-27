#include "gtkembedcontainer.h"

static void gtk_embed_container_realize       (GtkWidget        *widget);
static void gtk_embed_container_size_request  (GtkWidget        *widget,
                                               GtkRequisition   *requisition);
static void gtk_embed_container_size_allocate (GtkWidget        *widget,
                                               GtkAllocation    *allocation);
static void gtk_embed_container_add           (GtkContainer     *container,
                                               GtkWidget        *widget);
static void gtk_embed_container_remove        (GtkContainer     *container,
                                               GtkWidget        *widget);
static void gtk_embed_container_forall        (GtkContainer     *container,
                                               gboolean          include_internals,
                                               GtkCallback       callback,
                                               gpointer          callback_data);
static GType gtk_embed_container_child_type   (GtkContainer     *container);

G_DEFINE_TYPE (GtkEmbedContainer, gtk_embed_container, GTK_TYPE_CONTAINER)

GtkWidget*
gtk_embed_container_new (void)
{
  return g_object_new (GTK_TYPE_EMBED_CONTAINER, NULL);
}

static void
gtk_embed_container_class_init (GtkEmbedContainerClass *class)
{
  GtkWidgetClass *widget_class;
  GtkContainerClass *container_class;

  widget_class = (GtkWidgetClass*) class;
  container_class = (GtkContainerClass*) class;

  widget_class->realize      = gtk_embed_container_realize;
  widget_class->size_request = gtk_embed_container_size_request;
  widget_class->size_allocate = gtk_embed_container_size_allocate;

  container_class->add = gtk_embed_container_add;
  container_class->remove = gtk_embed_container_remove;
  container_class->forall = gtk_embed_container_forall;
  container_class->child_type = gtk_embed_container_child_type;

}

static GType
gtk_embed_container_child_type (GtkContainer     *container)
{
  return GTK_TYPE_WIDGET;
}

static void
gtk_embed_container_init (GtkEmbedContainer *embed_container)
{
  gtk_widget_set_has_window (GTK_WIDGET (embed_container), FALSE);

  embed_container->gtknsview = NULL;
  embed_container->children = NULL;
}

static void
gtk_embed_container_realize (GtkWidget *widget)
{
  GdkWindowAttr attributes;
  gint attributes_mask;

  if (!gtk_widget_get_has_window (widget))
    GTK_WIDGET_CLASS (gtk_embed_container_parent_class)->realize (widget);
  else
    {
      gtk_widget_set_realized (widget, TRUE);

      attributes.window_type = GDK_WINDOW_CHILD;
      attributes.x = widget->allocation.x;
      attributes.y = widget->allocation.y;
      attributes.width = widget->allocation.width;
      attributes.height = widget->allocation.height;
      attributes.wclass = GDK_INPUT_OUTPUT;
      attributes.visual = gtk_widget_get_visual (widget);
      attributes.colormap = gtk_widget_get_colormap (widget);
      attributes.event_mask = gtk_widget_get_events (widget);
      attributes.event_mask |= GDK_EXPOSURE_MASK | GDK_BUTTON_PRESS_MASK;

      attributes_mask = GDK_WA_X | GDK_WA_Y | GDK_WA_VISUAL | GDK_WA_COLORMAP;
      widget->window = gdk_window_new (gtk_widget_get_parent_window (widget), &attributes, attributes_mask);
      gdk_window_set_user_data (widget->window, widget);
      gtk_style_set_background (widget->style, widget->window, GTK_STATE_NORMAL);
    }
}

static void
gtk_embed_container_size_request (GtkWidget      *widget,
                                  GtkRequisition *requisition)
{
  GtkEmbedContainer *embed_container;  
  GtkEmbedContainerChild *child;
  GList *children;
  GtkRequisition child_requisition;

  embed_container = GTK_EMBED_CONTAINER (widget);
  requisition->width = 0;
  requisition->height = 0;

  if (embed_container->gtknsview)
    {
      gtk_widget_size_request (GTK_WIDGET (embed_container->gtknsview), &child_requisition);

      requisition->height = child_requisition.height;
      requisition->width = child_requisition.width;
    }

  requisition->height += GTK_CONTAINER (embed_container)->border_width * 2;
  requisition->width += GTK_CONTAINER (embed_container)->border_width * 2;
}

static void
gtk_embed_container_size_allocate (GtkWidget     *widget,
                                   GtkAllocation *allocation)
{
  GtkEmbedContainer *embed_container;
  GtkWidget *child;
  GtkAllocation child_allocation;
  GtkRequisition child_requisition;
  GList *children;
  guint16 border_width;

  embed_container = GTK_EMBED_CONTAINER (widget);

  widget->allocation = *allocation;
      
  border_width = GTK_CONTAINER (embed_container)->border_width;

  if (embed_container->gtknsview)
    {
      child = GTK_WIDGET (embed_container->gtknsview);

      if (gtk_widget_get_visible (child))
        {
          gtk_widget_get_child_requisition (child, &child_requisition);

          child_allocation.x = border_width;
          child_allocation.y = border_width;

          if (!gtk_widget_get_has_window (widget))
            {
              child_allocation.x += widget->allocation.x;
              child_allocation.y += widget->allocation.y;
            }

          child_allocation.width = widget->allocation.width - border_width * 2;
          child_allocation.height = widget->allocation.height - border_width * 2;

          gtk_widget_size_allocate (child, &child_allocation);
        }
    }
}

static void
gtk_embed_container_add (GtkContainer *container,
                         GtkWidget    *widget)
{
  GtkEmbedContainer *embed = GTK_EMBED_CONTAINER (container);
  gtk_widget_set_parent (widget, GTK_WIDGET (container));
  embed->children = g_list_append (embed->children, widget);
}

static void
gtk_embed_container_remove (GtkContainer *container,
                            GtkWidget    *widget)
{
  GtkEmbedContainer *embed_container;
  GtkWidget *child;
  GtkWidget *widget_container;
  GList *children;

  embed_container = GTK_EMBED_CONTAINER (container);
  widget_container = GTK_WIDGET (container);

  children = embed_container->children;
  while (children)
    {
      child = children->data;

      if (child == widget)
        {
          gboolean was_visible = gtk_widget_get_visible (widget);
          
          gtk_widget_unparent (widget);

          embed_container->children = g_list_remove_link (embed_container->children, children);
          g_list_free (children);
          g_free (child);

          if (was_visible && gtk_widget_get_visible (widget_container))
            gtk_widget_queue_resize (widget_container);

          break;
        }

      children = children->next;
    }
}

static void
gtk_embed_container_forall (GtkContainer *container,
                            gboolean      include_internals,
                            GtkCallback   callback,
                            gpointer      callback_data)
{
  GtkEmbedContainer *embed_container = GTK_EMBED_CONTAINER (container);
  GtkWidget *child;
  GList *children = NULL;

  if (embed_container->gtknsview)
    {
      (* callback) (GTK_WIDGET (embed_container->gtknsview), callback_data);
    }

  children = embed_container->children;
  while (children)
    {
      child = children->data;
      children = children->next;

      (* callback) (child, callback_data);
    }
}

void
gtk_embed_container_set_gtknsview (GtkEmbedContainer *container, GtkNSView *nsview)
{
  gtk_widget_set_parent (GTK_WIDGET (nsview), GTK_WIDGET (container));
  container->gtknsview = nsview;
}

GtkNSView *
gtk_embed_container_get_gtknsview (GtkEmbedContainer *embed_container)
{
  return embed_container->gtknsview;
}