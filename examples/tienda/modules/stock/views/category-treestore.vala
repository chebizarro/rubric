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

namespace Tienda.Modules.Stock {

	public class CategoryTreeStore : GLib.Object, Gtk.TreeModel {
		
		public enum Columns {
			ICON,
			NAME,
			LAST
		}
		
		private Gom.ResourceGroup resource;
		private ParamSpec[] properties;
		private int stamp = 0;

		public CategoryTreeStore (Gom.ResourceGroup resource) {
			this.resource = resource;
			var ocl = (ObjectClass)resource.resource_type.class_ref();
			this.properties = ocl.list_properties();
			Log.set_handler("Gom", LogLevelFlags.LEVEL_WARNING | LogLevelFlags.FLAG_RECURSION, (d,f,m) => {});
		}

		public GLib.Type get_column_type (int index) {
			if(this.properties == null || index > this.properties.length)
					return GLib.Type.INVALID;
			return this.properties[index].value_type;
			
			/*
			switch (index) {
				case Columns.ICON:
					return typeof (Gdk.Pixbuf);
				case Columns.NAME:
					return typeof (string);
				default:
					return GLib.Type.INVALID;
			}*/
		}

		public Gtk.TreeModelFlags get_flags () {
			return 0;
		}

		public void get_value (Gtk.TreeIter iter, int column, out GLib.Value val)
			requires (iter.stamp == stamp)
			requires (column >= 0)
			requires (column < this.properties.length)
		{
			try {
				resource.fetch_sync((uint)iter.user_data, 1);
			} catch (GLib.Error error) {
				message(error.message);
			}
			
			var prop = this.properties[column];
			dynamic Gom.Resource res = resource.get_index((uint)iter.user_data);

			val = Value(prop.value_type);
			res.get_property(prop.name, ref val);
			
			/*
			switch (column) {
			case Columns.ICON:
				Gdk.Pixbuf px;
				if(res.image != null) {
					var path = "/org/tienda/modules/stock/data/images/%s.svg".printf(res.image);
					px = new Gdk.Pixbuf.from_resource(path);
				} else {
					Gtk.IconTheme icon_theme = Gtk.IconTheme.get_default ();
					px = icon_theme.load_icon("image-missing", 20, 0);
				}
				val = Value (typeof (Gdk.Pixbuf));
				val.set_object (px);
				break;

			case Columns.NAME:
				val = Value (typeof (string));
				val.set_string (res.name);
				break;

			default:
				val = Value (Type.INVALID);
				break;
			}*/
		}

		public bool get_iter (out Gtk.TreeIter iter, Gtk.TreePath path) {
			if (path.get_depth () != 1 || resource.count == 0) {
				return invalid_iter (out iter);
			}

			iter = Gtk.TreeIter ();
			iter.user_data = path.get_indices()[0].to_pointer();
			iter.stamp = this.stamp;
			return true;
		}

		public int get_n_columns () {
			return Columns.LAST;
		}

		public Gtk.TreePath? get_path (Gtk.TreeIter iter)
			requires (iter.stamp == stamp)
		{
			Gtk.TreePath path = new Gtk.TreePath ();
			path.append_index ((int) iter.user_data);
			return path;
		}

		public int iter_n_children (Gtk.TreeIter? iter)
			//requires (iter == null || iter.stamp == stamp)
		{
			return (iter == null)? (int)resource.count : 0;
		}

		public bool iter_next (ref Gtk.TreeIter iter)
			requires (iter.stamp == stamp)
		{
			uint pos = ((uint) iter.user_data) + 1;
			if (pos >= resource.count) {
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
			requires (parent == null || parent.stamp == stamp)
		{

			if (parent == null && n < (int)resource.count) {
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
