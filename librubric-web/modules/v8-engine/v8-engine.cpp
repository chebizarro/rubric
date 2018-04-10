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

#include "v8-engine.h"

#include <libplatform/libplatform.h>
#include <v8.h>

using namespace v8;

class ArrayBufferAllocator : public v8::ArrayBuffer::Allocator {
	public:
	virtual void* Allocate(size_t length) {
		void* data = AllocateUninitialized(length);
		return data == NULL ? data : memset(data, 0, length);
	}
	virtual void* AllocateUninitialized(size_t length) { return malloc(length); }
	virtual void Free(void* data, size_t) { free(data); }
};


struct _RubricWebV8EnginePrivate {
	Isolate* isolate;
	Global<Context> context;
};


static gpointer rubric_web_v8_engine_parent_class = NULL;
static RubricWebJSEngineIface* rubric_web_v8_engine_rubric_web_js_engine_parent_iface = NULL;

GType rubric_web_v8_engine_get_type (void) G_GNUC_CONST;
#define RUBRIC_WEB_V8_ENGINE_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), RUBRIC_WEB_V8_TYPE_ENGINE, RubricWebV8EnginePrivate))

enum  {
	RUBRIC_WEB_V8_ENGINE_DUMMY_PROPERTY,
	RUBRIC_WEB_V8_ENGINE_NAME,
	RUBRIC_WEB_V8_ENGINE_VERSION,
	RUBRIC_WEB_V8_ENGINE_SUPPORTS_GC
};

#define RUBRIC_WEB_V8_ENGINE__name "V8Engine"
#define RUBRIC_WEB_V8_ENGINE__version "1.0"

static gpointer rubric_web_v8_engine_real_evaluate (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* expression, const gchar* doc_name, GError** error);
static void rubric_web_v8_engine_real_execute (RubricWebJSEngine* base, const gchar* code, const gchar* doc_name, GError** error);
static void rubric_web_v8_engine_real_execute_file (RubricWebJSEngine* base, const gchar* path, const gchar* encoding, GError** error);
static void rubric_web_v8_engine_real_execute_resource (RubricWebJSEngine* base, const gchar* resource_name, GError** error);
static gpointer rubric_web_v8_engine_real_call_function (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* function_name, GValue** args, int args_length1, GValue* _this, GError** error);
static gboolean rubric_web_v8_engine_real_has_variable (RubricWebJSEngine* base, const gchar* name);
static gpointer rubric_web_v8_engine_real_get_variable (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* name);
static void rubric_web_v8_engine_real_set_variable (RubricWebJSEngine* base, const gchar* name, GValue* value);
static void rubric_web_v8_engine_real_remove_variable (RubricWebJSEngine* base, const gchar* name);
static void rubric_web_v8_engine_real_embed_host_object (RubricWebJSEngine* base, const gchar* name, GValue* value);
static void rubric_web_v8_engine_real_embed_host_type (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* name);
static void rubric_web_v8_engine_real_collect_garbage (RubricWebJSEngine* base);
RubricWebV8Engine* rubric_web_v8_engine_new (void);
RubricWebV8Engine* rubric_web_v8_engine_construct (GType object_type);
static void rubric_web_v8_engine_finalize (GObject* obj);
static void _rubric_web_v8_engine_get_property (GObject * object, guint property_id, GValue * value, GParamSpec * pspec);

v8::Local<v8::Context> create_context(v8::Isolate* isolate);
GError* report_exception(v8::Isolate* isolate, v8::TryCatch* try_catch);
const char* to_cstring(const v8::String::Utf8Value& value);

// Extracts a C string from a V8 Utf8Value.
const char* to_cstring(const v8::String::Utf8Value& value) {
	return *value ? *value : "<string conversion failed>";
}

