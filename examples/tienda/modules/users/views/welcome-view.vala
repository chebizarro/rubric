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

using Rubric.PM;
using Rubric;

namespace Tienda.Modules.Users {
	

	[GtkTemplate (ui = "/org/tienda/modules/users/views/welcome.ui")]
	public class WelcomeView : Gtk.Box, View {
		
		public Rubric.Regions.RegionManager region_manager {get;construct set;}

		public Container container {get;construct set;} 

		public ViewModel view_model {get;set;}

		public WelcomeView(Container container) {
			Object(container: container);
		}

	}
	
}

