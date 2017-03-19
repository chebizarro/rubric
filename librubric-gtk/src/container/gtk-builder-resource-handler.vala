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

using Rubric;

namespace RubricGtk {

	public class GtkBuilderResourceHandler : Object, ContainerExtension, ResourceHandler {

		public unowned Container container {get;construct set;}

		public GtkBuilderResourceHandler(Container container) {
			Object(container : container);
		}

		public bool handles(string filename) {
			if(filename.has_suffix(".ui"))
				return true;
			return false;
		}

		public void add(string filename, Assembly? assembly = null) throws ContainerError {

			try {
				var resfile = new XmlFile.from_resource(filename);

				resfile.eval ("/interface/template");

				if(resfile.size > 0)
					return;

				var builder = new Gtk.Builder();
				builder.expose_object("container", container);
				builder.add_from_resource(filename);
				
				resfile.eval ("/interface/menu");
				
				if(resfile.size > 0) {
					var menu_manager = container.resolve<MenuManager>();
				
					foreach(Xml.Node* node in resfile) {
						var menuname = node->get_prop("id");
						if(menuname != null) {
							var menu = builder.get_object (menuname) as GLib.Menu;
							menu_manager.add_menu(menuname, menu);
						}
					}
				} else {
					resfile.eval ("/interface/object");
					if(resfile.size <= 0)
						return;

					foreach (Xml.Node* node in resfile) {
						var objname = node->get_prop("id");
						if(objname != null) {
							var obj = builder.get_object(objname);
							container.register_type_instance(obj.get_type(), obj, objname);
							container.decorate(obj.get_type(), obj, objname);
						}
					}
				}
			} catch (Error e) {
				debug(e.message);
			}
		}
	}

}
