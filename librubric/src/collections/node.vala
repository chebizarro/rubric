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

namespace Rubric.Collections {
	
	public interface Node : Object {

		public abstract Node get_root();
		public abstract Node set_root();
		public abstract Node get_parent();
		public abstract Node set_parent();
		public abstract Node get_next();
		public abstract Node set_next();
		public abstract Node get_previous();
		public abstract Node set_previous();
		public abstract Node get_children();
		public abstract Node set_children();
		public abstract Node get_nth_child(int n);
		
	}
}
