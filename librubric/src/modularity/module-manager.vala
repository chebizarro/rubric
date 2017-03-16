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

namespace Rubric.Modularity {
	/**
	 * Interface for the service that will locate and initialize the application's modules.
	 */
	public interface ModuleManager : GLib.Object {
		/**
		 * Initializes the modules marked as {@link InitializationMode.WHEN_AVAILABLE} on the {@link ModuleCatalog}.
		 */
		public abstract void run();

		/**
		 * Loads and initializes the module on the {@link ModuleCatalog} with the name moduleName.
		 * 
		 * @param module_name Name of the module requested for initialization.
		 */
		public abstract void load_module(string module_name);	   

		/**
		 * Raised repeatedly to provide progress as modules are downloaded.
		 */
		public signal void module_download_progress_changed();

		/**
		 * Raised when a module is loaded or fails to load.
		 */
		public signal void load_module_completed();
	}
}
