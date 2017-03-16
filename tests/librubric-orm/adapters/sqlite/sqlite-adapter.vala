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
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */
 
using Rubric.ORM.Adapters;

namespace Rubric.ORM.Tests.Adapters {

	public class SqliteAdapterTestCase : Valadate.Framework.TestCase {
		
		private const string db = "chinook.db";
		private const string dir = Path.DIR_SEPARATOR_S;
		private string dsnstring = "%s%slibrubric-orm%sdata%s%s".printf(
			Config.TESTS_DIR, dir, dir, dir, db);
	
		public void test_new_sqlite_adapter() {
			
			var adapter = new SqliteAdapter();
			
			assert(adapter is SqliteAdapter);
			
		}

		public void test_adapter_open() {

			var adapter = new SqliteAdapter();

			assert(adapter.open(dsnstring));
		}

		public void test_adapter_open_async() {

		    MainLoop loop = new MainLoop ();
			var adapter = new SqliteAdapter();

			adapter.open_async.begin(dsnstring, (o, r) => {
				assert(adapter.open_async.end(r));
				loop.quit();
			});

			loop.run ();
			
		}



	}
	
}
