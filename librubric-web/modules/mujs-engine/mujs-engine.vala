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
		
		private class Wrapper {
			public Value object;
			public Type gtype;
			
			public Wrapper(Value object) {
				this.object = object;
				gtype = object.type();
			}
		}
		
		
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
		
		public T call_function<T>(string function_name, Value?[]? args = null, Value? _this = null) throws EngineError {
			
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


		private static void new_object(State state) {
			
			Value obj;
			
			obj = state.to_userdata(1, "object");
			
			if(obj.type().is_a(typeof(Type))) {
				
			} else {
				
			}
			stderr.puts("---- Calling constructor\n");
			
			state.current_function();
			state.get_property(-1, "prototype");
			state.new_userdata("object", &obj, finalize_object);
			
		}

		private static void finalize_object(State state) {
			
		}


		private static void get_struct_field(State state) {
			stderr.puts("---- Calling field ----------\n");
			var obj = state.to_userdata(0, "object") as Wrapper;

			state.current_function();
			state.get_property(-1, "name");
			
			var fieldname = state.to_string(-1);
			
			var t = obj.gtype;
			var repo = GI.Repository.get_default();
			var info = repo.find_by_gtype(t);

			if(info == null) {
				foreach (var ns in repo.get_loaded_namespaces()) {
					for(int i = 0; i < repo.get_n_infos(ns); i++) {
						var nsinfo = repo.get_info(ns, i);
						if(t.name() == ns + nsinfo.get_name()) {
							info = (owned) nsinfo;
							break;
						}
					}
					if(info != null)
						break;
				}
			}

			if(info != null) {
				var field = ((GI.StructInfo)info).find_field(fieldname);
				if(field != null) {
					GI.Argument arg = {};
					if(field.get_field(obj.object.peek_pointer(), ref arg) ) {
						debug("Field %s = %d", fieldname, (int)arg.v_pointer);
						state.push_number((int)arg.v_pointer);
					} else {
						state.push_undefined();
					}
				}
			}
			
		}

		private static void set_struct_field(State state) {
			var obj = state.to_userdata(0, "object") as Wrapper;
			
			var value = state.to_integer(1);
			
			state.current_function();
			state.get_property(-1, "name");
			
			var fieldname = state.to_string(-1);
			
			var t = obj.gtype;
			var repo = GI.Repository.get_default();
			var info = repo.find_by_gtype(t);

			if(info == null) {
				foreach (var ns in repo.get_loaded_namespaces()) {
					for(int i = 0; i < repo.get_n_infos(ns); i++) {
						var nsinfo = repo.get_info(ns, i);
						if(t.name() == ns + nsinfo.get_name()) {
							info = (owned) nsinfo;
							break;
						}
					}
					if(info != null)
						break;
				}
			}

			if(info != null) {
				var field = ((GI.StructInfo)info).find_field(fieldname);
				if(field != null) {
					GI.Argument arg = {};
					arg.v_pointer = value.to_pointer();
					
					debug("%s", ((field.get_flags() & GI.FieldInfoFlags.WRITABLE) == 0).to_string());
					
					if(field.set_field(obj.object.peek_pointer(), arg))
						debug("%s:%s", arg.v_uint32.to_string(), field.get_type().get_tag().to_string());
					
				}
			}

			//var t = obj.gtype;
			//var info = repo.find_by_gtype(t);
			
			//stderr.printf("Setting field on %s\n", t.name());
			
		}
		
		public void embed_host_object(string name, Value value) {
			
			var repo = GI.Repository.get_default();
			var t = value.type();
			
			state.get_global("Object");
			state.get_property(-1, "prototype");
			state.new_userdata("object", new Wrapper(value), finalize_object);

			var info = repo.find_by_gtype(t);

			if(info == null) {
				foreach (var ns in repo.get_loaded_namespaces()) {
					for(int i = 0; i < repo.get_n_infos(ns); i++) {
						var nsinfo = repo.get_info(ns, i);
						if(t.name() == ns + nsinfo.get_name()) {
							info = (owned) nsinfo;
							break;
						}
					}
					if(info != null)
						break;
				}
			}

			if(info != null) {
				var infotype = info.get_type();
				switch (infotype) {
					
					case GI.InfoType.STRUCT :
						for (int i=0; i < ((GI.StructInfo)info).get_n_fields(); i++) {
							var field = ((GI.StructInfo)info).get_field(i);
						
							state.new_cfunction(get_struct_field,
								"%s.prototype.%s".printf(name, field.get_name()), 0);
							state.push_string(field.get_name());
							state.set_property(-2, "name");
							
							state.new_cfunction(set_struct_field,
								"%s.prototype.%s".printf(name, field.get_name()), 1);
							state.push_string(field.get_name());
							state.set_property(-2, "name");
							
							state.def_accessor(-3, field.get_name(), PropertyAttributeFlags.DONTENUM | PropertyAttributeFlags.DONTCONF );
						}
						break;
						
					default:
						break;
				}
			}
			state.def_global(name, PropertyAttributeFlags.DONTENUM);
		}
		
		public void embed_host_type<T>(string name) {
			
		}
		
		public void collect_garbage() {
			state.gc(0);
		}
		
	}
	
}
