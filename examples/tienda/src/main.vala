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

using RubricGtk;

namespace Tienda {
	
	public static int main (string[] args) {

		#if ENABLE_DEVELOPMENT_MODE
			var currdir = Environment.get_current_dir();
			var datadir = "%s%s%s".printf(currdir, Path.DIR_SEPARATOR_S, "data");
			var moduledir = "%s%s%s".printf(currdir, Path.DIR_SEPARATOR_S, "modules");
			GLib.Environment.set_variable("GSETTINGS_SCHEMA_DIR", datadir, true);
			GLib.Environment.set_variable("ORG_TIENDA_APP_MODULE_DIR", moduledir, true);
		#endif

		var application = new RubricGtk.Application(args, "org.tienda.app", "1.0");
		
		application.startup.connect(() => {
			var adapter = new Gom.Adapter ();
			var uri = "/home/bizarro/Documents/projects/valadate.org/valarade/valarade/rubric/examples/tienda/modules/stock/stock.db";

			try {
				adapter.open_sync (uri);
			} catch (GLib.Error error) {
				GLib.error ("Failed to open database '%s': %s", uri, error.message);
			}
			
			var repository = new Gom.Repository (adapter);
			application.container.register_instance<Gom.Repository>(repository);

			application.container.register<Gom.ResourceGroup, Gom.ResourceGroup>("tienda-db", null, (p) => {
				
				Type t = Type.INVALID;
				
				foreach(var pm in p) {
					if (pm.name == "type") {
						t = pm.value.get_gtype();
						break;
					}
				}
				
				if(t != Type.INVALID && t.is_a(typeof(Gom.Resource))) {
					var repo = application.container.resolve<Gom.Repository>();
					return repo.find_sync (t, null);
				}
				return Value(t);
			});
				
		});
		
		return application.run (args);

	}	
	
}
