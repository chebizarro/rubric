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
using Rubric.PM;
using Rubric.Logging;

namespace RubricWeb {

	public class Application : GLib.Application, Assembly, Rubric.Application {

		public Container container { get; construct set; }
		public string namespace {get;set;}
		public string version {get;set;}
		public string[] args {get;construct set;}
		public string resource_path {get;set;}
		public string assembly_id {get;set;}
		public string binary {get;set;}

		public Rubric.Shell shell {get;set;}

		public Application (string[] args, string app_id, string version) {
			this.args = args;
			this.binary = args[0];
			assembly_id = application_id = app_id;
			resource_path = "/%s/".printf(app_id.replace(".","/"));

		}

		public override void startup () {
			base.startup();

			setup_container();
			setup_logging();
			register_assembly();
			setup_preferences();
			setup_region_manager();
			setup_module_manager();
			setup_menu_manager();
			load_resources();
			setup_modules();
			setup_shell();
			setup_menus();
			setup_actions();
			setup_dialog_service();
		}

		public virtual void setup_container() {
			container = new Container(false);
			container.add_extension(new GirResourceHandler(container));
			container_registered(container);
		}

		
		public virtual void register_assembly() {
			try {
				container.register_instance<RubricWeb.Application>(this);
				container.register_instance<Rubric.Application>(this);
			} catch (Error e) {
				error(e.message);
			}
		}

		public virtual void setup_region_manager() {
			
			try {
				/*
				container.register<Rubric.Regions.ViewRegistry, ViewRegistry>();
				var registry = container.resolve<Rubric.Regions.ViewRegistry>();
				container.register<Rubric.Regions.RegionManager, RegionManager>();
				var region_manager = container.resolve<Rubric.Regions.RegionManager>();
				container.register<Rubric.Regions.AdapterFactory, AdapterFactory>();
				var adapter_factory = container.resolve<Rubric.Regions.AdapterFactory>();
				container.register_instance<Rubric.Regions.ViewRegistry>(registry);
				container.register_instance<RubricGtk.Regions.ViewRegistry>(registry as RubricGtk.Regions.ViewRegistry);
				container.register_instance<Rubric.Regions.RegionManager>(region_manager);
				container.register_instance<Rubric.Regions.AdapterFactory>(adapter_factory);
				*/
			} catch (Error e) {
				error(e.message);
			}
		}

		public virtual void setup_menu_manager() {
			try {
				var mm = new MenuManager();
				container.register_instance<Rubric.MenuManager>(mm);

			} catch (Error e) {
				debug(e.message);
			}
		}


		public virtual void setup_shell() {

			try {


			} catch(Error e) {
				error(e.message);
			}
		}

		public virtual void setup_modules() {
			try {
				var mmanager = container.resolve<ModuleManager>();
				mmanager.run();
			} catch (Error e) {
				debug(e.message);
			}
		}

		/**
		 * Set up the application-wide menus
		 */
		public virtual void setup_menus() {
			try {
				var mm = container.resolve<MenuManager>();
				var app_menu = mm.find_menu ("appmenu") as GLib.MenuModel;

			} catch (Error e) {
				debug(e.message);
			}
		}

		public virtual void setup_actions() {
			var action = new GLib.SimpleAction ("quit", null);
			action.activate.connect (quit);
			add_action (action);
		}

		/**
		 * Set up the Dialog Service for the application
		 */
		public virtual void setup_dialog_service() {
			try {
			} catch (Error e) {
				debug(e.message);
			}
		}
		

		public override void activate () {
			try {
				container.resolve<Rubric.Shell>().present();
			} catch (Error e) {
				error(e.message);
			}
		}

	}
}
