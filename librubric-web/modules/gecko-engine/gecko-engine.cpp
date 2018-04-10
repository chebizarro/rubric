/*
 * Rubric -- a Vala framework for responsive applications
 * Copyright 2017 Chris Daley <bizarro@localhost.localdomain>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 */
#include <assert.h>
#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <math.h>
#include <gio/gio.h>

#include "gecko-engine.h"
#include "jsapi.h"


/* The class of the global object. */
static JSClass global_class = {
    "global",
    JSCLASS_GLOBAL_FLAGS,
    JS_PropertyStub,
    JS_DeletePropertyStub,
    JS_PropertyStub,
    JS_StrictPropertyStub,
    JS_EnumerateStub,
    JS_ResolveStub,
    JS_ConvertStub,
};

struct _RubricWebGeckoEnginePrivate {
	JSRuntime* runtime;
	JSContext* context;
	JS::RootedObject* global;
};

static gpointer rubric_web_gecko_engine_parent_class = NULL;
static RubricWebJSEngineIface* rubric_web_gecko_engine_rubric_web_js_engine_parent_iface = NULL;

GType rubric_web_gecko_engine_get_type (void) G_GNUC_CONST;
#define RUBRIC_WEB_GECKO_ENGINE_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), RUBRIC_WEB_GECKO_TYPE_ENGINE, RubricWebGeckoEnginePrivate))

enum  {
	RUBRIC_WEB_GECKO_ENGINE_DUMMY_PROPERTY,
	RUBRIC_WEB_GECKO_ENGINE_NAME,
	RUBRIC_WEB_GECKO_ENGINE_VERSION,
	RUBRIC_WEB_GECKO_ENGINE_SUPPORTS_GC
};

#define RUBRIC_WEB_GECKO_ENGINE__name "GeckoEngine"
#define RUBRIC_WEB_GECKO_ENGINE__version "1.0"

static gpointer rubric_web_gecko_engine_real_evaluate (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* expression, const gchar* doc_name, GError** error);
static void rubric_web_gecko_engine_real_execute (RubricWebJSEngine* base, const gchar* code, const gchar* doc_name, GError** error);
static void rubric_web_gecko_engine_real_execute_file (RubricWebJSEngine* base, const gchar* path, const gchar* encoding, GError** error);
static void rubric_web_gecko_engine_real_execute_resource (RubricWebJSEngine* base, const gchar* resource_name, GError** error);
static gpointer rubric_web_gecko_engine_real_call_function (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* function_name, GValue** args, int args_length1, GValue* _this, GError** error);
static gboolean rubric_web_gecko_engine_real_has_variable (RubricWebJSEngine* base, const gchar* name);
static gpointer rubric_web_gecko_engine_real_get_variable (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* name);
static void rubric_web_gecko_engine_real_set_variable (RubricWebJSEngine* base, const gchar* name, GValue* value);
static void rubric_web_gecko_engine_real_remove_variable (RubricWebJSEngine* base, const gchar* name);
static void rubric_web_gecko_engine_real_embed_host_object (RubricWebJSEngine* base, const gchar* name, GValue* value);
static void rubric_web_gecko_engine_real_embed_host_type (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* name);
static void rubric_web_gecko_engine_real_collect_garbage (RubricWebJSEngine* base);
RubricWebGeckoEngine* rubric_web_gecko_engine_new (void);
RubricWebGeckoEngine* rubric_web_gecko_engine_construct (GType object_type);
static void rubric_web_gecko_engine_finalize (GObject* obj);
static void _rubric_web_gecko_engine_get_property (GObject * object, guint property_id, GValue * value, GParamSpec * pspec);



static gpointer rubric_web_gecko_engine_real_evaluate (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* expression, const gchar* doc_name, GError** error) {
	RubricWebGeckoEngine * self;
	gpointer result = NULL;
	self = (RubricWebGeckoEngine*) base;
	GError * _inner_error_ = NULL;

	g_return_val_if_fail (expression != NULL, NULL);
	g_return_val_if_fail (self->priv->runtime != NULL, NULL);

	return result;
}

