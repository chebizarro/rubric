/* 
 * Rubric -- a Vala framework for responsive applications
 * Copyright (C) 2016 Chris Daley
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
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

using Gee;

namespace Rubric {

	public errordomain ContainerError {
		REGISTERED,
		UNREGISTERED,
		UNSUPPORTED_TYPE,
		TYPE_MISMATCH,
		PARAMETER,
		DOES_NOT_EXIST
	}
	
	private ParamSpec get_paramspec_type(Parameter param) {

		if(param.value.type().is_a(typeof(string)))
			return new ParamSpecString(param.name,param.name,param.name, param.value.get_string(), ParamFlags.CONSTRUCT | ParamFlags.WRITABLE);
		else if(param.value.type().is_a(typeof(bool)))
			return new ParamSpecBoolean(param.name,param.name,param.name, param.value.get_boolean(), ParamFlags.CONSTRUCT | ParamFlags.WRITABLE);
		else if(param.value.type().is_a(typeof(double)))
			return new ParamSpecDouble(param.name,param.name,param.name, double.MIN, double.MAX, double.MIN, ParamFlags.CONSTRUCT | ParamFlags.WRITABLE);
		else if(param.value.type().is_a(typeof(int)))
			return new ParamSpecInt(param.name,param.name,param.name, int.MIN, int.MAX, param.value.get_int(), ParamFlags.CONSTRUCT | ParamFlags.WRITABLE);
		else
			return new ParamSpecBoxed(param.name,param.name,param.name, param.value.type(), ParamFlags.CONSTRUCT | ParamFlags.WRITABLE);

	}
	
	public delegate Value Constructor<T>(Parameter[]? params = null);
	
	public class Container : GLib.Object {

		private bool autoresolve;

		private HashTable<Type, Policy> policies =
			new HashTable<Type, Policy>(direct_hash, direct_equal);

		private GLib.List<ContainerExtension> extensions = new GLib.List<ContainerExtension>();

		private class Policy : GLib.Object {

			private weak Container container;
			public Strategy default_strategy;
			public HashTable<string, Strategy> strategies = 
				new HashTable<string, Strategy>(str_hash, str_equal);
			public Value? default_instance = null;
			public HashTable<string, Value?> instances = 
				new HashTable<string, Value?>(str_hash, str_equal);

			public Policy(Container container) {
				this.container = container;
			}

			public Value resolve(
				string? name = null,
				Parameter[]? params = null)
				throws ContainerError {
					
				if(name != null) {
					if(instances.contains(name))
						return instances.get(name);
					if(strategies.contains(name)) {
						var strat = strategies.get(name);
						return container.decorate(strat.to_type, strat.resolve(params), name);
					}
				}
				return (default_instance != null) ? default_instance :
					container.decorate(default_strategy.to_type, default_strategy.resolve(params));
			}

			public Value resolve_all(Parameter[]? params = null) throws ContainerError {
				
				var objarray = new Array<GLib.Object>();
				var valarray = new Array<GLib.Value?>();
				strategies.foreach((k,v) => {
					var val = v.resolve(params);
					val = container.decorate(v.to_type, val, k);
					if (val.type().is_a(typeof(GLib.Object)))
						objarray.append_val(val.get_object());
					else
						valarray.append_val(val);
				});
				instances.foreach((k,v) => {
					if (v.type().is_a(typeof(GLib.Object)))
						objarray.append_val(v.get_object());
					else
						valarray.append_val(v);
				});
				return (objarray.length > 0) ? objarray : valarray;
			}
			
			public ParamSpec[] get_paramspec(string? name) {

				if(name != null) {
					if(strategies.contains(name))
						return strategies.get(name).get_paramspec();
				}
				return default_strategy.get_paramspec();

				
			}
		}

		private class Strategy : GLib.Object {
			public weak Container container;
			public Type to_type;
			public Parameter[]? parameters;
			public Constructor? constructor;
			
			private ParamSpec[] properties;
			
			public Strategy (
				Container container,
				Type to_type,
				Parameter[]? parameters,
				owned Constructor? constructor)
				throws ContainerError {
					
				this.container = container;
				this.to_type = to_type;
				this.parameters = parameters;
				this.constructor = (owned)constructor;

				if (to_type.is_object()) {
					var ocl = (ObjectClass)to_type.class_ref();
					this.properties = ocl.list_properties();
				} else {
					this.properties = {};
					foreach (var param in parameters) {
						var pspec = get_paramspec_type(param);
						pspec.owner_type = to_type;
						this.properties += pspec;
					}
				}
				check_parameters(parameters);
			}
			
			public ParamSpec[] get_paramspec() {
				return this.properties;
			}
			
			private Parameter[]? merge_params(Parameter[]? other = null) {
				Parameter[] params = other ?? new Parameter[]{}; 
				if (parameters != null) {
					foreach(var oldparam in parameters) {
						bool isset = false;
						foreach(var param in params)
							if(param.name == oldparam.name)
								isset = true; 
						if(!isset)
							params += oldparam;
					}
				}
				return params;
			}
			
			private ParamSpec? find_property(string property_name) {
				foreach(var pspec in this.properties)
					if(pspec.name == property_name)
						return pspec;
				return null;
			} 
			
			private void check_parameters(Parameter[]? params) throws ContainerError {
				if (params == null) // || !to_type.is_classed() || to_type.is_fundamental())
					return;
					
				foreach(var param in parameters) {
					var pspec = find_property(param.name);
					if(pspec == null)
						throw new ContainerError.PARAMETER(
							"%s has no property named %s", to_type.name(), param.name);
					
					if (!Value.type_compatible(param.value.type(), pspec.value_type) ||
						!Value.type_transformable(param.value.type(), pspec.value_type))
						throw new ContainerError.PARAMETER(
							"The supplied value for %s is not compatible", param.name);

					if(((pspec.flags & ParamFlags.CONSTRUCT) == ParamFlags.CONSTRUCT) ||
						((pspec.flags & ParamFlags.CONSTRUCT_ONLY) == ParamFlags.CONSTRUCT_ONLY) ||
						((pspec.flags & ParamFlags.WRITABLE) == ParamFlags.WRITABLE))
						continue;
						
					throw new ContainerError.PARAMETER(
						"The property named %s of %s cannot be set", param.name, to_type.name());
				}
			}
			
			private Parameter[]? inject_parameters(Parameter[]? params) throws ContainerError {
				Parameter[] newparams = {};	
				if (params != null)
					foreach(var param in params)
						newparams += param;

				foreach(var pspec in this.properties) {

					if(((pspec.flags & ParamFlags.CONSTRUCT) != ParamFlags.CONSTRUCT) &&
						((pspec.flags & ParamFlags.CONSTRUCT_ONLY) != ParamFlags.CONSTRUCT_ONLY))
						continue;

					bool found = false;
					foreach(var param in newparams) {
						if (pspec.get_name() == param.name) {
							found = true;
							break;
						}
					}
					if (!found && !pspec.value_type.is_fundamental()) {
						try {
							var injected = container.resolve_type(pspec.value_type);
							var val = Value(pspec.value_type);
							if(pspec.value_type.is_object() || pspec.value_type.is_interface()) {
								val.set_object(injected.get_object());
							} else {
								debug(pspec.value_type.name());
								val.set_boxed((void*)injected);
							}
							Parameter newparam = { name: pspec.get_name(), value : val };
							newparams += newparam;
						} catch (ContainerError e) {
							//if((e is ContainerError.UNREGISTERED) == false)
								//throw e;
						}
					}
				}
				return newparams;
			}
			
			public Value resolve(Parameter[]? params = null) throws ContainerError {
				check_parameters(params);
				var newparams = merge_params(params);
				newparams = inject_parameters(newparams);
				if(constructor != null) {
					return constructor(newparams);
				} else {
					if (to_type.is_object()) {
						return GLib.Object.newv(to_type, newparams);
					} else {
						var val = Value(to_type);
						return val;
					}
				}
			}
		}

		public Container(bool autoresolve = true) {
			this.autoresolve = autoresolve;
			register_instance<Container>(this);
		}
		
		public void add_extension(ContainerExtension extension) {
			if(extensions.find(extension) == null)
				extensions.append(extension);
		}

		public Container register_resource(string path, Assembly assembly) throws ContainerError {
			foreach(var ext in extensions) {
				var res = ext as ResourceHandler;
				if (res != null)
					if(res.handles(path))
						res.add(path, assembly);
			}
			return this;
		}
		
		public Value decorate(Type from, Value object, string? name = null) throws ContainerError {
			foreach(var ext in extensions) {
				var dec = ext as DecoratorExtension;
				if (dec != null)
					object = dec.decorate(from, object, name);
			}
			return object;
		}

		public Value decorate_all(Type from, Value objects) throws ContainerError {
			foreach(var ext in extensions) {
				var dec = ext as DecoratorExtension;
				if (dec != null)
					objects = dec.decorate_all(from, objects);
			}
			return objects;
		}
		
		/**
		 * register_type
		 * 
		 * a type mapping with the container
		 *
		 * @param from {@link GLib.Type} that will be requested.
		 * @param to {@link GLib.Type} that will actually be returned.
		 * @param name Name to use for registration, null if a default registration.
		 * @param params params to pass to constructor
		 * @param constructor method that returns an instance
		 * @return The {@link Container} Object that this method was called on.
		 */
		public Container register_type(
			Type from,
			Type to = from,
			string? name = null,
			Parameter[]? params = null,
			owned Constructor? constructor = null)
			throws ContainerError {

			/*
			 * signatures:
			 * is_object() - only GLib.Object derived types
			 * is_interface() - interfaces - cannot be to type
			 * is_abstract() - cannot be to type
			 * is_classed() && is_fundamental() - simple types
			 */
			if(constructor == null && !to.is_object())
				throw new ContainerError.UNSUPPORTED_TYPE("You must provide a constructor for type %s", to.name());

			if (!to.is_a(from))
				throw new ContainerError.TYPE_MISMATCH("%s is not a %s", to.name(), from.name());

			var strategy = new Strategy(this, to, params, (owned)constructor);

			var policy = (policies.contains(from)) ? policies.get(from) : new Policy(this);
						
			if (name != null) {
				if(policy.strategies.contains(name))
					throw new ContainerError.REGISTERED(
						"a strategy for %s is already registered under %s", from.name(), name);
				policy.strategies.set(name, strategy);
			} else {
				if(policy.default_strategy != null)
					throw new ContainerError.REGISTERED(
						"a default strategy for %s is already registered", from.name());
				policy.default_strategy = strategy;
			}
					
			if (!policies.contains(from))
				policies.set(from, policy);

			return this;
		}

		public Container register<T,F>(
			string? name = null,
			Parameter[]? params = null,
			owned Constructor? constructor = null)
			throws ContainerError {

			return register_type(typeof(T), typeof(F), name, params, constructor);
		}

		/**
		 * register_instance
		 * 
		 * register an instance with the container.
		 *
		 * Instance registration is much like setting a type as a singleton, except that instead
		 * of the container creating the instance the first time it is requested, the user
		 * creates the instance ahead of type and adds that instance to the container.
		 * 
		 * @param t Type of instance to register (may be an implemented interface instead of the full type).
		 * @param instance Object to returned.
		 * @param name Name for registration.
		 * @return The {@link Container} Object that this method was called on.
		 */
		public Container register_type_instance(
			Type from,
			Value instance,
			string? name = null)
			throws ContainerError {

			//if (!from.is_object() && !from.is_interface())
				//throw new ContainerError.UNSUPPORTED_TYPE("%s is not a GObject derived type", from.name());

			if (instance.type() == typeof(GLib.Object) && !(((GLib.Object)instance).get_type().is_a(from)))
				throw new ContainerError.TYPE_MISMATCH("%s is not a %s", instance.type().name(), from.name());

			var policy = (policies.contains(from)) ? policies.get(from) : new Policy(this);

			if(name != null) {
				if(policy.instances.contains(name))
					throw new ContainerError.REGISTERED(
						"an instance for %s is already registered", from.name());
				policy.instances.set(name, instance); 
			} else {
				if(policy.default_instance != null)
					throw new ContainerError.REGISTERED("a default instance for %s is already registered", from.name()); 
				policy.default_instance = instance;
			}
			
			if (!policies.contains(from))
				policies.set(from, policy);
			
			return this;
		}

		public Container register_instance<T>(T instance, string? name = null) throws ContainerError {
			var val = Value(typeof(T));
			val.set_instance(instance);
			return register_type_instance(typeof(T), val, name);
		}

		/**
		 * resolve
		 * 
		 * Get an instance of the requested type with the given name from the container.
		 *
		 * @param t {@link GLib.Type} of Object to get from the container.
		 * @param name Name of the Object to retrieve. If not set, it resolves to the default 
		 * @param parameters to pass
		 * @return The retrieved object.
		 */
		public Value resolve_type(
			Type from,
			string? name = null,
			Parameter[]? params = null)
			throws ContainerError {

			if (!policies.contains(from)) {
				if(autoresolve) {
					if(from.is_object())
						return GLib.Object.newv(from, params);
					return Value(from);
				}
				throw new ContainerError.UNREGISTERED(
					"There is no registered policy for %s", from.name());
			}
			return policies.get(from).resolve(name, params);
		}

		public T resolve<T>(
			string? name = null,
			Parameter[]? params = null)
			throws ContainerError {
			return resolve_type(typeof(T), name, params).peek_pointer();
		}

		public Object resolvep(string tname, string? name = null) throws ContainerError {
			return resolve_type_name(tname, name).get_object();
		}

		public Value resolve_type_name(string tname, string? name = null, Parameter[]? params = null)
			throws ContainerError {
			return resolve_type(Type.from_name(tname), name, params);
		}


		/**
		 * resolve_all
		 * Return instances of all registered types requested.
		 *
		 * This method is useful if you've registered multiple types with the same
		 * {@link GLib.Type} but different names.
		 * 
		 * Be aware that this method does NOT return an instance for the default (unnamed) registration.
		 * 
		 * @param t The type requested.
		 * @param params Any parameter overrides for the resolve calls.
		 * @return Array of objects of type //t//.
		 */
		public Value resolve_type_all(Type from, Parameter[]? params = null) throws ContainerError {
			if (!policies.contains(from)) {
				if(autoresolve) {
					var array = new Array<Value?>();
					array.append_val(GLib.Object.newv(from, params));
					return array;
				}
				throw new ContainerError.UNREGISTERED(
					"There is no registered policy for %s", from.name());

			}
			return policies.get(from).resolve_all(params);
		}

		public Array<T> resolve_all<T>(Parameter[]? params = null) throws ContainerError {
			return resolve_type_all(typeof(T), params) as Array<T>;
		}

		public ParamSpec[] get_paramspec_for_type(Type type, string? name = null) throws ContainerError  {
			if (!policies.contains(type))
				throw new ContainerError.UNREGISTERED("There is no registered policy for %s", type.name());

			return policies.get(type).get_paramspec(name);
		}
		
		public ParamSpec[] get_paramspec<T>(string? name = null) throws ContainerError {
			return get_paramspec_for_type(typeof(T), name);
		}
	}
}
