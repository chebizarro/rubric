/*
 * Rubric -- a Vala framework for responsive applications
 * Copyright 2017 Chris Daley <chebizarro@gmail.com>
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
 
namespace Rubric {

	public class GirResourceHandler : Object, ContainerExtension, ResourceHandler {

		public unowned Container container {get;construct set;}

		public GirResourceHandler(Container cont) {
			this.container = cont;
		}

		
		public bool handles(string filename) {
			if(filename.has_suffix(".gir"))
				return true;
			return false;
		}
		
		public void add(string filename, Assembly? assembly = null) throws ContainerError {
			
			try {
				var resfile = new XmlFile.from_resource(filename);
				
				resfile.register_ns("xmlns", "http://www.gtk.org/introspection/core/1.0");
				resfile.register_ns("c", "http://www.gtk.org/introspection/c/1.0");
				resfile.eval ("/xmlns:repository/xmlns:namespace/xmlns:class[./xmlns:annotation/@key='container.register']");

				if(resfile.size > 0) {
					foreach(var node in resfile) {
						var tname = node->get_prop("type-name");
						
						if(tname == null)
							continue;

						var t = Type.from_name(node->get_prop("type-name"));

						if(t == Type.INVALID && assembly != null)
							t = load_type(node->get_prop("get-type"), assembly);

						if(t == Type.INVALID)
							continue;

						debug("Autoregistering %s", tname);

						var child = node->children;
						while (child != null) {
							if(child->name == "annotation" && child->get_prop("key") == "container.name") {
								var name = child->get_prop("value");
								container.register_type(t,t, name);
								foreach(unowned Type iface in t.interfaces())
									container.register_type(iface,t, name);
								break;
							}
							child = child->next;
						}
						if(child == null)
							container.register_type(t,t);
					}
				}

			} catch (Error e) {
				debug(e.message);
			}
		}
		
		private delegate Type TypeLoader();
		
		private Type load_type(string name, Assembly assembly) {
			if (!File.new_for_path(assembly.binary).query_exists())
				return Type.INVALID;
			
			var module = GLib.Module.open (assembly.binary, ModuleFlags.BIND_LOCAL);
			
			if(module == null)
				return Type.INVALID;
			
			void* function;
			if(module.symbol(name, out function)) {
				if (function != null) {
					var loader = (TypeLoader)function;
					return loader();
				}
			}
			return Type.INVALID;
		}
	}


}