static void rubric_web_gecko_engine_real_execute (RubricWebJSEngine* base, const gchar* code, const gchar* doc_name, GError** error) {
	RubricWebGeckoEngine * self;

	self = (RubricWebGeckoEngine*) base;
	g_return_if_fail (code != NULL);

	rubric_web_gecko_engine_real_evaluate(base, -1, NULL, NULL, code, NULL, error);
}

static void rubric_web_gecko_engine_real_execute_file (RubricWebJSEngine* base, const gchar* path, const gchar* encoding, GError** error) {
	RubricWebGeckoEngine * self;
	GError * _inner_error_ = NULL;
	gchar* contents = NULL;
	
	self = (RubricWebGeckoEngine*) base;

	g_return_if_fail (path != NULL);

	if (g_file_get_contents(path, &contents, NULL, error)) {
		rubric_web_gecko_engine_real_evaluate(base, -1, NULL, NULL, contents, NULL, error);
		g_free(contents);
	}
}

static void rubric_web_gecko_engine_real_execute_resource (RubricWebJSEngine* base, const gchar* resource_name, GError** error) {
	RubricWebGeckoEngine * self;

	self = (RubricWebGeckoEngine*) base;

	g_return_if_fail (resource_name != NULL);
}

static gpointer rubric_web_gecko_engine_real_call_function (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* function_name, GValue** args, int args_length1, GValue* _this, GError** error) {
	RubricWebGeckoEngine * self;
	gpointer result = NULL;
	GError * _inner_error_ = NULL;
	gint nargs = 0;

	self = (RubricWebGeckoEngine*) base;

	g_return_val_if_fail (function_name != NULL, NULL);

	return result;
}

static gboolean rubric_web_gecko_engine_real_has_variable (RubricWebJSEngine* base, const gchar* name) {
	RubricWebGeckoEngine * self;
	gboolean result = FALSE;

	self = (RubricWebGeckoEngine*) base;

	g_return_val_if_fail (name != NULL, FALSE);

	return result;
}

static gpointer rubric_web_gecko_engine_real_get_variable (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* name) {
	RubricWebGeckoEngine * self;
	gpointer result = NULL;

	self = (RubricWebGeckoEngine*) base;

	g_return_val_if_fail (name != NULL, NULL);


	return result;
}

static void rubric_web_gecko_engine_real_set_variable (RubricWebJSEngine* base, const gchar* name, GValue* value) {
	RubricWebGeckoEngine * self;

	self = (RubricWebGeckoEngine*) base;

	g_return_if_fail (name != NULL);

}


static void rubric_web_gecko_engine_real_remove_variable (RubricWebJSEngine* base, const gchar* name) {
	RubricWebGeckoEngine * self;

	self = (RubricWebGeckoEngine*) base;

	g_return_if_fail (name != NULL);

}


static void rubric_web_gecko_engine_real_embed_host_object (RubricWebJSEngine* base, const gchar* name, GValue* value) {
	RubricWebGeckoEngine * self;

	self = (RubricWebGeckoEngine*) base;

	g_return_if_fail (name != NULL);
	g_return_if_fail (value != NULL);

}


static void rubric_web_gecko_engine_real_embed_host_type (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* name) {
	RubricWebGeckoEngine * self;

	self = (RubricWebGeckoEngine*) base;

	g_return_if_fail (name != NULL);
}


static void rubric_web_gecko_engine_real_collect_garbage (RubricWebJSEngine* base) {

	g_assert_not_reached();
}

RubricWebGeckoEngine* rubric_web_gecko_engine_construct (GType object_type) {
	RubricWebGeckoEngine * self = NULL;
	self = (RubricWebGeckoEngine*) g_object_new (object_type, NULL);

	self->priv->runtime = JS_NewRuntime(8L * 1024 * 1024, JS_USE_HELPER_THREADS);
	self->priv->context = JS_NewContext(rt, 8192);

	JSAutoRequest ar(self->priv->context); 
	self->priv->global = JS_NewGlobalObject(self->priv->context, &global_class, nullptr);

	JSAutoCompartment ac(self->priv->context, self->priv->global);
	JS_InitStandardClasses(self->priv->context, self->priv->global);

	return self;
}