GError* report_exception(v8::Isolate* isolate, v8::TryCatch* try_catch) {
	v8::HandleScope handle_scope(isolate);
	v8::String::Utf8Value exception(try_catch->Exception());
	const char* exception_string = to_cstring(exception);
	v8::Local<v8::Message> message = try_catch->Message();
	if (message.IsEmpty()) {
		// V8 didn't provide any extra information about this error; just
		// print the exception.
		return g_error_new_literal(
			RUBRIC_WEB_ENGINE_ERROR, RUBRIC_WEB_ENGINE_ERROR_EVAL, exception_string);
		//fprintf(stderr, "%s\n", exception_string);
	} else {
		// Print (filename):(line number): (message).
		v8::String::Utf8Value filename(message->GetScriptOrigin().ResourceName());
		v8::Local<v8::Context> context(isolate->GetCurrentContext());
		const char* filename_string = to_cstring(filename);
		int linenum = message->GetLineNumber(context).FromJust();
		
		fprintf(stderr, "%s:%i: %s\n", filename_string, linenum, exception_string);
		// Print line of source code.
		v8::String::Utf8Value sourceline(
				message->GetSourceLine(context).ToLocalChecked());
		const char* sourceline_string = to_cstring(sourceline);
		fprintf(stderr, "%s\n", sourceline_string);
		// Print wavy underline (GetUnderline is deprecated).
		int start = message->GetStartColumn(context).FromJust();
		for (int i = 0; i < start; i++) {
			fprintf(stderr, " ");
		}
		int end = message->GetEndColumn(context).FromJust();
		for (int i = start; i < end; i++) {
			fprintf(stderr, "^");
		}
		fprintf(stderr, "\n");
		v8::Local<v8::Value> stack_trace_string;
		if (try_catch->StackTrace(context).ToLocal(&stack_trace_string) &&
				stack_trace_string->IsString() &&
				v8::Local<v8::String>::Cast(stack_trace_string)->Length() > 0) {
			v8::String::Utf8Value stack_trace(stack_trace_string);
			const char* stack_trace_string = to_cstring(stack_trace);
			fprintf(stderr, "%s\n", stack_trace_string);
		}
		return g_error_new_literal(
			RUBRIC_WEB_ENGINE_ERROR, RUBRIC_WEB_ENGINE_ERROR_EVAL, exception_string);
	}
}


static gpointer rubric_web_v8_engine_real_evaluate (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* expression, const gchar* doc_name, GError** error) {
	RubricWebV8Engine * self;
	gpointer result = NULL;
	self = (RubricWebV8Engine*) base;
	GError * _inner_error_ = NULL;

	g_return_val_if_fail (expression != NULL, NULL);
	g_return_val_if_fail (self->priv->isolate != NULL, NULL);

	Isolate::Scope isolateScope(self->priv->isolate);
	HandleScope handle_scope(self->priv->isolate);
	v8::TryCatch try_catch(self->priv->isolate);
	
	Local<Context> context = v8::Local<v8::Context>::New(self->priv->isolate, self->priv->context);
	Context::Scope context_scope(context);

	Local<String> source =
		String::NewFromUtf8(self->priv->isolate, expression,
							NewStringType::kNormal).ToLocalChecked();

	v8::Local<v8::Script> script;
	if (!v8::Script::Compile(context, source).ToLocal(&script)) {
		_inner_error_ = report_exception(self->priv->isolate, &try_catch);
		g_propagate_error (error, _inner_error_);
		return NULL;
	} else {
		Local<Value> res = script->Run(context).ToLocalChecked();
		if (try_catch.HasCaught()) {
 			_inner_error_ = report_exception(self->priv->isolate, &try_catch);
			g_propagate_error (error, _inner_error_);
			return NULL;
		} else {
			if (res->IsNull() || res->IsUndefined()) {
				result = NULL;
			} else if (res->IsBoolean()) {
				gboolean _res = res->BooleanValue();
				result = _res;
			} else if (res->IsInt32()) {
				result = res->Int32Value();
			} else if (res->IsUint32()) {
				result = res->Uint32Value();
			} else if (res->IsNumber()) {
				gdouble _res = res->NumberValue();
				result = (((&_res) != NULL) && (t_dup_func != NULL)) ? t_dup_func ((gpointer) (&_res)) : ((gpointer) (&_res));
			} else if (res->IsString()) {
				String::Utf8Value str(res);
				const char* cstr = to_cstring(str);
				result = g_strdup(cstr);
			}
		}
	}
	return result;
}

