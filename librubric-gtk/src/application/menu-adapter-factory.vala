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
using Gee;

namespace RubricGtk {
	
	public class MenuAdapterFactory : Object, Rubric.MenuAdapterFactory {

		private HashMap<Type, Type> _adapters = new HashMap<Type, Type>();
		
		public MenuAdapter? get_adapter(Object object) {
			var wtype = object.get_type();
			Type atype = Type.INVALID;
			
			if(_adapters.has_key(wtype))
				atype = _adapters.get(wtype);
			else if(object is Gtk.Popover)
				atype = typeof(PopoverAdapter);
			else if(object is Gtk.MenuShell)
				atype = typeof(MenuShellAdapter);
			else if(object is Gtk.MenuButton)
				atype = typeof(MenuButtonAdapter);
			
			if(atype != Type.INVALID)
				return Object.new(atype, "object", object) as MenuAdapter;
				
			return null;
		}
		
		public void set_adapter_type(Type object_type, Type adapter_type) {
			_adapters.set(object_type, adapter_type);
		}

	}

	public class MenuButtonAdapter : MenuAdapter {
		
		public override void set_menu(GLib.Menu menu) {
			var butt = this.object as Gtk.MenuButton;
			if(butt.popover != null)
				butt.popover.bind_model(menu, null);
		}
	
	}

	public class PopoverAdapter : MenuAdapter {
		
		public override void set_menu(GLib.Menu menu) {
			var pop = this.object as Gtk.Popover;
			pop.bind_model(menu, null);
		}
	
	}

	public class MenuShellAdapter : MenuAdapter {
		
		public override void set_menu(GLib.Menu menu) {
			var shell = this.object as Gtk.MenuShell;
			shell.bind_model(menu, null, false);
		}
	
	}

	
}
