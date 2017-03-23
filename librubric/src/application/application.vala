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

using Rubric.Logging;
using Rubric.Modularity;

namespace Rubric {

	/**
	 * This interface defines the necessary abstract and virtual methods
	 * for initializing a Rubric Application.
	 * 
	 * The methods should be able to be called in the following order:
	 * 	setup_container();
	 * 	load_config();
	 * 	...
	 * 	setup_shell();
	 */
	public interface Application : Object, Assembly {

		/**
		 * The application's shell
		 */
		public abstract Shell shell { get; set; }

		/**
		 * Set up the default container for the application
		 */
		public abstract void setup_container();

		/**
		 * Set up logging for the application
		 */
		public virtual void setup_logging() {
			var logger = new DebugLogger();
			try {
				container.register_instance<Logger>(logger);
			} catch (Error e) {
				warning(e.message);
			}
		}

		/**
		 * Set up the application's regions
		 */
		public abstract void setup_region_manager();


		public abstract void register_assembly();


		/**
		 * Set up any application wide actions
		 */
		public abstract void setup_actions();

	
		/**
		 * Set up the default container for the application
		 */
		public abstract void setup_modules();

		/**
		 * Set up the Dialog Service for the application
		 */
		public abstract void setup_dialog_service();

		/**
		 * Set up the application-wide menus
		 */
		public abstract void setup_menus();

		/**
		 * Set up the application's shell
		 */
		public abstract void setup_shell();


		public virtual void setup_module_manager() {
			
			try {
				container.register<Rubric.Modularity.ModuleCatalog, Rubric.Modularity.ModuleCatalog>();
				container.register<Rubric.ModuleManager, Rubric.ModuleManager>();
				
				var mmanager = container.resolve<Rubric.ModuleManager>();
				var modpath = "%s_MODULE_DIR".printf(assembly_id.replace(".","_").ascii_up());
				var moddir = Environment.get_variable(modpath);

				if(moddir != null)
					mmanager.add_search_path(moddir, null);
			
				container.register_instance<Rubric.Modularity.ModuleManager>(mmanager);
			} catch (Error e) {
				warning(e.message);
			}
		}


	}

}
