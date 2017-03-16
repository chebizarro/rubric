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

using Rubric;
using Rubric.Regions;
using Rubric.Modularity;

namespace Tienda.Modules.Dashboard {
	
	public class Module : Object, Rubric.Modularity.Module {
		
		public Container container {owned get; construct set;}
		
		public void activate ()	{

			container.register<DashboardView, DashboardView>();
		}

		public void deactivate () {	}

		public void update_state () { }
		
	}
	
}

[ModuleInit]
public void peas_register_types (GLib.TypeModule module) {
	var objmodule = module as Peas.ObjectModule;
	objmodule.register_extension_type (typeof (Rubric.Modularity.Module), 
		typeof (Tienda.Modules.Dashboard.Module));
}
