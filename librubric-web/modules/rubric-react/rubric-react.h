/* rubric-react.h generated by valac 0.34.7, the Vala compiler, do not modify */


#ifndef __RUBRIC_REACT_H__
#define __RUBRIC_REACT_H__

#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <rubric.h>

G_BEGIN_DECLS


#define RUBRIC_REACT_TYPE_BABEL (rubric_react_babel_get_type ())
#define RUBRIC_REACT_BABEL(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), RUBRIC_REACT_TYPE_BABEL, RubricReactBabel))
#define RUBRIC_REACT_BABEL_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), RUBRIC_REACT_TYPE_BABEL, RubricReactBabelClass))
#define RUBRIC_REACT_IS_BABEL(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), RUBRIC_REACT_TYPE_BABEL))
#define RUBRIC_REACT_IS_BABEL_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), RUBRIC_REACT_TYPE_BABEL))
#define RUBRIC_REACT_BABEL_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), RUBRIC_REACT_TYPE_BABEL, RubricReactBabelClass))

typedef struct _RubricReactBabel RubricReactBabel;
typedef struct _RubricReactBabelClass RubricReactBabelClass;
typedef struct _RubricReactBabelPrivate RubricReactBabelPrivate;

#define RUBRIC_REACT_TYPE_ENVIRONMENT (rubric_react_environment_get_type ())
#define RUBRIC_REACT_ENVIRONMENT(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), RUBRIC_REACT_TYPE_ENVIRONMENT, RubricReactEnvironment))
#define RUBRIC_REACT_ENVIRONMENT_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), RUBRIC_REACT_TYPE_ENVIRONMENT, RubricReactEnvironmentClass))
#define RUBRIC_REACT_IS_ENVIRONMENT(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), RUBRIC_REACT_TYPE_ENVIRONMENT))
#define RUBRIC_REACT_IS_ENVIRONMENT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), RUBRIC_REACT_TYPE_ENVIRONMENT))
#define RUBRIC_REACT_ENVIRONMENT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), RUBRIC_REACT_TYPE_ENVIRONMENT, RubricReactEnvironmentClass))

typedef struct _RubricReactEnvironment RubricReactEnvironment;
typedef struct _RubricReactEnvironmentClass RubricReactEnvironmentClass;

#define RUBRIC_REACT_TYPE_JAVA_SCRIPT_WITH_SOURCE_MAP (rubric_react_java_script_with_source_map_get_type ())
#define RUBRIC_REACT_JAVA_SCRIPT_WITH_SOURCE_MAP(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), RUBRIC_REACT_TYPE_JAVA_SCRIPT_WITH_SOURCE_MAP, RubricReactJavaScriptWithSourceMap))
#define RUBRIC_REACT_JAVA_SCRIPT_WITH_SOURCE_MAP_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), RUBRIC_REACT_TYPE_JAVA_SCRIPT_WITH_SOURCE_MAP, RubricReactJavaScriptWithSourceMapClass))
#define RUBRIC_REACT_IS_JAVA_SCRIPT_WITH_SOURCE_MAP(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), RUBRIC_REACT_TYPE_JAVA_SCRIPT_WITH_SOURCE_MAP))
#define RUBRIC_REACT_IS_JAVA_SCRIPT_WITH_SOURCE_MAP_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), RUBRIC_REACT_TYPE_JAVA_SCRIPT_WITH_SOURCE_MAP))
#define RUBRIC_REACT_JAVA_SCRIPT_WITH_SOURCE_MAP_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), RUBRIC_REACT_TYPE_JAVA_SCRIPT_WITH_SOURCE_MAP, RubricReactJavaScriptWithSourceMapClass))

typedef struct _RubricReactJavaScriptWithSourceMap RubricReactJavaScriptWithSourceMap;
typedef struct _RubricReactJavaScriptWithSourceMapClass RubricReactJavaScriptWithSourceMapClass;

#define RUBRIC_REACT_TYPE_COMPONENT (rubric_react_component_get_type ())
#define RUBRIC_REACT_COMPONENT(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), RUBRIC_REACT_TYPE_COMPONENT, RubricReactComponent))
#define RUBRIC_REACT_COMPONENT_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), RUBRIC_REACT_TYPE_COMPONENT, RubricReactComponentClass))
#define RUBRIC_REACT_IS_COMPONENT(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), RUBRIC_REACT_TYPE_COMPONENT))
#define RUBRIC_REACT_IS_COMPONENT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), RUBRIC_REACT_TYPE_COMPONENT))
#define RUBRIC_REACT_COMPONENT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), RUBRIC_REACT_TYPE_COMPONENT, RubricReactComponentClass))

typedef struct _RubricReactComponent RubricReactComponent;
typedef struct _RubricReactComponentClass RubricReactComponentClass;
typedef struct _RubricReactComponentPrivate RubricReactComponentPrivate;
typedef struct _RubricReactJavaScriptWithSourceMapPrivate RubricReactJavaScriptWithSourceMapPrivate;

