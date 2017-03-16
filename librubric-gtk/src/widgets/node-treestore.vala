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

using Rubric.Collections;

namespace RubricGtk.Widgets {

	public class NodeTreeStore : GLib.Object, Gtk.TreeModel {

		private Rubric.Collections.Node root;
		private ParamSpec[] properties;
		private int stamp = 0;

		public NodeTreeStore (Rubric.Collections.Node root) {
			this.root = root;
			var ocl = (ObjectClass)root.get_type().class_ref();
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
			requires (column < properties.length)
		{
			var node = (Rubric.Collections.Node) iter.user_data;
			var prop = this.properties[column];

			val = Value(prop.value_type);
			node.get_property(prop.name, ref val);
		}

		public bool get_iter (out Gtk.TreeIter iter, Gtk.TreePath path) {
			iter = Gtk.TreeIter ();
			
			var indices = path.get_indices ();
			
			Rubric.Collections.Node? node = null;
			var prevnode = this.root;
			
			foreach (int index in indices) {
				node = prevnode;
				for (int i = 0; i < index; i++) {
					node = node.get_next();
				}
				prevnode = node.get_children();
			}
			
			if (node == null)
				return invalid_iter (out iter);
				
			iter.user_data = node;
			iter.stamp = this.stamp;
			return true;
		}

		public int get_n_columns () {
			return this.properties.length;
		}

		public Gtk.TreePath? get_path (Gtk.TreeIter iter)
			requires (iter.stamp == stamp)
		{
			Gtk.TreePath path = new Gtk.TreePath ();
			var node = iter.user_data as Rubric.Collections.Node;
			
			int i = 0;
			while (node != null) {
				if (node.get_previous() != null) {
					node = node.get_previous();
					i++;
				} else if (node == root) {
					path.prepend_index (i);
					break;
				} else {
					node = node.get_parent();
					path.prepend_index (i);
					i = 0;
				}
			}
			return path;
		}

		public int iter_n_children (Gtk.TreeIter? iter) {
			if (iter == null) return 0;

			GLib.assert (iter.stamp == this.stamp);
			
			int n_children = 0;
			var node = iter.user_data as Rubric.Collections.Node;
			node = node.get_children();
			while (node != null) {
				n_children++;
				node = node.get_next();
			}
			return n_children;
		}

		public bool iter_next (ref Gtk.TreeIter iter)
			requires (iter.stamp == stamp)
		{
			var node = iter.user_data as Rubric.Collections.Node;
			
		
			if (node.get_next() != null) {
				iter.user_data = node.get_next();
				return true;
			}
			return false;
		}

		public bool iter_previous (ref Gtk.TreeIter iter)
			requires (iter.stamp == stamp)
		{
			var node = iter.user_data as Rubric.Collections.Node;
			if (node.get_previous() != null) {
				iter.user_data = node.get_previous();
				return true;
			}
			return false;
		}

		public bool iter_nth_child (out Gtk.TreeIter iter, Gtk.TreeIter? parent, int n)
		{
			iter = Gtk.TreeIter ();
			iter.stamp = stamp;

			if (parent == null) {
				if (n == 0) {
					iter.user_data = this.root;
					return true;
				}
				return invalid_iter (out iter);
			}

			var node = parent.user_data as Rubric.Collections.Node; 
			if (node == null) return invalid_iter (out iter);

			var child = node.get_nth_child(n);
			if (child != null) {
				iter.user_data = child;
				return true;
			}
			return invalid_iter (out iter);
		}

		public bool iter_children (out Gtk.TreeIter iter, Gtk.TreeIter? parent) {
			iter = Gtk.TreeIter ();
			iter.stamp = stamp;

			if (parent == null) {
				iter.user_data = this.root;
				return true;
			}
			var node = parent.user_data as Rubric.Collections.Node;
			if (node.get_children() == null)
				return invalid_iter (out iter);
			
			iter.user_data = node.get_children();
			return true;
		}

		public bool iter_has_child (Gtk.TreeIter iter)
			requires (iter.stamp == stamp)
		{
			var node = iter.user_data as Rubric.Collections.Node;
			if (node.get_children() != null)
				return true;
			return false;
		}

		public bool iter_parent (out Gtk.TreeIter iter, Gtk.TreeIter child)
			requires (child.stamp == stamp)
		{
			var node = child.user_data as Rubric.Collections.Node; 
			
			if (node == this.root)
				return invalid_iter (out iter);
			
			iter = Gtk.TreeIter ();
			iter.stamp = stamp;
			iter.user_data = node.get_parent();
			return true;
			
		}

		private bool invalid_iter (out Gtk.TreeIter iter) {
			iter = Gtk.TreeIter ();
			iter.stamp = -1;		
			return false;
		}

	}
}