/**
 * rubric_web_gecko_engine_new: (constructor)
 * 
 * Returns: (type RubricWebGeckoEngine) (transfer full):
 */
RubricWebGeckoEngine* rubric_web_gecko_engine_new (void) {
	return rubric_web_gecko_engine_construct (RUBRIC_WEB_GECKO_TYPE_ENGINE);
}

static const gchar* rubric_web_gecko_engine_real_get_name (RubricWebJSEngine* base) {
	return RUBRIC_WEB_GECKO_ENGINE__name;
}

static const gchar* rubric_web_gecko_engine_real_get_version (RubricWebJSEngine* base) {
	return RUBRIC_WEB_GECKO_ENGINE__version;
}

static gboolean rubric_web_gecko_engine_real_get_supports_gc (RubricWebJSEngine* base) {
	return FALSE;
}

static void rubric_web_gecko_engine_class_init (RubricWebGeckoEngineClass * klass) {
	rubric_web_gecko_engine_parent_class = g_type_class_peek_parent (klass);

	g_type_class_add_private (klass, sizeof (RubricWebGeckoEnginePrivate));

	G_OBJECT_CLASS (klass)->get_property = _rubric_web_gecko_engine_get_property;
	G_OBJECT_CLASS (klass)->finalize = rubric_web_gecko_engine_finalize;
	/**
	 * RubricWebGeckoEngine:name: (skip)
	 */
	g_object_class_install_property (G_OBJECT_CLASS (klass), RUBRIC_WEB_GECKO_ENGINE_NAME, g_param_spec_string ("name", "name", "name", NULL, G_PARAM_STATIC_NAME | G_PARAM_STATIC_NICK | G_PARAM_STATIC_BLURB | G_PARAM_READABLE));
	/**
	 * RubricWebGeckoEngine:version: (skip)
	 */
	g_object_class_install_property (G_OBJECT_CLASS (klass), RUBRIC_WEB_GECKO_ENGINE_VERSION, g_param_spec_string ("version", "version", "version", NULL, G_PARAM_STATIC_NAME | G_PARAM_STATIC_NICK | G_PARAM_STATIC_BLURB | G_PARAM_READABLE));
	/**
	 * RubricWebGeckoEngine:supports-gc:
	 */
	g_object_class_install_property (G_OBJECT_CLASS (klass), RUBRIC_WEB_GECKO_ENGINE_SUPPORTS_GC, g_param_spec_boolean ("supports-gc", "supports-gc", "supports-gc", FALSE, G_PARAM_STATIC_NAME | G_PARAM_STATIC_NICK | G_PARAM_STATIC_BLURB | G_PARAM_READABLE));

}


static void rubric_web_gecko_engine_rubric_web_js_engine_interface_init (RubricWebJSEngineIface * iface) {
	rubric_web_gecko_engine_rubric_web_js_engine_parent_iface = g_type_interface_peek_parent (iface);
	iface->evaluate = (gpointer (*)(RubricWebJSEngine*, GType, GBoxedCopyFunc, GDestroyNotify, const gchar*, const gchar*, GError**)) rubric_web_gecko_engine_real_evaluate;
	iface->execute = (void (*)(RubricWebJSEngine*, const gchar*, const gchar*, GError**)) rubric_web_gecko_engine_real_execute;
	iface->execute_file = (void (*)(RubricWebJSEngine*, const gchar*, const gchar*, GError**)) rubric_web_gecko_engine_real_execute_file;
	iface->execute_resource = (void (*)(RubricWebJSEngine*, const gchar*, GError**)) rubric_web_gecko_engine_real_execute_resource;
	iface->call_function = (gpointer (*)(RubricWebJSEngine*, GType, GBoxedCopyFunc, GDestroyNotify, const gchar*, GValue**, int, GValue*)) rubric_web_gecko_engine_real_call_function;
	iface->has_variable = (gboolean (*)(RubricWebJSEngine*, const gchar*)) rubric_web_gecko_engine_real_has_variable;
	iface->get_variable = (gpointer (*)(RubricWebJSEngine*, GType, GBoxedCopyFunc, GDestroyNotify, const gchar*)) rubric_web_gecko_engine_real_get_variable;
	iface->set_variable = (void (*)(RubricWebJSEngine*, const gchar*, GValue*)) rubric_web_gecko_engine_real_set_variable;
	iface->remove_variable = (void (*)(RubricWebJSEngine*, const gchar*)) rubric_web_gecko_engine_real_remove_variable;
	iface->embed_host_object = (void (*)(RubricWebJSEngine*, const gchar*, GObject*)) rubric_web_gecko_engine_real_embed_host_object;
	iface->embed_host_type = (void (*)(RubricWebJSEngine*, const gchar*, GType)) rubric_web_gecko_engine_real_embed_host_type;
	iface->collect_garbage = (void (*)(RubricWebJSEngine*)) rubric_web_gecko_engine_real_collect_garbage;
	iface->get_name = rubric_web_gecko_engine_real_get_name;
	iface->get_version = rubric_web_gecko_engine_real_get_version;
	iface->get_supports_gc = rubric_web_gecko_engine_real_get_supports_gc;
}


