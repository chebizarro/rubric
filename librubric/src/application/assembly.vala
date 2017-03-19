/*
 * Rubric -- a Vala framework for responsive applications
 * Copyright 2017 Chris Daley <bizarro@localhost.localdomain>
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

namespace Rubric {
	
	public interface Assembly : Object {

		/**
		 * This signal is fired when the Default Container is registered
		 * @param container The Default Container
		 */
		public signal void container_registered(Container container);
		
		/**
		 * The default container for the assembly
		 */
		public abstract Container container { get; construct set; }

		/**
		 * The path to the assembly's binary
		 */
		public abstract string binary {get;set;}

		/**
		 * The id for the assembly - i.e. org.rubric.app
		 */
		public abstract string assembly_id {get;set;}

		/**
		 * The Namespace for the assembly. 
		 */
		public abstract string namespace {get;set;}

		/**
		 * The version of the assembly. 
		 */
		public abstract string version {get;set;}

		/**
		 * The resource path of the assembly. 
		 */
		public abstract string resource_path {get;set;}

		/**
		 * The arguments that the assembly was launched with
		 */
		public abstract string[] args {get;construct set;}


		private void recurse_resources(string prefix) {
			try {
				foreach(var res in resources_enumerate_children(
					prefix, ResourceLookupFlags.NONE)) {
					if(res.has_suffix("/"))
						recurse_resources(prefix + res);
					else
						container.register_resource(prefix + res, this);
				}
			} catch (Error e) {
				error(e.message);
			}
		}

		public virtual void load_resources() {
			if (resource_path != null)
				recurse_resources(resource_path);
		}

		
	}
	
}
