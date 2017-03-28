/*
 * Rubric -- a Vala framework for responsive applications
 * Copyright 2016 Chris Daley <chebizarro@gmail.com>
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
using Rubric;
using Rubric.PM;
using Rubric.Collections;
using Rubric.Regions;

[CCode (gir_namespace = "RubricGtk", gir_version = "1.0")]
namespace RubricGtk.Regions {
	
	public class ViewRegistry : Object, Rubric.Regions.ViewRegistry {

		private class Resolver {
			private Rubric.Resolver<View> resolver;
			
			public Resolver(owned Rubric.Resolver<View> resolver) {
				this.resolver = (owned)resolver;
			}
			
			public View resolve() {
				return resolver();
			}
		}

		public Container container {get;construct set;}

		private Gee.HashMap<string, Gee.ArrayList<Resolver>> _content =  new Gee.HashMap<string, Gee.ArrayList<Resolver>>();

		private HashTable<string, GLib.List<string>> _views = new HashTable<string, GLib.List<string>>(str_hash, str_equal);
		
		public HashTable<string, GLib.List<string>> views {
			get {
				return _views;
			}
			set {
				foreach(var key in value.get_keys()) {
					if(!_views.contains(key))
						_views.set(key, new GLib.List<string>());

					unowned List<string> l = value.get(key);

					for(int i = 0; i < l.length(); i++) {
						string res = l.nth_data(i);
						register_view_type_name(res, key);
						debug("View: %s registered for: %s", res, key);
						_views.get(key).append(res);
					}
				}
			}
		}

		private void register_view_type_name(string view_type, string region_name) {
			if(!_content.has_key(region_name)) {
				_content.set(region_name, new Gee.ArrayList<Resolver>());
			}
			var resolvers = _content.get(region_name);
			Rubric.Resolver<View> res = () => { 
				try {
					debug("Creating view for %s", view_type);
					return container.resolve_type_name(view_type) as View;
				} catch (GLib.Error e) {
					warning(e.message);
				}
				return null;
			};
			resolvers.add(new Resolver((owned)res));
			
		}

		public ViewRegistry(Container container) {
			Object(container: container);
		} 

		public Iterator<View> get_contents(string region_name) {
			
			View[] vs = {};
			
			if(_content.has_key(region_name)) {
				var resolvers = _content.get(region_name);
				foreach(var resolver in resolvers) {
					vs += resolver.resolve();
				}
			}
			return new Iterator<View>(vs);
		}

		public void register_view_type(Type view_type, string region_name) {
			if(!_content.has_key(region_name)) {
				_content.set(region_name, new Gee.ArrayList<Resolver>());
			}
			var resolvers = _content.get(region_name);
			Rubric.Resolver<View> res = () => { 
				try {
					assert(container != null);
					return container.resolve_type(view_type) as View;
				} catch (GLib.Error e) {
					warning(e.message);
				}
				return null;
			};
			resolvers.add(new Resolver((owned)res));

		}

		public void register_view_resolver(string region_name, owned Rubric.Resolver<View> resolver) {
			if(!_content.has_key(region_name)) {
				_content.set(region_name, new Gee.ArrayList<Resolver>());
			}
			var resolvers = _content.get(region_name);
			resolvers.add(new Resolver(resolver));
		}

	}
	
}
