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


	public errordomain MenuManagerError {
		EXTENSION_NOT_FOUND,
		DUPLICATE_MENU_ID
	}

	public class MenuManager : GLib.Object {

		internal Gee.HashMap <GLib.Menu, MenuExtension> menus;
		internal Gee.HashMap <string, GLib.Menu> extensions;
		internal Gee.HashMap <string, GLib.Menu> menus_by_name;
		
		public enum InsertMode {
			APPEND,
			PREPEND
		}
		
		construct {
			this.menus = new Gee.HashMap <GLib.Menu, MenuExtension> ();
			this.extensions = new Gee.HashMap <string, GLib.Menu> ();
			this.menus_by_name = new Gee.HashMap <string, GLib.Menu> ();
		}
	
	
		public GLib.Menu? find_menu(string name) {
			return menus_by_name.get(name);
		}
	
		public void add_menu (
			string name,
			GLib.Menu menu,
			InsertMode insertmode = InsertMode.APPEND)
			throws MenuManagerError {
			
			if (menus_by_name.has_key(name))
				throw new MenuManagerError.DUPLICATE_MENU_ID(
					"There is already a Menu with the name %s registered",
					name);
					
			menus_by_name.set(name, menu);
			add_extension_points (menu, insertmode);
		}

		public void append_menu (GLib.Menu menu) {
			add_extension_points (menu);
		}

		public void prepend_menu (GLib.Menu menu) {
			add_extension_points (menu, InsertMode.PREPEND);
		}

		public void remove_menu (GLib.Menu menu) {
			if (menus.has_key (menu)) {
				var extpt = menus.get (menu);
				extpt.remove_items ();
			}
		}

		public GLib.Menu get_menu (string extension) throws MenuManagerError {
			if (extensions.has_key (extension)) {
				return extensions.get (extension);
			}
			throw new MenuManagerError.EXTENSION_NOT_FOUND ("A Menu with the id \"%s\" was not found", extension);
		}
	
		private void add_extension_points (GLib.Menu model, InsertMode insertmode = InsertMode.APPEND) {
			int n_items = model.get_n_items ();

			for (int i = 0; i < n_items; i++) {

				var link_iter = model.iterate_item_links (i);
				bool islink = false;
				
				while (link_iter.next()) {
					islink = true;
					char* link_value;
					if (model.get_item_attribute (i, "id", "s", out link_value)) {
						if (extensions.has_key ((string)link_value)) {
							var next = new MenuExtension(extensions.get ((string)link_value));
							if (insertmode == InsertMode.APPEND) {
								next.append_menu_item (new GLib.MenuItem.from_model (link_iter.get_value(),0));
							} else {
								next.prepend_menu_item (new GLib.MenuItem.from_model (link_iter.get_value(),0));
							}
							this.menus.set (model, next);
						} else {
							this.extensions.set ((string)link_value, link_iter.get_value() as GLib.Menu);
						}
					}
					add_extension_points (link_iter.get_value() as GLib.Menu, insertmode);
				}
				
				if (!islink) {
					char* attr_value;
					if (model.get_item_attribute (i, "id", "s", out attr_value))
						if (extensions.has_key ((string)attr_value)) {
							var attrext = new MenuExtension(extensions.get ((string)attr_value));
							if (insertmode == InsertMode.APPEND) {
								attrext.append_menu_item (new GLib.MenuItem.from_model (model,0));
							} else {
								attrext.prepend_menu_item (new GLib.MenuItem.from_model (model,0));
							}
							this.menus.set (model , attrext);
						} else {
							this.extensions.set ((string)attr_value, model);
						}
					
				}

			}
		}


	}

}