static void rubric_web_v8_engine_real_execute (RubricWebJSEngine* base, const gchar* code, const gchar* doc_name, GError** error) {
	RubricWebV8Engine * self;
	self = (RubricWebV8Engine*) base;

	g_return_if_fail (code != NULL);

	rubric_web_v8_engine_real_evaluate(base, -1, NULL, NULL, code, NULL, error);
}

static void rubric_web_v8_engine_real_execute_file (RubricWebJSEngine* base, const gchar* path, const gchar* encoding, GError** error) {
	RubricWebV8Engine * self;
	GError * _inner_error_ = NULL;
	gchar* contents = NULL;
	self = (RubricWebV8Engine*) base;

	g_return_if_fail (path != NULL);

	v8::HandleScope handle_scope(self->priv->isolate);

	if (g_file_get_contents(path, &contents, NULL, error)) {
		rubric_web_v8_engine_real_evaluate(base, -1, NULL, NULL, contents, NULL, error);
		g_free(contents);
	}
}

static void rubric_web_v8_engine_real_execute_resource (RubricWebJSEngine* base, const gchar* resource_name, GError** error) {
	RubricWebV8Engine * self;
	GError * _inner_error_ = NULL;
	self = (RubricWebV8Engine*) base;

	g_return_if_fail (resource_name != NULL);
	
	if(g_str_has_prefix(resource_name, "resource:///")) {
		rubric_web_v8_engine_real_execute_file(base, resource_name, error);
	} else {
		const char* contents = g_strdup_printf("resource:///%s", resource_name);
		rubric_web_v8_engine_real_execute_file(base, contents, error);
		g_free(contents);
	}
}

static gpointer rubric_web_v8_engine_real_call_function (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* function_name, GValue** args, int args_length1, GValue* _this, GError** error) {
	RubricWebV8Engine * self;
	gpointer result = NULL;
	GError * _inner_error_ = NULL;
	gint nargs = 0;
	self = (RubricWebV8Engine*) base;

	g_return_val_if_fail (function_name != NULL, NULL);

	Isolate::Scope isolateScope(self->priv->isolate);
	HandleScope handle_scope(self->priv->isolate);
	v8::TryCatch try_catch(self->priv->isolate);

	Local<Context> context = v8::Local<v8::Context>::New(self->priv->isolate, self->priv->context);
	Context::Scope context_scope(context);

	Local<String> source = String::NewFromUtf8(self->priv->isolate, function_name, NewStringType::kNormal).ToLocalChecked();
	Handle<v8::Object> global = context->Global();
	Handle<v8::Value> value = global->Get(source);
	Handle<v8::Function> func = v8::Handle<v8::Function>::Cast(value);
	Handle<Value> fargs[args_length1];

	if(args != NULL && args_length1 > 0) {
		nargs = args_length1;
		for(int i=0; i < nargs; i++) {
			if(args[i] == NULL) {
				fargs[i] =  Null(self->priv->isolate);
			} else if (g_type_is_a (G_VALUE_TYPE (args[i]), G_TYPE_INT)) {
				fargs[i] = Integer::New(self->priv->isolate, g_value_get_int(args[i]));
			} else if (g_type_is_a (G_VALUE_TYPE (args[i]), G_TYPE_DOUBLE)) {
				fargs[i] = Number::New(self->priv->isolate, g_value_get_double(args[i]));
			} else if (g_type_is_a (G_VALUE_TYPE (args[i]), G_TYPE_STRING)) {
				fargs[i] = String::NewFromUtf8(self->priv->isolate, g_value_get_string(args[i]), NewStringType::kNormal).ToLocalChecked();
			} else if (g_type_is_a (G_VALUE_TYPE (args[i]), G_TYPE_BOOLEAN)) {
				fargs[i] = Boolean::New(self->priv->isolate, g_value_get_boolean(args[i]));
			} else {
				fargs[i] = Undefined(self->priv->isolate);
			}
		}
	}

	Handle<Value> js_result;
	
	js_result = func->Call(global, args_length1, fargs);

	if (try_catch.HasCaught()) {
		_inner_error_ = report_exception(self->priv->isolate, &try_catch);
		g_propagate_error (error, _inner_error_);
		return NULL;
	} else {
		if (js_result->IsNull()) {
			result = NULL;
		} else if (js_result->IsUndefined()) {
			RubricWebUndefined* _res = rubric_web_undefined_value ();
			result = _res;
		} else if (js_result->IsBoolean()) {
			gboolean _res = js_result->BooleanValue();
			result = _res;
		} else if (js_result->IsInt32()) {
			result = js_result->Int32Value();
		} else if (js_result->IsUint32()) {
			result = js_result->Uint32Value();
		} else if (js_result->IsNumber()) {
			gdouble _res = js_result->NumberValue();
			result = (((&_res) != NULL) && (t_dup_func != NULL)) ? t_dup_func ((gpointer) (&_res)) : ((gpointer) (&_res));
		} else if (js_result->IsString()) {
			String::Utf8Value str(js_result);
			const char* cstr = to_cstring(str);
			result = g_strdup(cstr);
		}
	}
	return result;
}