#define RUBRIC_REACT_TYPE_SOURCE_MAP (rubric_react_source_map_get_type ())
#define RUBRIC_REACT_SOURCE_MAP(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), RUBRIC_REACT_TYPE_SOURCE_MAP, RubricReactSourceMap))
#define RUBRIC_REACT_SOURCE_MAP_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), RUBRIC_REACT_TYPE_SOURCE_MAP, RubricReactSourceMapClass))
#define RUBRIC_REACT_IS_SOURCE_MAP(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), RUBRIC_REACT_TYPE_SOURCE_MAP))
#define RUBRIC_REACT_IS_SOURCE_MAP_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), RUBRIC_REACT_TYPE_SOURCE_MAP))
#define RUBRIC_REACT_SOURCE_MAP_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), RUBRIC_REACT_TYPE_SOURCE_MAP, RubricReactSourceMapClass))

typedef struct _RubricReactSourceMap RubricReactSourceMap;
typedef struct _RubricReactSourceMapClass RubricReactSourceMapClass;
typedef struct _RubricReactEnvironmentPrivate RubricReactEnvironmentPrivate;
typedef struct _RubricReactSourceMapPrivate RubricReactSourceMapPrivate;

struct _RubricReactBabel {
	GObject parent_instance;
	RubricReactBabelPrivate * priv;
	RubricReactEnvironment* environment;
};

struct _RubricReactBabelClass {
	GObjectClass parent_class;
};

struct _RubricReactComponent {
	GObject parent_instance;
	RubricReactComponentPrivate * priv;
};

struct _RubricReactComponentClass {
	GObjectClass parent_class;
};

struct _RubricReactJavaScriptWithSourceMap {
	GObject parent_instance;
	RubricReactJavaScriptWithSourceMapPrivate * priv;
};

struct _RubricReactJavaScriptWithSourceMapClass {
	GObjectClass parent_class;
};

struct _RubricReactEnvironment {
	GObject parent_instance;
	RubricReactEnvironmentPrivate * priv;
};

struct _RubricReactEnvironmentClass {
	GObjectClass parent_class;
};

struct _RubricReactSourceMap {
	GObject parent_instance;
	RubricReactSourceMapPrivate * priv;
};

struct _RubricReactSourceMapClass {
	GObjectClass parent_class;
};


