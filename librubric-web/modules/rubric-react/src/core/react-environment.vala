/*
 * Rubric -- a Vala framework for responsive applications
 * Copyright 2017 Chris Daley <bizarro@localhost.localdomain>
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

namespace RubricReact {
	
	public class Environment : Object {
		
		protected const string USER_SCRIPTS_LOADED_KEY = "_RubricReact_UserScripts_Loaded";

		protected const int LARGE_STACK_SIZE = 2 * 1024 * 1024;
		
		public Container container { get; construct set; }
		
		public string version {
			get {
				return "0";
			}
		}

		public string engine_version {
			get {
				return "0";
			}
		}
		
		public Babel babel {
			get {
				return null;
			}
		}

		public T execute<T>(string function, Value[] args) {
			return null;
		}

		public T execute_with_babel<T>(string function, Value[] args) {
			return null;
		}

		public bool has_variable(string name) {
			return false;
		}

		public Component create_component<T>(string componentName, T props, string container_id = null, bool client_only = false) {
			return null;
		}

		public string get_init_javascript(bool client_only = false) {
			return null;
		}


		public void return_engine_to_pool() { }
	
		
	}
	
}