static gboolean rubric_web_v8_engine_real_has_variable (RubricWebJSEngine* base, const gchar* name) {
	RubricWebV8Engine * self;
	gboolean result = FALSE;
	self = (RubricWebV8Engine*) base;

	g_return_val_if_fail (name != NULL, FALSE);

	Isolate::Scope isolateScope(self->priv->isolate);
	HandleScope handle_scope(self->priv->isolate);
	v8::TryCatch try_catch(self->priv->isolate);

	Local<Context> context = v8::Local<v8::Context>::New(self->priv->isolate, self->priv->context);
	Context::Scope context_scope(context);

	Local<String> var = String::NewFromUtf8(self->priv->isolate, name, NewStringType::kNormal).ToLocalChecked();
	Handle<v8::Object> global = context->Global();
	if(global->Has(var)) {
		if(global->Get(var)->IsUndefined()) {
			result = FALSE;
		} else {
			result = TRUE;
		}
	}

	return result;
}

static gpointer rubric_web_v8_engine_real_get_variable (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* name) {
	RubricWebV8Engine * self;
	gpointer result = NULL;
	self = (RubricWebV8Engine*) base;

	g_return_val_if_fail (name != NULL, NULL);

	Isolate::Scope isolateScope(self->priv->isolate);
	HandleScope handle_scope(self->priv->isolate);
	v8::TryCatch try_catch(self->priv->isolate);

	Local<Context> context = v8::Local<v8::Context>::New(self->priv->isolate, self->priv->context);
	Context::Scope context_scope(context);

	Local<String> var = String::NewFromUtf8(self->priv->isolate, name, NewStringType::kNormal).ToLocalChecked();
	Handle<v8::Object> global = context->Global();
	Handle<v8::Value> value = global->Get(var);
	
	if (value->IsNull()) {
		result = NULL;
	} else if (value->IsUndefined()) {
		RubricWebUndefined* _res = rubric_web_undefined_value ();
		result = _res;
	} else if (value->IsBoolean()) {
		gboolean _res = value->BooleanValue();
		result = _res;
	} else if (value->IsInt32()) {
		result = value->Int32Value();
	} else if (value->IsUint32()) {
		result = value->Uint32Value();
	} else if (value->IsNumber()) {
		gdouble _res = value->NumberValue();
		result = (((&_res) != NULL) && (t_dup_func != NULL)) ? t_dup_func ((gpointer) (&_res)) : ((gpointer) (&_res));
	} else if (value->IsString()) {
		String::Utf8Value str(value);
		const char* cstr = to_cstring(str);
		result = g_strdup(cstr);
	}

	return result;
}

