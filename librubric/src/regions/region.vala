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
using Rubric.PM;

namespace Rubric.Regions {
	
	public interface Region : Object, Navigator {
		
		public abstract ViewCollection views {get;}

		public abstract ViewCollection active_views {get;}
		
		public abstract string name {get;set;}

		public abstract RegionManager region_manager {get;construct set;}
		
		public abstract RegionManager add_view(View view, string? name = null);
		
		public abstract View? get_view(string name);

		public abstract bool has_view(string name);

		public abstract void remove_view(View view);
		
		public abstract void remove_all_views();
		
		public abstract void activate_view(View view);
		
		public abstract void deactivate_view(View view);
		
		
	}
	
}
