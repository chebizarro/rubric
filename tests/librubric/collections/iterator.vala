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
 
using Rubric.Collections;

namespace Rubric.Tests {

	public class RubricIterator : Valadate.Framework.TestCase {

		private string[] strings = { "test", "test two", "test three" };

		public void test_iterator_new () {
		
			var iter = new Iterator<string>(strings);
			
			assert(iter is Iterator);
		}

		public void test_iterator_next () {
		
			var iter = new Iterator<string>(strings);
			
			assert(iter.next());
		}

		public void test_iterator_get () {
		
			var iter = new Iterator<string>(strings);
			
			assert(iter.get() == "test");
		}

		public void test_iterator_iterator () {
		
			var iter = new Iterator<string>(strings);
			
			int i = 0;
			
			foreach(var item in iter)
				i++;
				
			assert(i == 3);
		}

	
	}
	
}
