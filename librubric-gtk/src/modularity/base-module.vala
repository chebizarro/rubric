/* 
 * Rubric -- a Vala framework for responsive applications
 * Copyright (C) 2016 Chris Daley
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

namespace RubricGtk.Modularity {

	public abstract class BaseModule : GLib.Object, Assembly, Rubric.Modularity.Module {

		public string binary {get;set;}

		public Container container { construct set; get; }

		public string namespace {get;set;}

		public string version {get;set;}

		public string resource_path {get;set;}

		public string[] args {get;construct set;}

		public string assembly_id {get;set;}
	
		public virtual void activate() {
			if(assembly_id != null)
				resource_path = "/%s/".printf(assembly_id.replace(".","/"));
			load_resources();
		}
		
		public virtual void deactivate() { }
		public virtual void update_state() { }
	
	}
}
