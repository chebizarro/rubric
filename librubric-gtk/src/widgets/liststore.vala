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

using Gee;

namespace RubricGtk.Widgets {

	public class ListStore : GLib.Object, ListModel {
		
		private Gee.List<Object> list;
		private Type item_type;

		public ListStore (Gee.List<Object> list) {
			this.list = list;
			this.item_type = list.element_type;
		}

		public GLib.Type get_item_type () {
			return item_type;
		}

		public Object? get_item (uint position) {			
			return list[(int)position];
		}

		public uint get_n_items () {
			return (uint)list.size;
		}
		

	}
}
