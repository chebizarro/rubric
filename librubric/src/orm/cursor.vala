/*
 * Rubric -- a Vala framework for responsive applications
 * Copyright 2016 Chris Daley <bizarro@localhost.localdomain>
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

namespace Rubric.ORM {

	public abstract interface Cursor : Object {
		
		public abstract void get_column (uint column, GLib.Value value);
		public abstract bool get_column_boolean (uint column);
		public abstract double get_column_double (uint column);
		public abstract float get_column_float (uint column);
		public abstract int get_column_int (uint column);
		public abstract int64 get_column_int64 (uint column);
		public abstract unowned string get_column_name (uint column);
		public abstract unowned string get_column_string (uint column);
		public abstract uint get_column_uint (uint column);
		public abstract uint64 get_column_uint64 (uint column);
		public abstract uint get_n_columns ();
		public abstract bool next ();
		
	}
	
}

