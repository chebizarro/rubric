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
using Rubric.Collections;

namespace Rubric.Regions {
	
	public class RegionCollection {

		public signal void added(string name, Region region);

		public signal void removed(string name);
		
		private HashMap<string, Region> _regions = new HashMap<string, Region>();
		
		public void add(string regionname, Region region) {
			_regions.set(regionname, region);
			added(regionname, region);
		}

		public void remove(string regionname) {
			_regions.unset(regionname);
			removed(regionname);
		}

		public bool contains(string regionname) {
			return _regions.has_key(regionname);
		}
		
		public Region get(string name) {
			return _regions.get(name);
		}

		public void set(string name, Region region) {
			add(name, region);
		}
	}
	
}
