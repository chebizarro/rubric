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
using Rubric.Regions;
using RubricGtk.Regions;

namespace RubricGtk.PM {
	
	public interface ContainerView : Gtk.Container, View {
		
		protected virtual void find_regions(Gtk.Widget widget) {
			
			if (widget is Gtk.Container != true)
				return;
			
			var cont = widget as Gtk.Container;
			
			try {
				var adapter_factory = container.resolve<Rubric.Regions.AdapterFactory>();
				var menu_adapter_factory = container.resolve<Rubric.MenuAdapterFactory>();
				var menu_manager = container.resolve<Rubric.MenuManager>();
				
				
				cont.forall((w) => {
					if (w is Rubric.Regions.Region) {
						region_manager.regions.add(w.get_name(), w as Rubric.Regions.Region);
					} else if (w.get_name() != null &&
						w.get_name().has_prefix("region.")) {
						var wname = w.get_name();
						var viewname = wname[7:wname.length];
						var view = adapter_factory.get_adapter(w);
						if(view != null)
							region_manager.regions.add(viewname,view);
					} else if (w.get_name() != null &&
						w.get_name().has_prefix("menu.")) {
						var wname = w.get_name();
						var menuname = wname[5:wname.length];
						var adapter = menu_adapter_factory.get_adapter(w);
						var menu = menu_manager.find_menu(menuname);
						if(menu != null)
							adapter.set_menu(menu);

					}
					find_regions(w);
				});
			} catch (GLib.Error e) {
				warning(e.message);
			}
		}
		
	}
}