GType rubric_react_babel_get_type (void) G_GNUC_CONST;
GType rubric_react_environment_get_type (void) G_GNUC_CONST;
gchar* rubric_react_babel_transform_file (RubricReactBabel* self, const gchar* filename);
GType rubric_react_java_script_with_source_map_get_type (void) G_GNUC_CONST;
RubricReactJavaScriptWithSourceMap* rubric_react_babel_transform_file_with_source_map (RubricReactBabel* self, const gchar* filename, gboolean force_generate_source_map);
RubricReactJavaScriptWithSourceMap* rubric_react_babel_load_from_file_cache (RubricReactBabel* self, const gchar* filename, const gchar* hash, gboolean force_generate_source_map);
RubricReactJavaScriptWithSourceMap* rubric_react_babel_transform_with_header (RubricReactBabel* self, const gchar* filename, const gchar* contents, const gchar* hash);
gchar* rubric_react_babel_transform (RubricReactBabel* self, const gchar* input, const gchar* filename);
RubricReactJavaScriptWithSourceMap* rubric_react_babel_transform_with_source_map (RubricReactBabel* self, const gchar* input, const gchar* filename);
gchar* rubric_react_babel_get_file_header (RubricReactBabel* self, const gchar* hash, const gchar* babel_version);
gchar* rubric_react_babel_get_output_path (RubricReactBabel* self, const gchar* path);
gchar* rubric_react_babel_get_source_map_output_path (RubricReactBabel* self, const gchar* path);
gchar* rubric_react_babel_transform_and_save_file (RubricReactBabel* self, const gchar* filename);
gboolean rubric_react_babel_cache_is_valid (RubricReactBabel* self, const gchar* input_file_contents, const gchar* output_path);
RubricReactBabel* rubric_react_babel_new (void);
RubricReactBabel* rubric_react_babel_construct (GType object_type);
GType rubric_react_component_get_type (void) G_GNUC_CONST;
gchar* rubric_react_component_render_html (RubricReactComponent* self, gboolean render_container_only, gboolean render_server_only);
gchar* rubric_react_component_render_javascript (RubricReactComponent* self);
RubricReactComponent* rubric_react_component_new (GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func);
RubricReactComponent* rubric_react_component_construct (GType object_type, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func);
gconstpointer rubric_react_component_get_props (RubricReactComponent* self);
void rubric_react_component_set_props (RubricReactComponent* self, gconstpointer value);
const gchar* rubric_react_component_get_component_name (RubricReactComponent* self);
void rubric_react_component_set_component_name (RubricReactComponent* self, const gchar* value);
const gchar* rubric_react_component_get_container_id (RubricReactComponent* self);
void rubric_react_component_set_container_id (RubricReactComponent* self, const gchar* value);
const gchar* rubric_react_component_get_container_tag (RubricReactComponent* self);
void rubric_react_component_set_container_tag (RubricReactComponent* self, const gchar* value);
const gchar* rubric_react_component_get_container_class (RubricReactComponent* self);
void rubric_react_component_set_container_class (RubricReactComponent* self, const gchar* value);
RubricReactJavaScriptWithSourceMap* rubric_react_java_script_with_source_map_new (void);
RubricReactJavaScriptWithSourceMap* rubric_react_java_script_with_source_map_construct (GType object_type);
const gchar* rubric_react_java_script_with_source_map_get_babel_version (RubricReactJavaScriptWithSourceMap* self);
void rubric_react_java_script_with_source_map_set_babel_version (RubricReactJavaScriptWithSourceMap* self, const gchar* value);
const gchar* rubric_react_java_script_with_source_map_get_code (RubricReactJavaScriptWithSourceMap* self);
void rubric_react_java_script_with_source_map_set_code (RubricReactJavaScriptWithSourceMap* self, const gchar* value);
const gchar* rubric_react_java_script_with_source_map_get_hash (RubricReactJavaScriptWithSourceMap* self);
void rubric_react_java_script_with_source_map_set_hash (RubricReactJavaScriptWithSourceMap* self, const gchar* value);
GType rubric_react_source_map_get_type (void) G_GNUC_CONST;
RubricReactSourceMap* rubric_react_java_script_with_source_map_get_SourceMap (RubricReactJavaScriptWithSourceMap* self);
void rubric_react_java_script_with_source_map_set_SourceMap (RubricReactJavaScriptWithSourceMap* self, RubricReactSourceMap* value);
#define RUBRIC_REACT_ENVIRONMENT_USER_SCRIPTS_LOADED_KEY "_RubricReact_UserScripts_Loaded"
#define RUBRIC_REACT_ENVIRONMENT_LARGE_STACK_SIZE ((2 * 1024) * 1024)
gpointer rubric_react_environment_execute (RubricReactEnvironment* self, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* function, GValue* args, int args_length1);
gpointer rubric_react_environment_execute_with_babel (RubricReactEnvironment* self, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* function, GValue* args, int args_length1);
gboolean rubric_react_environment_has_variable (RubricReactEnvironment* self, const gchar* name);
RubricReactComponent* rubric_react_environment_create_component (RubricReactEnvironment* self, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* componentName, gconstpointer props, const gchar* container_id, gboolean client_only);
gchar* rubric_react_environment_get_init_javascript (RubricReactEnvironment* self, gboolean client_only);
void rubric_react_environment_return_engine_to_pool (RubricReactEnvironment* self);
RubricReactEnvironment* rubric_react_environment_new (void);
RubricReactEnvironment* rubric_react_environment_construct (GType object_type);
RubricContainer* rubric_react_environment_get_container (RubricReactEnvironment* self);
void rubric_react_environment_set_container (RubricReactEnvironment* self, RubricContainer* value);
const gchar* rubric_react_environment_get_version (RubricReactEnvironment* self);
const gchar* rubric_react_environment_get_engine_version (RubricReactEnvironment* self);
RubricReactBabel* rubric_react_environment_get_babel (RubricReactEnvironment* self);
RubricReactSourceMap* rubric_react_source_map_new (void);
RubricReactSourceMap* rubric_react_source_map_construct (GType object_type);
gint rubric_react_source_map_get_version (RubricReactSourceMap* self);
void rubric_react_source_map_set_version (RubricReactSourceMap* self, gint value);
const gchar* rubric_react_source_map_get_file (RubricReactSourceMap* self);
void rubric_react_source_map_set_file (RubricReactSourceMap* self, const gchar* value);
const gchar* rubric_react_source_map_get_source_root (RubricReactSourceMap* self);
void rubric_react_source_map_set_source_root (RubricReactSourceMap* self, const gchar* value);
gchar** rubric_react_source_map_get_sources (RubricReactSourceMap* self, int* result_length1);
void rubric_react_source_map_set_sources (RubricReactSourceMap* self, gchar** value, int value_length1);
gchar** rubric_react_source_map_get_sources_content (RubricReactSourceMap* self, int* result_length1);
void rubric_react_source_map_set_sources_content (RubricReactSourceMap* self, gchar** value, int value_length1);
gchar** rubric_react_source_map_get_names (RubricReactSourceMap* self, int* result_length1);
void rubric_react_source_map_set_names (RubricReactSourceMap* self, gchar** value, int value_length1);
const gchar* rubric_react_source_map_get_mappings (RubricReactSourceMap* self);
void rubric_react_source_map_set_mappings (RubricReactSourceMap* self, const gchar* value);


G_END_DECLS

#endif