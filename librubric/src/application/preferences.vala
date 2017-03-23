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
		private SettingsSchema schema;
		
		private weak Preferences parent;
		
		private bool from_dir = false;
		
		public Preferences.from_directory(string schema_id, string directory, Preferences parent) throws Error {
			this.sss = new SettingsSchemaSource.from_directory(directory, parent.sss, true);
			this.parent = parent;
			this.schema = sss.lookup(schema_id, true);

			if(schema == null)
				throw new IOError.NOT_FOUND("The schema %s was not found", schema_id);

			this.schema_id = schema_id;
			this.settings = new GLib.Settings.full(schema, null, null);
			this.from_dir = true;
		}
		
		public Preferences(string schema_id) throws Error {
			this.sss = SettingsSchemaSource.get_default();

			this.schema = sss.lookup(schema_id, true);
			
			if(this.schema == null)
				throw new IOError.NOT_FOUND("The schema %s was not found", schema_id);
			
			this.schema_id = schema_id;
			this.settings = new GLib.Settings (this.schema_id);
		}
		
		public Object apply(GLib.Object object, string? child_schema = null) throws Error {
			
			unowned ObjectClass objclass = object.get_class();
			
			GLib.Settings localsettings = settings;
			GLib.SettingsSchema sschema = schema;
			
			if (child_schema != null) {
				var sid = "/%s/".printf(this.schema_id.replace(".","/"));
				sschema = sss.lookup ("%s.%s".printf(this.schema_id, child_schema) , true);
				if(sschema == null) {
					sschema = sss.lookup (child_schema , true);
					if(sschema == null)
						return object;
					if(!from_dir)
						localsettings = new Settings.with_path (child_schema, sid);
					else
						localsettings = new Settings.full (sschema, null, sid);
				} else {
					localsettings = new Settings.full (sschema, null, null);
				}
			}
		
			foreach(string key in sschema.list_keys()) {
				var pspec = objclass.find_property(key);
				if (pspec != null) {
					if((pspec.flags & ParamFlags.WRITABLE) != ParamFlags.WRITABLE)
						continue;
						
					var skey = sschema.get_key(key);
					var t = skey.get_value_type();
					
					switch ((string)t.peek_string()) {
						case "d":
							if(pspec.value_type == typeof(double))
								object.set(key, localsettings.get_double(key));
							break;
						case "i":
							if(pspec.value_type == typeof(int))
								object.set(key, localsettings.get_value(key));
							break;
						case "as":
							if(pspec.value_type == typeof(string[]))
								object.set(key, localsettings.get_strv(key));
							break;
						case "b":
							if(pspec.value_type == typeof(bool))
								object.set(key, localsettings.get_boolean(key));
							break;
						case "s":
							if(pspec.value_type == typeof(string))
								object.set(key, localsettings.get_string(key));
							break;
						case "n":
							if(pspec.value_type == typeof(int))
								object.set(key, localsettings.get_default_value(key).get_int16());
							break;
						case "a{sas}":
							if(pspec.value_type == typeof(HashTable)) {
								
								var ht = new HashTable<string, List<string>>(str_hash, str_equal);
								var val = localsettings.get_value(key);
								
								for(int i = 0; i < val.n_children(); i++) {
									var l = new List<string>();
									var arr = val.get_child_value(i).get_child_value(1).get_strv();
									foreach (var str in arr)
										l.append(str);
									ht.set(val.get_child_value(i).get_child_value(0).get_string(),(owned)l);
								}
								object.set(key, ht);
							}
							break;
						default:
							object.set(key, localsettings.get_value(key));
							break;
					
					}
				}
			}
		
			return object;
		}

	}
}
