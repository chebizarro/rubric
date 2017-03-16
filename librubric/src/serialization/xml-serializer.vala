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

namespace Rubric.Serialization.XmlSerializer {
	
	public errordomain Error {
		PROPERTY
	}
	
	public delegate Value DeserializeMethod(Xml.Node* node);

	private static HashTable<Type, MethodAdapter> deserialize_methods;

	private class MethodAdapter {
		
		public DeserializeMethod deserialize;
		
		public MethodAdapter(owned DeserializeMethod deserialize) {
			this.deserialize = (owned)deserialize;
		}
	}
	
	public static void register_deserialize_method(Type type, owned DeserializeMethod method) {
		if(deserialize_methods == null)
			deserialize_methods = new HashTable<Type, MethodAdapter>(direct_hash, direct_equal);
		
		deserialize_methods.set(type, new MethodAdapter((owned)method));
	}
	
	public static Value deserialize(Type type, Xml.Node* node, Container? container = null) throws Error {
		var ocl = (ObjectClass)type.class_ref();
		var cntx = new Xml.XPath.Context (node->doc);
		var basepath = node->get_path();

		Parameter[] params = {};

		foreach(var pspec in ocl.list_properties()) {

			Xml.XPath.Object* res = cntx.eval_expression ("%s/%s".printf(basepath, pspec.name));

			if( res != null &&
				res->type == Xml.XPath.ObjectType.NODESET &&
				res->nodesetval != null &&
				res->nodesetval->length() > 0) {

				if (res->nodesetval->length() > 1)
					throw new Error.PROPERTY("Multipe elements founds for property: %s", pspec.name);
				
				var objnode = res->nodesetval->item(0);
				Value setval;
				
				if (deserialize_methods != null && deserialize_methods.contains(pspec.value_type)) {
					setval = deserialize_methods.get(pspec.value_type).deserialize(objnode);
				} else if(pspec.value_type == typeof(string)) {
					setval = parse_string(objnode);
				} else if(pspec.value_type == typeof(string[])) {
					setval = parse_string_array(objnode);
				} else if(pspec.value_type == typeof(Array)) {
					setval = parse_garray(objnode, container);
				} else if(pspec.value_type == typeof(List)) {
					setval = parse_glist(objnode, container);
				} else if(pspec.value_type == typeof(bool)) {
					setval = parse_bool(objnode);
				} else if(pspec.value_type == typeof(int)) {
					setval = parse_int(objnode);
				} else if(pspec.value_type == typeof(int64)) {
					setval = parse_int64(objnode);
				} else if(pspec.value_type == typeof(double)) {
					setval = parse_double(objnode);
				} else if(pspec.value_type == typeof(uint)) {
					setval = parse_uint(objnode);
				} else if(pspec.value_type.is_a(typeof(GLib.Object))) {
					setval = deserialize(pspec.value_type, objnode, container);
				} else {
					delete res;
					continue;
				}
				params += Parameter() { name=pspec.name, value=setval };
				delete res;
			}
		}
		var named_type = node->get_prop("named-type");
		if (container == null) {
			if (type.is_object())
				return GLib.Object.newv(type, params);
			return Value(type);
		}
		try {
			return container.resolve_type(type, named_type, params);
		} catch (ContainerError e) {
			warning (e.message);
			return Value(type);
		}
	}
	
	private static Value parse_string(Xml.Node* node) {
		var val = node->get_content();
		return (val != null) ? val.strip() : val;
	}
	
	private static Value parse_string_array(Xml.Node* node) {
		var child = node->children;
		string[] values = {};
		while(child != null) {
			if(child->type != Xml.ElementType.TEXT_NODE)
				values += child->get_content().strip();
			child = child->next;
		}
		return values;
	}
	
	private static Value parse_bool(Xml.Node* node) {
		var val = node->get_content();
		return (val != null) ? bool.parse(val.strip()) : Value(typeof(bool));
	}

	private static Value parse_int(Xml.Node* node) {
		var val = node->get_content();
		return (val != null) ? int.parse(val.strip()) : Value(typeof(int));
	}

	private static Value parse_double(Xml.Node* node) {
		var val = node->get_content();
		return (val != null) ? double.parse(val.strip()) : Value(typeof(double));
	}

	private static Value parse_uint(Xml.Node* node) {
		var val = node->get_content();
		return (val != null) ? int.parse(val.strip()) : Value(typeof(uint));
	}

	private static Value parse_int64(Xml.Node* node) {
		var val = node->get_content();
		return (val != null) ? int64.parse(val.strip()) : Value(typeof(int64));
	}

	private static Value parse_garray(Xml.Node* node, Container? container = null) {
		var arraytype = node->get_prop("element-type");

		if(arraytype == null)
			return Value(Type.INVALID);
		
		var atype = Type.from_name(arraytype);
		
		Array<GLib.Object> objarray = null;
		Array<Value?> valarray = null;
		
		if (atype.is_object())
			objarray = new Array<GLib.Object>();
		else
			valarray = new Array<Value?>();

		var child = node->children;

		while(child != null) {
			if(child->type != Xml.ElementType.TEXT_NODE) {
				var childtype = child->get_prop("named-type");
				try {
					if(childtype != null && container != null) {
						var pspec = container.get_paramspec_for_type(atype, childtype);
						if(pspec != null && pspec.length > 0)
							atype = pspec[0].owner_type;
					}
					var newobj = deserialize(atype, child, container);
					if (newobj.get_object() is GLib.Object)
						objarray.append_val(newobj as GLib.Object);
					else
						valarray.append_val(newobj);
					
				} catch (Error e) {
					warning(e.message);
				}
			}
			child = child->next;
		}
		if (atype.is_object())
			return objarray;
		else
			return valarray;
	}

	private static Value parse_glist(Xml.Node* node, Container? container = null) {
		var arraytype = node->get_prop("element-type");

		if(arraytype == null)
			return Value(Type.INVALID);
		
		var atype = Type.from_name(arraytype);
		
		List<GLib.Object> objlist = null;
		List<Value?> vallist = null;
		
		if (atype.is_object())
			objlist = new List<GLib.Object>();
		else
			vallist = new List<Value?>();

		var child = node->children;

		while(child != null) {
			if(child->type != Xml.ElementType.TEXT_NODE) {
				var childtype = child->get_prop("named-type");
				try {
					if(childtype != null && container != null) {
						var pspec = container.get_paramspec_for_type(atype, childtype);
						if(pspec != null && pspec.length > 0)
							atype = pspec[pspec.length-1].owner_type;
					}
					var newobj = deserialize(atype, child, container);
					if (newobj.get_object() is GLib.Object)
						objlist.append(newobj.get_object());
					else
						vallist.append(newobj);
				} catch (Error e) {
					warning(e.message);
				}
			}
			child = child->next;
		}
		if (atype.is_object())
			return objlist;
		else
			return vallist;
	}
	
}
