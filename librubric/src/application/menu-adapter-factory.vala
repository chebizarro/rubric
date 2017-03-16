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
using Gee;

namespace Rubric {
	
	public interface MenuAdapterFactory : Object {

		public abstract MenuAdapter? get_adapter(Object object);
		
		public virtual void set_adapter<T,AT>() {
			set_adapter_type(typeof(T), typeof(AT));
		}

		public abstract void set_adapter_type(Type object_type, Type adapter_type);
	}
	
	public abstract class MenuAdapter : Object {
		
		public Object object {get;construct set;}
		
		public abstract void set_menu(GLib.Menu menu);
	
	}
	
}
