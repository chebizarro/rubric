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

namespace RubricWeb {
	
	public errordomain EngineError {
		EVAL,
		EXEC,
		RESOURCE,
		FUNCTION
	}
	
	public class Undefined {
		
		private static Undefined _value;
		
		public static Undefined value() {
			if(_value == null)
				_value = new Undefined();
			return _value;
		}
		
		private Undefined() {}
		
		public string to_string() {
			return "undefined";
		}
	}
	
	public interface JSEngine : Object {
		
		public abstract string name {get;}
		
		public abstract string version {get;}
		
		public abstract bool supports_gc {get;}
		
		public abstract T? evaluate<T>(string expression, string? doc_name = null) throws EngineError;
		
		public abstract void execute(string code,  string? doc_name = null) throws EngineError;

		public abstract void execute_file(string path, string? encoding = null) throws EngineError;
		
		public abstract void execute_resource(string resource_name) throws EngineError;
		
		public abstract T call_function<T>(string function_name, Value?[]? args = null, Value? _this = null) throws EngineError;
		
		public abstract bool has_variable(string name);
		
		public abstract T get_variable<T>(string name);
		
		public abstract void set_variable(string name, Value? value);
		
		public abstract void remove_variable(string name);
		
		public abstract void embed_host_object(string name, Value value);
		
		public abstract void embed_host_type<T>(string name);
		
		public abstract void collect_garbage(); 
		
	}
	
}
