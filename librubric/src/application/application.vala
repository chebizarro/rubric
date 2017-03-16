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
		 * The default container for the application
		 */
		public abstract Container container { get; protected set; }

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
		public abstract void setup_logging();

		/**
		 * Load the application's preferences
		 */
		public abstract void setup_preferences();

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
		 * Load the application's resources
		 */
		public abstract void load_resources();



		/**
		 * Set up the application-wide menus
		 */
		public abstract void setup_menus();

		/**
		 * Set up the application's shell
		 */
		public abstract void setup_shell();
		
	}

}
