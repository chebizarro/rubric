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
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

using Rubric;
using Rubric.Modularity;

namespace RubricGtk.Modularity {

	public class ModuleManager : Peas.Engine, Rubric.Modularity.ModuleManager {
	
		public Container container {get;construct set;}
	
		private Peas.ExtensionSet extension_set;
	
		construct {
			enable_loader("python3");
			extension_set = new Peas.ExtensionSet(this, typeof(Rubric.Modularity.Module), "container", container);
		}
		
		public ModuleManager(Container container) {
			GLib.Object(container : container);
		}

		public void run() {
			rescan_plugins();

			foreach (var plug in get_plugin_list ()) {
				if (!plug.is_builtin())
					continue;
				if (try_load_plugin (plug)) {
					GLib.debug ("Plugin Loaded:" +plug.get_name ());
				} else {
					GLib.warning ("Could not load plugin:" +plug.get_name ());
				}
			}
			
			extension_set.extension_removed.connect((info, ext) => {
				((Rubric.Modularity.Module) ext).deactivate ();
			});
			
			extension_set.foreach((s, i, e) => {
				var prefix = i.get_external_data("Prefix");
				if(prefix != null)
					load_resources(prefix);
				
				((Rubric.Modularity.Module) e).activate ();
			});				
			
		}

		private void load_resources(string prefix) {
			
			try {
				foreach(var res in resources_enumerate_children(
					prefix, ResourceLookupFlags.NONE)) {
					container.register_resource(prefix + res);
				}
			} catch (Error e) {
				debug(e.message);
			}
	
		}

		public void load_module(string module_name) {
			
		}
	
	}
	
}
