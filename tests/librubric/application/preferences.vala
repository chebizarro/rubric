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

	public class Prefs : Valadate.Framework.TestCase {
		
		
		public class TestObject : GLib.Object {

			public HashTable<string,List<string>> views {get;set;}

			public string[] search_paths {get;set;}
			
			public double hex_size {get;set;}

			public int undo_depth {get;set;}
			//default: 256
			public bool show_connection_points {get;set;}
			//default: true
			public bool snap_object {get;set;default=true;}
			//default: false
			public string length_unit {get;set;}
			//default: "mm"
			public string font_size_unit {get;set;}
			//default: "pts"
			public bool snap {get;set;default=true;}
			//default: false
		}
		
		public void test_new_preferences() {

			var prefs = new Preferences("org.rubric.tests");
			
			assert(prefs != null);
			assert(prefs is Preferences);
			
		}

		public void test_apply_preferences() {
			
			var prefs = new Preferences("org.rubric.tests");
			var testobj = new TestObject();
			
			prefs.apply(testobj);
			
			assert(testobj.undo_depth == 256);
			assert(testobj.snap_object != true);
			assert(testobj.length_unit == "mm");
			
		}

		public void test_apply_preferences_child() {
			
			var prefs = new Preferences("org.rubric.tests");
			var testobj = new TestObject();
			
			prefs.apply(testobj, "grid");
			
			assert(testobj.snap != true);
			assert(testobj.hex_size == 1.0);
			
		}

		public void test_apply_preferences_array() {
			
			var prefs = new Preferences("org.rubric.tests");
			var testobj = new TestObject();
			
			prefs.apply(testobj, "modules");
			
			assert(testobj.search_paths.length == 2);
			assert(testobj.search_paths[0] == "path1");
			assert(testobj.search_paths[1] == "path2");
			
		}

		public void test_apply_preferences_dict() {
			
			var prefs = new Preferences("org.rubric.tests");
			var testobj = new TestObject();
			
			prefs.apply(testobj, "regions");

			assert(testobj.views.length == 2);
			assert(testobj.views["workspace"].length() == 2);
			assert(testobj.views["workspace"].nth_data(0) == "DefaultView1");
			
		}

		public void test_apply_preferences_obj() {
			
			var prefs = new Preferences("org.rubric.tests");
			var testobj = new TestObject();
			
			prefs.apply(testobj, testobj.get_type().name());

			assert(testobj.views.length == 2);
			assert(testobj.views["workspace"].length() == 2);
			assert(testobj.views["workspace"].nth_data(0) == "DefaultView1");
			
		}

		public void test_preferences_decorator() {
			
			var prefs = new Preferences("org.rubric.tests");
			var container = new Container(false);
			var dec = new PreferencesDecorator(container, prefs);
			container.add_extension(dec);

			container.register<TestObject, TestObject>();
			
			var testobj = container.resolve<TestObject>();
			
			assert(testobj is TestObject);
			assert(testobj.views.length == 2);
			assert(testobj.views["workspace"].length() == 2);
			assert(testobj.views["workspace"].nth_data(0) == "DefaultView1");
		}

	}
}
