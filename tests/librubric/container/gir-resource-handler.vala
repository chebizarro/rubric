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
 
using Rubric;

namespace Rubric.Tests {

	public class TestClass : Object {
		
	}

	public class SecondTestClass : Object, TestIface {

		public string name {get;set;}
		
	}

	public interface TestIface : Object {
		
		public abstract string name {get;set;}
		
	}

	public class GIRHandler : Valadate.Framework.TestCase {


		private Container container;

		public override void set_up () {
			container = new Container(false);
		}

		public void test_register_no_name() {
			var handler = new GirResourceHandler(container);
			
			handler.add("/org/rubric/test/gir-handler-1.0.gir");
			
			var tclass = container.resolve<TestClass>();
			
			assert(tclass is TestClass);
		}

		public void test_register_named() {

			var handler = new GirResourceHandler(container);
			
			handler.add("/org/rubric/test/gir-handler-1.0.gir");
			
			var tclass = container.resolve<SecondTestClass>("secondtestclass");
			var tclass2 = container.resolve<TestIface>("secondtestclass");
			
			assert(tclass is SecondTestClass);
			assert(tclass2 is TestIface);
		}

	}
	
}
