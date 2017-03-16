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
 

namespace Rubric.ORM.Tests {

	private class TestAdapter : BaseAdapter {
		
		public bool flag = false;
	
		public override bool open(string dsn) throws Rubric.ORM.Error {
			return flag = true;
		}

		public override bool close() throws Rubric.ORM.Error {
			return flag = true;
		}

		public override void* get_handle() {
			return null;
		}
	}

	public class Adapter : Valadate.Framework.TestCase {

	
		public void test_new_adapter() {
			
			var adapter = new TestAdapter();
			
			assert(adapter is TestAdapter);
			
		}

		public void test_adapter_open() {

			var adapter = new TestAdapter();

			assert(adapter.open("test:///"));
		}

		public void test_adapter_open_async() {

		    MainLoop loop = new MainLoop ();
			var adapter = new TestAdapter();

			adapter.open_async.begin("test:///", (o, r) => {
				assert(adapter.open_async.end(r));
				assert(adapter.flag);
				loop.quit();
			});

			loop.run ();
			
		}



	}
	
}
