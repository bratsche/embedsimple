#include <gdk/gdkquartz.h>
#include <gtk/gtkcontainer.h>
#include <gtk/gtknsview.h>

#define GTK_TYPE_EMBED_CONTAINER         (gtk_embed_container_get_type ())
#define GTK_EMBED_CONTAINER(o)           (G_TYPE_CHECK_INSTANCE_CAST ((o), GTK_TYPE_EMBED_CONTAINER, GtkEmbedContainer))
#define GTK_EMBED_CONTAINER_CLASS(k)     (G_TYPE_CHECK_CLASS_CAST ((k), GTK_TYPE_EMBED_CONTAINER, GtkEmbedContainerClass))
#define GTK_IS_EMBED_CONTAINER(o)        (G_TYPE_CHECK_INSTANCE_TYPE ((o), GTK_TYPE_EMBED_CONTAINER))
#define GTK_IS_EMBED_CONTAINER_CLASS(k)  (G_TYPE_CHECK_CLASS_TYPE ((k), GTK_TYPE_EMBED_CONTAINER))
#define GTK_EMBED_CONTAINER_GET_CLASS(o) (G_TYPE_INSTANCE_GET_CLASS ((o), GTK_TYPE_EMBED_CONTAINER, GtkEmbedContainerClass))


typedef struct _GtkEmbedContainer        GtkEmbedContainer;
typedef struct _GtkEmbedContainerClass   GtkEmbedContainerClass;
typedef struct _GtkEmbedContainerChild   GtkEmbedContainerChild;

struct _GtkEmbedContainer
{
  GtkContainer container;

  GtkNSView *gtknsview;

  GList *GSEAL (children);
};

struct _GtkEmbedContainerClass
{
  GtkContainerClass parent_class;
};

GType      gtk_embed_container_get_type      (void) G_GNUC_CONST;
GtkWidget* gtk_embed_container_new           (void);
void       gtk_embed_container_set_gtknsview (GtkEmbedContainer  *embed_container,
                                              GtkNSView          *nsview);
GtkNSView *gtk_embed_container_get_gtknsview (GtkEmbedContainer  *embed_container);
void       gtk_embed_container_put           (GtkEmbedContainer  *embed_container,
                                              GtkWidget          *widget,
                                              gint                x,
                                              gint                y);
void       gtk_embed_container_move          (GtkEmbedContainer  *embed_container,
                                              GtkWidget          *widget,
                                              gint                x,
                                              gint                y);
