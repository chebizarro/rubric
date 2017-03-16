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
	
	public class ViewCollection {

		public signal void added(View view);

		public signal void removed(View view);
		
		private ArrayList<View> _views = new ArrayList<View>();
		
		public void add(View view) {
			_views.add(view);
			added(view);
		}

		public void remove(View view) {
			_views.remove(view);
			removed(view);
		}

		public void remove_all() {
			foreach(var view in _views)
				removed(view);
			_views.clear();
		}

		public bool contains(View view) {
			return _views.contains(view);
		}
		
		public View get(int index) {
			return _views.get(index);
		}

		public void set(int index, View view) {
			set(index, view);
		}
	}
	
}
