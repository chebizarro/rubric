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
	 * Specifies on which stage the Module group will be initialized.
	 */
	public enum InitializationMode {
		/**
		 * The module will be initialized when it is available on application start-up.
		 */
		WHEN_AVAILABLE,
		/**
		 * The module will be initialized when requested, and not automatically on application start-up.
		 */
		ON_DEMAND
	}

	/**
	 * Defines the states a {@link ModuleInfo} can be in, with regards to the module loading and initialization process. 
	 */
	public enum ModuleState {
		/**
		 * Initial state for {@link ModuleInfo}s. The {@link ModuleInfo} is defined, 
		 * but it has not been loaded, retrieved or initialized yet. 
		 */
		NOT_STARTED,
		/**
		 * The assembly that contains the type of the module is currently being loaded by an instance of a
		 * {@link ModuleTypeLoader}. 
		 */
		LOADING_TYPES,
		/**
		 * The assembly that holds the Module is present. This means the type of the {@link Module} can be instantiated and initialized. 
		 */
		READY_FOR_INITIALIZATION,
		/**
		 * The module is currently Initializing, by the {@link ModuleInitializer}
		 */
		INITIALIZING,
		/**
		 * The module is initialized and ready to be used. 
		 */
		INITIALIZED
	}
	
	public class ModuleInfo : GLib.Object, ModuleCatalogItem	{

		/**
		 * Initializes a new instance of {@link Dia3.ModuleInfo}.
		 * 
		 * @param name The module's name.
		 * @param type The module {@link GLib.Type}'s AssemblyQualifiedName.
		 * @param dependson The modules this instance depends on.
		 * @throws GLib.Error An {@link GLib.Error} is thrown if dependsOn is //null//.
		 */
		public ModuleInfo(string name, string type, string[] dependson) {
			this.module_name = name;
			this.module_type = type;
			/*this.depends_on = new List<string>();

			foreach (string dependency in dependson) {
				this.depends_on.append(dependency);
			}*/
		}

		/**
		 * Gets or sets the name of the module.
		 *
		 * The name of the module.
		 */
		public string module_name { get; set; }

		/**
		 * Gets or sets the module {@link GLib.Type}'s AssemblyQualifiedName.
		 */
		public string module_type { get; set; }

		/**
		 * Gets or sets the list of modules that this module depends upon.
		 */
		//public List<string> depends_on { get; set; }

		/**
		 * Specifies on which stage the Module will be initialized.
		 */
		public InitializationMode initialization_mode { get; set; }

		/**
		 * Reference to the location of the module assembly.
		 * 
		 * The following are examples of valid {@link ModuleInfo.module_ref} values:
		 * {{{
		 * file: *Project/Modules/my-module.la
		 * }}}
		 */
		public string module_ref { get; set; }

		/**
		 * Gets or sets the state of the {@link ModuleInfo} with regards to the module loading and initialization process.
		 */
		public ModuleState state { get; set; }
	}
	
}
