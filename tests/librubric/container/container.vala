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

	public class RubricContainer : Valadate.Framework.TestCase {

		private Container container;

		public override void set_up () {
			container = new Container(false);
		}

		public void test_register_type () {

			container.register<GLib.Object,TestObject>();
		}

		public void test_resolve () {
			Parameter param = { name : "prop_one", value : "testvalue"};
			
			container.register<GLib.Object,TestObject>();
			
			var testobj = container.resolve<GLib.Object>(null, { param }) as TestObject;
			
			assert(testobj is TestObject);
			assert(testobj.prop_one == "testvalue");
			
		}

		public void test_resolve_unregistered () {
			try {
				var settings = container.resolve<TestObject>();
				assert_not_reached();
			} catch (ContainerError e) {
				assert(e.code == 1);
				assert(e.message == "There is no registered policy for RubricTestsTestObject");
			}
		}
		
		
		public void test_register_constructor() {
			
			container.register<GLib.Object,TestObject>(null, null, (p) => { 
					return new TestObject();
				});
			
		}


		public void test_resolve_with_registered_constructor () {

			container.register<GLib.Object,TestObject>(null, null, (p) => { 
					return new TestObject();
				});

			
			var result = container.resolve<GLib.Object>() as TestObject;
			
			assert(result is TestObject);
			
		}

		public void test_register_type_with_name () {
			
			Parameter param = { name : "prop-one", value : "org.rubric.tests"};
			
			container.register<TestObject,TestObject>("testobject", {param});
			
		}

		public void test_resolve_name () {
			Parameter param = { name : "prop-one", value : "org.rubric.tests"};
			
			container.register<TestObject,TestObject>("testobject", {param});
			
			var settings = container.resolve<TestObject>("testobject");
			
			assert(settings is TestObject);
			assert(settings.prop_one == "org.rubric.tests");
			
		}

		public void test_inject_params () {
			Parameter param = { name : "schema-id", value : "org.rubric.tests"};
			
			container.register<Settings,Settings>(null, {param});

			container.register<TestObject, TestObject>();
			
			var testobj = container.resolve<TestObject>();
			
			assert(testobj.settings != null);
			assert(testobj.settings.schema_id == "org.rubric.tests");
			
		}

		public void test_set_non_construct_property () {
			Parameter param = { name : "prop-two", value : 42 };

			container.register<TestObject, TestObject>();

			var testobj = container.resolve<TestObject>(null, {param});
			
			assert(testobj.prop_two == 42);
			
		}

		public void test_struct_register () {
			try {
				container.register<TestStruct, TestStruct>();
				assert_not_reached();
			} catch (ContainerError e) {
				assert(e.message == "You must provide a constructor for type RubricTestsTestStruct");
			}
		}

		public void test_struct_register_with_constructor () {

			container.register<TestStruct?, TestStruct?>(null, null, (p) => {
					TestStruct? ptr = TestStruct();
					ptr.prop_one ="Test";
					ptr.prop_two=10;
					return ptr;
				});
		}

		public void test_struct_resolve () {
			
			container.register<TestStruct, TestStruct?>(null, null, (p) => {
					TestStruct? ptr = TestStruct();
					ptr.prop_one ="Test";
					ptr.prop_two=10;
					return ptr;
				});

			var teststruct = container.resolve<TestStruct?>();
			
			assert(teststruct != null);
			assert(teststruct.prop_one == "Test");
			assert(teststruct.prop_two == 10);
		}
		
		public void test_simpleclass_register() {
			try {
				container.register<SimpleClass,SimpleClass>();
				assert_not_reached();
			} catch (ContainerError e) {
				assert(e.message == "You must provide a constructor for type RubricTestsSimpleClass");
			}
		}

		public void test_simpleclass_register_with_constructor() {
			container.register<SimpleClass,SimpleClass>(null, null, (p) => {
					return new SimpleClass();
				});
		}

		public void test_simpleclass_resolve() {
			container.register<SimpleClass,SimpleClass>(null, null, (p) => {
					SimpleClass sc = new SimpleClass();
					sc.prop_one = "Test";
					return sc;
				});
				
			var testclass = container.resolve<SimpleClass>();
			
			assert(testclass is SimpleClass);
			assert(testclass.prop_one == "Test");
		}

		public void test_compactclass_register() {
			try {
				container.register<unowned CompactClass,unowned CompactClass>();
				assert_not_reached();
			} catch (ContainerError e) {
				message(e.message);
				assert(e.message == "You must provide a constructor for type gpointer");
			}
		}

		public void test_compactclass_register_with_constructor() {
			container.register<unowned CompactClass, unowned CompactClass>(null, null, (p) => {
					return new CompactClass();
				});
		}

		public void test_compactclass_resolve() {
			container.register<unowned CompactClass, unowned CompactClass>(null, null, (p) => {
					var sc = new CompactClass();
					sc.prop_one = "Test";
					return sc;
				});
				
			unowned CompactClass testclass = container.resolve<unowned CompactClass>();
			
			assert(testclass.prop_one == "Test");
		}
	
	}
	
}
