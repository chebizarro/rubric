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
using Rubric.Collections;

namespace Rubric.Regions {
	
	public interface ViewRegistry : Object {

		public abstract HashTable<string, List<string>> views {get;set;}

		public abstract Iterator<View> get_contents(string region_name);

		public virtual void register_view<T>(string region_name) {
			register_view_type(typeof(T), region_name);
		}

		public abstract void register_view_type(Type view_type, string region_name);

		public abstract void register_view_resolver(string region_name, Resolver<View> resolver);

	}
	
}
