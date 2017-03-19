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
using Rubric.Presentation;
using Rubric.Regions;
using Gee;

namespace RubricGtk.Regions {
	
	public class AdapterFactory : Object, Rubric.Regions.AdapterFactory {

		private HashMap<Type, Type> _adapters = new HashMap<Type, Type>();
		
		public Container container {get;construct set;}

		public Rubric.Regions.RegionManager region_manager {get;construct set;}

		public AdapterFactory(Container container, Rubric.Regions.RegionManager region_manager) {
			Object(container : container, region_manager : region_manager);
		}
		
		public Region? get_adapter(Object object) {
			var wtype = object.get_type();
			Type atype = Type.INVALID;
			
			if(_adapters.has_key(wtype))
				atype = _adapters.get(wtype);
			else if(wtype.is_a(typeof(Gtk.Stack)))
				atype = typeof(StackAdapter);
			else if(wtype.is_a(typeof(Gtk.Container)))
				atype = typeof(ContainerAdapter);
			
			if(atype != Type.INVALID)
				return Object.new(atype, "object", object, "container", container, "region-manager", region_manager) as Region;
				
			return null;
		}
		
		public void set_adapter_type(Type object_type, Type adapter_type) {
			_adapters.set(object_type, adapter_type);
		}

	}
	
}
