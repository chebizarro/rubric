/* 
 * Rubric -- a Vala framework for responsive applications
 * Copyright (C) 2017 Chris Daley
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
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

namespace Rubric {

	public class Preferences : GLib.Object {
	
		public string schema_id {get;private set;}
		public GLib.Settings settings {get;private set;}
	
		private SettingsSchemaSource sss;
	
		public Preferences(string schema_id) throws Error {
			this.schema_id = schema_id;
			settings = new GLib.Settings (this.schema_id);
			sss = SettingsSchemaSource.get_default();
		}
		
		public void apply(GLib.Object object, string? child_schema = null) throws Error {
			
			unowned ObjectClass objclass = object.get_class();
			
			GLib.Settings localsettings;
			GLib.SettingsSchema schema;
			
			if (child_schema != null) {
				schema = sss.lookup ("%s.%s".printf(this.schema_id, child_schema) , true);
				localsettings = new Settings.full (schema, null, null);
			} else {
				localsettings = settings;
				schema = settings.settings_schema;
			}
			
			foreach(string key in localsettings.list_keys()) {
				var pspec = objclass.find_property(key);
				if (pspec != null) {
					var skey = schema.get_key(key);
					var t = skey.get_value_type();
					
					if (pspec.value_type == typeof(bool) && t.equal(VariantType.BOOLEAN))
						object.set(key, localsettings.get_boolean(key));
					else if (pspec.value_type == typeof(string) && t.equal(VariantType.STRING))
						object.set(key, localsettings.get_string(key));
					else if (pspec.value_type == typeof(double) && t.equal(VariantType.DOUBLE))
						object.set(key, localsettings.get_double(key));
					else if (pspec.value_type == typeof(int) && t.equal(VariantType.INT16))
						object.set(key, localsettings.get_default_value(key).get_int16());
					
				}
			}
		}
	}
}
