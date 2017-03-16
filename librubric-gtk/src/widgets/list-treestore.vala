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

	public class ListTreeStore : GLib.Object, Gtk.TreeModel {
		
		private Gee.List<Object> list;
		private ParamSpec[] properties;
		private int stamp = 0;

		public ListTreeStore (Gee.List<Object> list) {
			this.list = list;
			var ocl = (ObjectClass)list.element_type.class_ref();
			this.properties = ocl.list_properties();
		}

		public GLib.Type get_column_type (int index) {
			if(this.properties == null || index > this.properties.length)
					return GLib.Type.INVALID;
			return this.properties[index].value_type;
		}

		public Gtk.TreeModelFlags get_flags () {
			return 0;
		}

		public void get_value (Gtk.TreeIter iter, int column, out GLib.Value val)
			requires (iter.stamp == stamp)
			requires (column >= 0)
			requires (column < this.properties.length)
		{
			var prop = this.properties[column];
			dynamic Object obj = list.get((int)iter.user_data);

			val = Value(prop.value_type);
			obj.get_property(prop.name, ref val);
		}

		public bool get_iter (out Gtk.TreeIter iter, Gtk.TreePath path) {
			if (path.get_depth () != 1 || list.size == 0) {
				return invalid_iter (out iter);
			}

			iter = Gtk.TreeIter ();
			iter.user_data = path.get_indices()[0].to_pointer();
			iter.stamp = this.stamp;
			return true;
		}

		public int get_n_columns () {
			return properties.length;
		}

		public Gtk.TreePath? get_path (Gtk.TreeIter iter)
			requires (iter.stamp == stamp)
		{
			Gtk.TreePath path = new Gtk.TreePath ();
			path.append_index ((int) iter.user_data);
			return path;
		}

		public int iter_n_children (Gtk.TreeIter? iter)
			requires (iter == null)
		{
			return (iter == null)? list.size : 0;
		}

		public bool iter_next (ref Gtk.TreeIter iter)
			requires (iter.stamp == stamp)
		{
			uint pos = ((uint) iter.user_data) + 1;
			if (pos >= list.size) {
				return false;
			}
			iter.user_data = pos.to_pointer ();
			return true;
		}

		public bool iter_previous (ref Gtk.TreeIter iter)
			requires (iter.stamp == stamp)
		{
			int pos = (int) iter.user_data;
			if (pos >= 0) {
				return false;
			}
			iter.user_data = (--pos).to_pointer ();
			return true;
		}

		public bool iter_nth_child (out Gtk.TreeIter iter, Gtk.TreeIter? parent, int n)
			requires (parent == null)
		{

			if (parent == null && n < (int)list.size) {
				iter = Gtk.TreeIter ();
				iter.stamp = stamp;
				iter.user_data = n.to_pointer ();
				return true;
			}

			// Only used for trees
			return invalid_iter (out iter);
		}

		public bool iter_children (out Gtk.TreeIter iter, Gtk.TreeIter? parent)
			requires (parent == null || parent.stamp == stamp)
		{
			return invalid_iter (out iter);;
		}

		public bool iter_has_child (Gtk.TreeIter iter)
			requires (iter.stamp == stamp)
		{
			return false;
		}

		public bool iter_parent (out Gtk.TreeIter iter, Gtk.TreeIter child)
			requires (child.stamp == stamp)
		{
			return invalid_iter (out iter);;
		}

		private bool invalid_iter (out Gtk.TreeIter iter) {
			iter = Gtk.TreeIter ();
			iter.stamp = -1;		
			return false;
		}

	}
}
