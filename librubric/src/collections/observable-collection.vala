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

namespace Rubric.Collections {
	
	public abstract class ObservableCollection<T> {

		public signal void added(string key, T value);

		public signal void removed(string key);

		protected Gee.HashMap<string, T> map = new Gee.HashMap<string, T>();
		
		public virtual void add(string key, T value) {
			map.set(key, value);
			added(key, value);
		}

		public virtual void remove(string key) {
			map.unset(key);
			removed(key);
		}

		public virtual bool contains(string key) {
			return map.has_key(key);
		}
		
		public virtual T get(string key) {
			return map.get(key);
		}

		public virtual void set(string key, T value) {
			add(key, value);
		}
	}
}