static void rubric_web_v8_engine_real_set_variable (RubricWebJSEngine* base, const gchar* name, GValue* value) {
	RubricWebV8Engine * self;
	self = (RubricWebV8Engine*) base;

	g_return_if_fail (name != NULL);

	Isolate::Scope isolateScope(self->priv->isolate);
	HandleScope handle_scope(self->priv->isolate);
	v8::TryCatch try_catch(self->priv->isolate);

	Local<Context> context = v8::Local<v8::Context>::New(self->priv->isolate, self->priv->context);
	Context::Scope context_scope(context);

	Local<String> var = String::NewFromUtf8(self->priv->isolate, name, NewStringType::kNormal).ToLocalChecked();
	Handle<v8::Object> global = context->Global();
	
	if(value == NULL) {
		global->Set(var, Null(self->priv->isolate));
	} else if (g_type_is_a (G_VALUE_TYPE (value), G_TYPE_INT)) {
		global->Set(var, Integer::New(self->priv->isolate, g_value_get_int(value)));
	} else if (g_type_is_a (G_VALUE_TYPE (value), G_TYPE_DOUBLE)) {
		global->Set(var, Number::New(self->priv->isolate, g_value_get_double(value)));
	} else if (g_type_is_a (G_VALUE_TYPE (value), G_TYPE_STRING)) {
		global->Set(var, String::NewFromUtf8(self->priv->isolate, g_value_get_string(value), NewStringType::kNormal).ToLocalChecked());
	} else if (g_type_is_a (G_VALUE_TYPE (value), G_TYPE_BOOLEAN)) {
		global->Set(var, Boolean::New(self->priv->isolate, g_value_get_boolean(value)));
	} else if (g_type_is_a (G_VALUE_TYPE (value), RUBRIC_WEB_TYPE_UNDEFINED)) {
		global->Set(var, Undefined(self->priv->isolate));
	} else {
		global->Set(var, Undefined(self->priv->isolate));
	}

}


static void rubric_web_v8_engine_real_remove_variable (RubricWebJSEngine* base, const gchar* name) {
	RubricWebV8Engine * self;
	self = (RubricWebV8Engine*) base;

	g_return_if_fail (name != NULL);

	Isolate::Scope isolateScope(self->priv->isolate);
	HandleScope handle_scope(self->priv->isolate);
	v8::TryCatch try_catch(self->priv->isolate);

	Local<Context> context = v8::Local<v8::Context>::New(self->priv->isolate, self->priv->context);
	Context::Scope context_scope(context);

	Local<String> var = String::NewFromUtf8(self->priv->isolate, name, NewStringType::kNormal).ToLocalChecked();
	Handle<v8::Object> global = context->Global();

	if(global->Has(var)) {
		global->Delete(var);
	}

}


static void rubric_web_v8_engine_real_embed_host_object (RubricWebJSEngine* base, const gchar* name, GValue* value) {
	RubricWebV8Engine * self;
	self = (RubricWebV8Engine*) base;

	g_return_if_fail (name != NULL);
	g_return_if_fail (value != NULL);




}


static void rubric_web_v8_engine_real_embed_host_type (RubricWebJSEngine* base, GType t_type, GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func, const gchar* name) {
	RubricWebV8Engine * self;
	self = (RubricWebV8Engine*) base;




	g_return_if_fail (name != NULL);
}


static void rubric_web_v8_engine_real_collect_garbage (RubricWebJSEngine* base) {

	g_assert_not_reached();
}

v8::Local<v8::Context> create_context(v8::Isolate* isolate) {
	// Create a template for the global object.
	v8::Local<v8::ObjectTemplate> global = v8::ObjectTemplate::New(isolate);
	return v8::Context::New(isolate, NULL, global);
}

RubricWebV8Engine* rubric_web_v8_engine_construct (GType object_type) {
	RubricWebV8Engine * self = NULL;
	self = (RubricWebV8Engine*) g_object_new (object_type, NULL);

	Isolate::CreateParams params;
	ArrayBufferAllocator* array_buffer_allocator = new ArrayBufferAllocator();
	params.array_buffer_allocator = array_buffer_allocator;

 	self->priv->isolate = v8::Isolate::New(params);
	HandleScope scope(self->priv->isolate);
	
	v8::Local<v8::Context> context = create_context(self->priv->isolate);

	self->priv->context.Reset(self->priv->isolate, context);

	return self;
}

