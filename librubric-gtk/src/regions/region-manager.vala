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
using Rubric.Regions;
using Rubric.PM;
using Rubric;

namespace RubricGtk.Regions {
	
	public class RegionManager : Object, Rubric.Regions.RegionManager {
		
		public Container container {get;construct set;}
		
		private RegionCollection _regions = new RegionCollection(); 
		
		construct {
			_regions.added.connect(region_added);
			_regions.removed.connect(region_removed);
		}
		
		public RegionManager(Container container) {
			Object(container: container);
		}
		
		private void region_added(string name, Region region) {
			try {
				var reg = container.resolve<Rubric.Regions.ViewRegistry>();
				foreach(var view in reg.get_contents(name)) {
					region.add_view(view);
				}
			} catch (GLib.Error e) {
				error(e.message);
			}
		}

		private void region_removed(string name) {

		}
		
		public RegionCollection regions {
			get {
				return _regions;
			}
		}

		public Rubric.Regions.RegionManager add_to_region(string name, Rubric.PM.View view) throws Rubric.Regions.Error {
			if (_regions.contains(name)) {
				var region = _regions.get(name);
				return region.add_view(view);
			}
			throw new Rubric.Regions.Error.NOT_FOUND("The Region %s could not be located", name);
		}
		

		public Rubric.Regions.RegionManager register_view_type(Type view_type, string name) {
			
			try {
				var reg = container.resolve<Rubric.Regions.ViewRegistry>();
				reg.register_view_type(view_type, name);
			} catch (GLib.Error e) {
				error(e.message);
			}
			return this;
		}
		
		public Rubric.Regions.RegionManager register_view_resolver(string name, Rubric.Resolver<View> resolver) {
			try {
				var reg = container.resolve<Rubric.Regions.ViewRegistry>();
				reg.register_view_resolver(name, resolver);
			} catch (GLib.Error e) {
				error(e.message);
			}
			return this;
		}

		public void navigate(string region_name, string source, Parameter[]? params = null, Func<NavigationResult>? callback = null) {
			if(!regions.contains(region_name)) {
				return;
			}
			var reg = regions[region_name];
			reg.navigate(source, params, callback);
			
		}
	}
	
}
