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

public delegate T Rubric.Resolver<T>();


namespace Rubric.Regions {

	public errordomain Error {
		NOT_FOUND
	}
	

	public interface RegionManager : Object {
		
		public abstract RegionCollection regions {get;}

		public abstract RegionManager add_to_region(string name, View view) throws Rubric.Regions.Error;
		
		public virtual RegionManager register_view<T>(string regionname) {
			return register_view_type(typeof(T), regionname);
		}
		
		public abstract RegionManager register_view_type(Type view_type, string regionname);

		public virtual RegionManager register_view_type_name(string view_type, string regionname) {
			return register_view_type(Type.from_name(view_type), regionname);
		}
		
		public abstract RegionManager register_view_resolver(string regionname, Resolver<View> resolver);

		public abstract void navigate(string region_name, string source, Parameter[]? params = null, Func<NavigationResult>? callback = null);
		
	}
	
}