/**
 * rubric_web_v8_engine_new: (constructor)
 * 
 * Returns: (type RubricWebV8Engine) (transfer full):
 */
RubricWebV8Engine* rubric_web_v8_engine_new (void) {
	return rubric_web_v8_engine_construct (RUBRIC_WEB_V8_TYPE_ENGINE);
}

static const gchar* rubric_web_v8_engine_real_get_name (RubricWebJSEngine* base) {
	return RUBRIC_WEB_V8_ENGINE__name;
}

static const gchar* rubric_web_v8_engine_real_get_version (RubricWebJSEngine* base) {
	return RUBRIC_WEB_V8_ENGINE__version;
}

static gboolean rubric_web_v8_engine_real_get_supports_gc (RubricWebJSEngine* base) {
	return FALSE;
}

static void rubric_web_v8_engine_class_init (RubricWebV8EngineClass * klass) {
	rubric_web_v8_engine_parent_class = g_type_class_peek_parent (klass);

	g_type_class_add_private (klass, sizeof (RubricWebV8EnginePrivate));

	G_OBJECT_CLASS (klass)->get_property = _rubric_web_v8_engine_get_property;
	G_OBJECT_CLASS (klass)->finalize = rubric_web_v8_engine_finalize;
	/**
	 * RubricWebV8Engine:name: (skip)
	 */
	g_object_class_install_property (G_OBJECT_CLASS (klass), RUBRIC_WEB_V8_ENGINE_NAME, g_param_spec_string ("name", "name", "name", NULL, G_PARAM_STATIC_NAME | G_PARAM_STATIC_NICK | G_PARAM_STATIC_BLURB | G_PARAM_READABLE));
	/**
	 * RubricWebV8Engine:version: (skip)
	 */
	g_object_class_install_property (G_OBJECT_CLASS (klass), RUBRIC_WEB_V8_ENGINE_VERSION, g_param_spec_string ("version", "version", "version", NULL, G_PARAM_STATIC_NAME | G_PARAM_STATIC_NICK | G_PARAM_STATIC_BLURB | G_PARAM_READABLE));
	/**
	 * RubricWebV8Engine:supports-gc:
	 */
	g_object_class_install_property (G_OBJECT_CLASS (klass), RUBRIC_WEB_V8_ENGINE_SUPPORTS_GC, g_param_spec_boolean ("supports-gc", "supports-gc", "supports-gc", FALSE, G_PARAM_STATIC_NAME | G_PARAM_STATIC_NICK | G_PARAM_STATIC_BLURB | G_PARAM_READABLE));

	/* Initialize the V8 ICU */
	V8::InitializeICU();
	v8::Platform* platform = platform::CreateDefaultPlatform();
	V8::InitializePlatform(platform);
	V8::Initialize();
}


static void rubric_web_v8_engine_rubric_web_js_engine_interface_init (RubricWebJSEngineIface * iface) {
	rubric_web_v8_engine_rubric_web_js_engine_parent_iface = g_type_interface_peek_parent (iface);
	iface->evaluate = (gpointer (*)(RubricWebJSEngine*, GType, GBoxedCopyFunc, GDestroyNotify, const gchar*, const gchar*, GError**)) rubric_web_v8_engine_real_evaluate;
	iface->execute = (void (*)(RubricWebJSEngine*, const gchar*, const gchar*, GError**)) rubric_web_v8_engine_real_execute;
	iface->execute_file = (void (*)(RubricWebJSEngine*, const gchar*, const gchar*, GError**)) rubric_web_v8_engine_real_execute_file;
	iface->execute_resource = (void (*)(RubricWebJSEngine*, const gchar*, GError**)) rubric_web_v8_engine_real_execute_resource;
	iface->call_function = (gpointer (*)(RubricWebJSEngine*, GType, GBoxedCopyFunc, GDestroyNotify, const gchar*, GValue**, int, GValue*)) rubric_web_v8_engine_real_call_function;
	iface->has_variable = (gboolean (*)(RubricWebJSEngine*, const gchar*)) rubric_web_v8_engine_real_has_variable;
	iface->get_variable = (gpointer (*)(RubricWebJSEngine*, GType, GBoxedCopyFunc, GDestroyNotify, const gchar*)) rubric_web_v8_engine_real_get_variable;
	iface->set_variable = (void (*)(RubricWebJSEngine*, const gchar*, GValue*)) rubric_web_v8_engine_real_set_variable;
	iface->remove_variable = (void (*)(RubricWebJSEngine*, const gchar*)) rubric_web_v8_engine_real_remove_variable;
	iface->embed_host_object = (void (*)(RubricWebJSEngine*, const gchar*, GObject*)) rubric_web_v8_engine_real_embed_host_object;
	iface->embed_host_type = (void (*)(RubricWebJSEngine*, const gchar*, GType)) rubric_web_v8_engine_real_embed_host_type;
	iface->collect_garbage = (void (*)(RubricWebJSEngine*)) rubric_web_v8_engine_real_collect_garbage;
	iface->get_name = rubric_web_v8_engine_real_get_name;
	iface->get_version = rubric_web_v8_engine_real_get_version;
	iface->get_supports_gc = rubric_web_v8_engine_real_get_supports_gc;
}