static void rubric_web_gecko_engine_instance_init (RubricWebGeckoEngine * self) {

	self->priv = RUBRIC_WEB_GECKO_ENGINE_GET_PRIVATE (self);
}


static void rubric_web_gecko_engine_finalize (GObject* obj) {
	RubricWebGeckoEngine * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, RUBRIC_WEB_GECKO_TYPE_ENGINE, RubricWebGeckoEngine);
	
	if (self->priv->context != NULL) {
		JS_DestroyContext(self->priv->context);
		JS_DestroyRuntime(self->priv->runtime);
		JS_ShutDown();
	}

	G_OBJECT_CLASS (rubric_web_gecko_engine_parent_class)->finalize (obj);

}


GType rubric_web_gecko_engine_get_type (void) {
	static volatile gsize rubric_web_gecko_engine_type_id__volatile = 0;
	if (g_once_init_enter (&rubric_web_gecko_engine_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (RubricWebGeckoEngineClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) rubric_web_gecko_engine_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (RubricWebGeckoEngine), 0, (GInstanceInitFunc) rubric_web_gecko_engine_instance_init, NULL };
		static const GInterfaceInfo rubric_web_js_engine_info = { (GInterfaceInitFunc) rubric_web_gecko_engine_rubric_web_js_engine_interface_init, (GInterfaceFinalizeFunc) NULL, NULL};
		GType rubric_web_gecko_engine_type_id;
		rubric_web_gecko_engine_type_id = g_type_register_static (G_TYPE_OBJECT, "RubricWebGeckoEngine", &g_define_type_info, 0);
		g_type_add_interface_static (rubric_web_gecko_engine_type_id, RUBRIC_WEB_TYPE_JS_ENGINE, &rubric_web_js_engine_info);
		g_once_init_leave (&rubric_web_gecko_engine_type_id__volatile, rubric_web_gecko_engine_type_id);
	}
	return rubric_web_gecko_engine_type_id__volatile;
}


static void _rubric_web_gecko_engine_get_property (GObject * object, guint property_id, GValue * value, GParamSpec * pspec) {
	RubricWebGeckoEngine * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (object, RUBRIC_WEB_GECKO_TYPE_ENGINE, RubricWebGeckoEngine);

	switch (property_id) {
		case RUBRIC_WEB_GECKO_ENGINE_NAME:
		g_value_set_string (value, rubric_web_js_engine_get_name ((RubricWebJSEngine*) self));
		break;
		case RUBRIC_WEB_GECKO_ENGINE_VERSION:
		g_value_set_string (value, rubric_web_js_engine_get_version ((RubricWebJSEngine*) self));
		break;
		case RUBRIC_WEB_GECKO_ENGINE_SUPPORTS_GC:
		g_value_set_boolean (value, rubric_web_js_engine_get_supports_gc ((RubricWebJSEngine*) self));
		break;
		default:
		G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
		break;
	}
}
