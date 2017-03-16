/* 
 * Rubric -- a Vala framework for responsive applications
 * Copyright (C) 2016 Chris Daley
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
 *
 * based on gedit-menu-extension.c
 * Copyright (C) 2014 - Ignacio Casal Quinteiro
 */

namespace Rubric {

	static int last_merge_id = 0;
	
	public class MenuExtension : GLib.Object {

		internal GLib.Menu menu {get; private set;}
		private int merge_id;

		public MenuExtension (GLib.Menu menu) {
			this.menu = menu;
			this.merge_id = ++last_merge_id;
		}

		~MenuExtension () {
			remove_items ();
		}

		public void append_menu_item (GLib.MenuItem item)
			requires (menu != null)
		{
				item.set_attribute ("rubric-merge-id", "u", this.merge_id);
				menu.append_item (item);
		}

		public void prepend_menu_item (GLib.MenuItem item)
			requires (menu != null)
		{
				item.set_attribute ("rubric-merge-id", "u", this.merge_id);
				menu.prepend_item (item);
		}

		public void	remove_items () {
			int i =0;
			int n_items = menu.get_n_items ();

			while (i < n_items) {
				int id;

				if (menu.get_item_attribute (i, "rubric-merge-id", "u", out id) &&
					(id == this.merge_id)) {
					menu.remove (i);
					n_items--;
				} else {
					i++;
				}
			}
		}
	}
}
