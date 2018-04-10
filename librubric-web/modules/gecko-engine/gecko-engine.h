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
#ifndef GECKO_ENGINE_H
#define GECKO_ENGINE_H

#include <glib.h>
#include <glib-object.h>
#include <rubric-web.h>

G_BEGIN_DECLS

GType rubric_web_gecko_engine_get_type (void) G_GNUC_CONST;

#define RUBRIC_WEB_GECKO_TYPE_ENGINE (rubric_web_gecko_engine_get_type ())
#define RUBRIC_WEB_GECKO_ENGINE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), RUBRIC_WEB_GECKO_TYPE_ENGINE, RubricWebGeckoEngine))
#define RUBRIC_WEB_GECKO_ENGINE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), RUBRIC_WEB_GECKO_TYPE_ENGINE, RubricWebGeckoEngineClass))
#define RUBRIC_WEB_GECKO_IS_ENGINE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), RUBRIC_WEB_GECKO_TYPE_ENGINE))
#define RUBRIC_WEB_GECKO_IS_ENGINE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), RUBRIC_WEB_GECKO_TYPE_ENGINE))
#define RUBRIC_WEB_GECKO_ENGINE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), RUBRIC_WEB_GECKO_TYPE_ENGINE, RubricWebGeckoEngineClass))

typedef struct _RubricWebGeckoEngine RubricWebGeckoEngine;
typedef struct _RubricWebGeckoEngineClass RubricWebGeckoEngineClass;
typedef struct _RubricWebGeckoEnginePrivate RubricWebGeckoEnginePrivate;

struct _RubricWebGeckoEngine {
	GObject parent_instance;
	RubricWebGeckoEnginePrivate * priv;
};

struct _RubricWebGeckoEngineClass {
	GObjectClass parent_class;
};


RubricWebGeckoEngine* rubric_web_gecko_engine_new (void);
RubricWebGeckoEngine* rubric_web_gecko_engine_construct (GType object_type);

G_END_DECLS

#endif /* GECKO_ENGINE_H */
