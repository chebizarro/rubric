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

	public class RubricResourceCollection : Object, ResourceCollection {

		public int count { get; construct;}

		public Filter filter { get; construct; }

		public bool is_writable { get; construct; }

		public string m2m_table { get; construct; }

		public GLib.Type m2m_type { get; construct; }

		public Repository repository { get; construct; }

		public GLib.Type resource_type { get; construct; }

		public Sorting sorting { get; construct; }


		private class ItemData {
			public Resource resource;
			public Gee.HashMap<string, Value?> ht = new Gee.HashMap<string, Value?>();
		}

		private Gee.HashMap<uint, ItemData> items = new Gee.HashMap<uint, ItemData>();

		
		public bool fetch (uint index, uint count) throws Error {
			
			Parameter[] params = {
				Parameter() { name="filter", value=filter},
				Parameter() { name="sorting", value=sorting},
				Parameter() { name="limit", value=count},
				Parameter() { name="m2m-table", value=m2m_table},
				Parameter() { name="m2m-type", value=m2m_type},
				Parameter() { name="repository", value=repository},
				Parameter() { name="resource-type", value=resource_type}
			};
				
			
			var builder = repository.adapter.get_command_builder(params);
			var command = builder.build_select();
			
			Cursor cursor;
			command.execute(out cursor);
			
			var idx = index;
			
			while(cursor.next()) {
				
				var itemdata = set_props(resource_type, cursor);
				items.set(idx, itemdata);
			}
			
			return true;
		}

		public Resource? get_index (uint index) {
			if(items.has_key(index))
				return items[index].resource;
			return null;
		}

		
		private ItemData set_props(Type resource_type, Cursor cursor) {
			
			var ocl = (ObjectClass)resource_type.class_ref();
			var ncols = cursor.get_n_columns();
			
			var item = new ItemData();
			
			for(int i=0; i < ncols; i++) {
				var name = cursor.get_column_name(i);
				var prop = ocl.find_property(name);
				if(prop != null) {
					
					void* from_bytes = prop.get_qdata(RubricResource.from_bytes_func_quark());
					
					if(from_bytes != null) {
					
						Value converted = Value(resource_type);
						Value value = Value(typeof(Bytes));
						cursor.get_column(i, value);
						((ResourceFromBytesFunc)from_bytes)((Bytes)value.get_boxed(), converted);
						item.ht.set(name, converted);
					} else {
						var value = Value(resource_type);
						cursor.get_column(i, value);
						item.ht.set(name, value);
					}
				
				}
				
			}
			return item;
		}
		
	}
	
}

