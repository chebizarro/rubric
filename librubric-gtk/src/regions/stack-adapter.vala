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
using Rubric.PM;
using Rubric.Regions;
using Gee;

namespace RubricGtk.Regions {
	
	internal class StackAdapter : RegionAdapter {
		
		private Gtk.Stack stack;
		
		construct {
			stack = object as Gtk.Stack;
		}
		
		public override Rubric.Regions.RegionManager add_view(View view, string? name = null) {
			stack.add_titled(view as Gtk.Widget, view.get_type().name(), ((Gtk.Widget)view).name);
			return base.add_view(view, name);
		}
		
		public override void remove_view(View view) {
			stack.remove(view as Gtk.Widget);
			base.remove_view(view);
		}
		
		public override void remove_all_views() {
			foreach(var child in stack.get_children())
				child.destroy();
			
			base.remove_all_views();
		}
		
	}
	
}
