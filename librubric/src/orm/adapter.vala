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

	public delegate void AdapterCallback (Adapter adapter);

	public interface Adapter : Object {

		public abstract bool execute_sql (string sql) throws Error;
		public abstract async bool open_async (string uri) throws Error;
		public abstract bool open (string uri) throws Error;
		public abstract bool close () throws Error;
		public abstract async bool close_async () throws Error;
		public abstract void* get_handle();
		
		public abstract CommandBuilder get_command_builder(Parameter[] parameters);
		
	}
	
}

