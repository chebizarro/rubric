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

using Mujs;

namespace RubricWeb.Mujs {
	
	public class Engine : Object, RubricWeb.JSEngine {
		
		private const string _name = "MuJSEngine"; 

		private const string _version = "1.0"; 
		
		public string name { get { return _name; } }
		
		public string version { get { return _version; } }
		
		public bool supports_gc { get { return true; } }
		
		private State state  = new State();
		
		public T? evaluate<T>(string expression, string? doc_name = null) throws RubricWeb.EngineError {

			if (state.pload_string("[string]", expression) > 0) {
				var err = state.to_string(-1);
				state.pop(1);
				throw new RubricWeb.EngineError.EVAL(err);
			}
			state.push_global();
			if (state.p_call(0)) {
				var err = state.to_string(-1);
				state.pop(1);
				throw new RubricWeb.EngineError.EVAL(err);
			}
			if (state.is_defined(-1)) {
				if(typeof(T).is_a(typeof(bool)) && state.is_boolean(-1)) {
					T res = state.to_boolean(-1);
					state.pop(1);
					return res;
				}
				if(typeof(T).is_a(typeof(int)) && state.is_number(-1)) {
					T res = (int)state.to_number(-1);
					state.pop(1);
					return res;
				}
				if(typeof(T).is_a(typeof(double)) && state.is_number(-1)) {
					var res = state.to_number(-1);
					state.pop(1);
					return &res;
				}
				if(typeof(T).is_a(typeof(string)) && state.is_string(-1)) {
					T res = state.to_string(-1);
					state.pop(1);
					return res;
				}
			}
			state.pop(1);
			return null;
		}
		
		public void execute(string code,  string? doc_name = null) throws RubricWeb.EngineError {
			if (state.do_string(code)) {
				var err = state.to_string(-1);
				throw new RubricWeb.EngineError.EXEC(err);
			}
		}

		public void execute_file(string path, string? encoding = null) throws RubricWeb.EngineError {
			if (state.do_file(path)) {
				var err = state.to_string(-1);
				throw new RubricWeb.EngineError.EXEC(err);
			}
		}

		
		public void execute_resource(string resource_name) throws RubricWeb.EngineError {
			try {
				var resource = resources_lookup_data(resource_name, 0);
				var data = resource.get_data();
				execute((string)data);
			} catch (Error e) {
				throw new RubricWeb.EngineError.RESOURCE(e.message);
			} catch (RubricWeb.EngineError ee) {
				throw ee;
			}
		}
		
		public T call_function<T>(string function_name, Value?[]? args = null, Value? _this = null) {
			
			state.get_global(function_name);

			Value? este = null;
			int nargs = 0;

			if(_this == null) {
				state.push_null();
			} else {
				state.push_undefined();
			}
			
			if(args != null && args.length > 0) {
				nargs = args.length;
				for(int i = 0; i < nargs; i++) {
					if (args[i] == null)
						state.push_null();
					else if (args[i].type().is_a(typeof(int)))
						state.push_number((double)args[i].get_int());
					else if (args[i].type().is_a(typeof(double)))
						state.push_number(args[i].get_double());
					else if(args[i].type().is_a(typeof(string)))
						state.push_string(args[i].get_string());
					else if(args[i].type().is_a(typeof(bool)))
						state.push_boolean(args[i].get_boolean());
					else if(args[i].type().is_a(typeof(RubricWeb.Undefined)))
						state.push_undefined();
					else
						state.push_undefined();
				}
			}

			if(state.p_call(nargs)) {
				var err = state.to_string(-1);
				state.pop(1);
				throw new RubricWeb.EngineError.EXEC(err);
			}

			if (state.is_defined(-1)) {
				if(typeof(T).is_a(typeof(bool)) && state.is_boolean(-1)) {
					T res = state.to_boolean(-1);
					state.pop(1);
					return res;
				}
				if(typeof(T).is_a(typeof(int)) && state.is_number(-1)) {
					T res = (int)state.to_number(-1);
					state.pop(1);
					return res;
				}
				if(typeof(T).is_a(typeof(double)) && state.is_number(-1)) {
					var res = state.to_number(-1);
					state.pop(1);
					return &res;
				}
				if(typeof(T).is_a(typeof(string)) && state.is_string(-1)) {
					T res = state.to_string(-1);
					state.pop(1);
					return res;
				}
				if(typeof(T).is_a(typeof(RubricWeb.Undefined))) {
					state.pop(1);
					return RubricWeb.Undefined.value();
				}
				if(state.is_null(-1))
					return null;
			}
			state.pop(1);
			return RubricWeb.Undefined.value();

		}
		
		public bool has_variable(string name) {
			state.get_global(name);
			if(state.is_undefined(-1)) {
				state.pop(1);
				return false;
			}
			state.pop(1);
			return true;
		}
		
		public T get_variable<T>(string name) {
			state.get_global(name);
			
			if (state.is_defined(-1)) {
				if(typeof(T).is_a(typeof(bool)) && state.is_boolean(-1)) {
					T res = state.to_boolean(-1);
					state.pop(1);
					return res;
				}
				if(typeof(T).is_a(typeof(int)) && state.is_number(-1)) {
					T res = (int)state.to_number(-1);
					state.pop(1);
					return res;
				}
				if(typeof(T).is_a(typeof(double)) && state.is_number(-1)) {
					var res = state.to_number(-1);
					state.pop(1);
					return &res;
				}
				if(typeof(T).is_a(typeof(string)) && state.is_string(-1)) {
					T res = state.to_string(-1);
					state.pop(1);
					return res;
				}
				if(typeof(T).is_a(typeof(RubricWeb.Undefined))) {
					state.pop(1);
					return RubricWeb.Undefined.value();
				}
				if(state.is_null(-1))
					return null;
			}
			state.pop(1);
			return RubricWeb.Undefined.value();
		}
		
		public void set_variable(string name, Value? value) {
			if(value == null)
				state.push_null();
			else if(value.type().is_a(typeof(string)))
				state.push_string(value.get_string());
			else if(value.type().is_a(typeof(bool)))
				state.push_boolean(value.get_boolean());
			else if(value.type().is_a(typeof(int)))
				state.push_number((double)value.get_int());
			else if(value.type().is_a(typeof(double)))
				state.push_number(value.get_double());
			else if(value.type().is_a(typeof(RubricWeb.Undefined)))
				state.push_undefined();
			state.def_global(name, 0);
			state.push_global();
		}
		
		public void remove_variable(string name) {
			state.del_property(-1, name);
		}
		
		public void embed_host_object(string name, Object value) {
			
		}
		
		public void embed_host_type(string name, Type type) {
			
		}
		
		public void collect_garbage() {
			state.gc(0);
		}
		
	}
	
}