static void rubric_web_v8_engine_instance_init (RubricWebV8Engine * self) {

	self->priv = RUBRIC_WEB_V8_ENGINE_GET_PRIVATE (self);
}


static void rubric_web_v8_engine_finalize (GObject* obj) {
	RubricWebV8Engine * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, RUBRIC_WEB_V8_TYPE_ENGINE, RubricWebV8Engine);
	if (self->priv->isolate != NULL) {
		self->priv->isolate->Enter();

		self->priv->context.Reset();

		self->priv->isolate->Exit();
		self->priv->isolate->Dispose();
		self->priv->isolate = NULL;
	}

	G_OBJECT_CLASS (rubric_web_v8_engine_parent_class)->finalize (obj);

}


GType rubric_web_v8_engine_get_type (void) {
	static volatile gsize rubric_web_v8_engine_type_id__volatile = 0;
	if (g_once_init_enter (&rubric_web_v8_engine_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (RubricWebV8EngineClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) rubric_web_v8_engine_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (RubricWebV8Engine), 0, (GInstanceInitFunc) rubric_web_v8_engine_instance_init, NULL };
		static const GInterfaceInfo rubric_web_js_engine_info = { (GInterfaceInitFunc) rubric_web_v8_engine_rubric_web_js_engine_interface_init, (GInterfaceFinalizeFunc) NULL, NULL};
		GType rubric_web_v8_engine_type_id;
		rubric_web_v8_engine_type_id = g_type_register_static (G_TYPE_OBJECT, "RubricWebV8Engine", &g_define_type_info, 0);
		g_type_add_interface_static (rubric_web_v8_engine_type_id, RUBRIC_WEB_TYPE_JS_ENGINE, &rubric_web_js_engine_info);
		g_once_init_leave (&rubric_web_v8_engine_type_id__volatile, rubric_web_v8_engine_type_id);
	}
	return rubric_web_v8_engine_type_id__volatile;
}


static void _rubric_web_v8_engine_get_property (GObject * object, guint property_id, GValue * value, GParamSpec * pspec) {
	RubricWebV8Engine * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (object, RUBRIC_WEB_V8_TYPE_ENGINE, RubricWebV8Engine);

	switch (property_id) {
		case RUBRIC_WEB_V8_ENGINE_NAME:
		g_value_set_string (value, rubric_web_js_engine_get_name ((RubricWebJSEngine*) self));
		break;
		case RUBRIC_WEB_V8_ENGINE_VERSION:
		g_value_set_string (value, rubric_web_js_engine_get_version ((RubricWebJSEngine*) self));
		break;
		case RUBRIC_WEB_V8_ENGINE_SUPPORTS_GC:
		g_value_set_boolean (value, rubric_web_js_engine_get_supports_gc ((RubricWebJSEngine*) self));
		break;
		default:
		G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
		break;
	}
}
