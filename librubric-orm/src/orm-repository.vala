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

	public class RubricRepository : Object, Repository {

		public Adapter adapter { get; construct set; }


		public ResourceCollection find (GLib.Type resource_type, Filter? filter) throws Error {
			return find_sorted(resource_type, filter, null);
		}


		public async ResourceCollection find_async (GLib.Type resource_type, Filter filter) throws Error {

			GLib.SourceFunc cb = find_async.callback;

			var thread = new Thread<ResourceCollection>.try("rubric-orm-find-thread", () => {
				var findres = find_sorted(resource_type, filter, null);
				GLib.Idle.add((owned) cb);
				return findres;
			});

			var res = thread.join();
			yield;
			return res;

		}

	
		public Rubric.ORM.Resource find_one (GLib.Type resource_type, Filter? filter) throws Error {
			
			var collection = find(resource_type, filter);
			
			if(collection.count <= 0)
				throw new Rubric.ORM.Error.REPOSITORY_EMPTY_RESULT("No resources were found");
			
			collection.fetch(0, 1);
			
			return collection.get_index(0);
		}

		public async Rubric.ORM.Resource find_one_async (GLib.Type resource_type, Filter filter) throws Error {
			GLib.SourceFunc cb = find_one_async.callback;

			var thread = new Thread<Rubric.ORM.Resource>.try("rubric-orm-find-one-thread", () => {
				var findres = find_one(resource_type, filter);
				GLib.Idle.add((owned) cb);
				return findres;
			});

			var res = thread.join();
			yield;
			return res;
		}
		
		
		public ResourceCollection find_sorted (GLib.Type resource_type, Filter? filter, Sorting? sorting) throws Error {
			
			Parameter[] params = {
				Parameter() {name="resource-type", value=resource_type},
				Parameter() {name="filter", value=filter},
				Parameter() {name="sorting", value=sorting},
			};
			
			var builder = adapter.get_command_builder(params);
			var cmd = builder.build_count();

			Cursor cursor;
			cmd.execute(out cursor);

			if(!cursor.next())
				throw new Error.REPOSITORY_EMPTY_RESULT("No records found");

			var count = cursor.get_column_uint(0);

			//var ret = new ResourceCollection(count, filter, sorting, this, resource_type);

			return null;


		}


		public async ResourceCollection find_sorted_async (GLib.Type resource_type, Filter filter, Sorting sorting) {
			
			GLib.SourceFunc cb = find_sorted_async.callback;

			var thread = new Thread<ResourceCollection>.try("rubric-orm-find-sorted-thread", () => {
				var findres = find_sorted(resource_type, filter, sorting);
				GLib.Idle.add((owned) cb);
				return findres;
			});

			var res = thread.join();
			yield;
			return res;
			
		}
		
	}
	
}

