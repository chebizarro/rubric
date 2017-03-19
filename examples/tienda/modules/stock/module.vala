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
using RubricGtk.Modularity;

namespace Tienda.Modules.Stock {
	
	public class Module : BaseModule {
		
		
		//private Gda.Connection connection;
		//private Gda.SqlParser parser;
		
		public override void activate ()	{
			base.activate();
	
			/*
			try {
				connection = Gda.Connection.open_from_string(
					"SQLite", "DB_DIR=.;DB_NAME=modules/stock/stock.db", null, Gda.ConnectionOptions.NONE);
				parser = connection.create_parser();
				if(parser == null)
					parser = new Gda.SqlParser();

				run_sql_non_select ("DROP table IF EXISTS products");
				run_sql_non_select (
					"CREATE table products (ref string not null primary key, name string not null, price real)");

				
				var sql = "SELECT ref, name, price FROM products";
				var stmt = parser.parse_string(sql, null);

				
				var ctxt = new Gda.MetaContext();
				ctxt.set_column("_tables", 0, connection);
				ctxt.set_table("products");

				connection.update_meta_store(ctxt);
				
				var tree = new Gda.Tree();
				
				var schemas_mgr = new Gda.TreeMgrSchemas(connection);
				
				
				schemas_mgr.add_manager(tables_mgr);

				tree.add_manager(schemas_mgr);
				tree.add_manager(tables_mgr);
				var stmt_mgr = new Gda.TreeMgrSelect(connection, stmt, null);
				var col_mgr = new Gda.TreeMgrColumns(connection, null, null);
				var tables_mgr = new Gda.TreeMgrTables(connection, null);
				stmt_mgr.add_manager(tables_mgr);
				tables_mgr.add_manager(col_mgr);
				tree.add_manager(stmt_mgr);

				tree.update_all();
				tree.dump(null, stdout);

				

				//run_sql_select(sql);
				
				
			} catch (GLib.Error e) {
				warning(e.message);
			}
			*/
		
			container.register<CatalogView, CatalogView>();
		
			//var rm = container.resolve<RegionManager>();
			//rm.register_view<CatalogView>("right");
		}

		/*
		private void run_sql_select(string sql) {
			try {
				var stmt = parser.parse_string(sql, null);
				var model = connection.statement_execute_select(stmt, null);
				model.dump(stdout);
				
			} catch (GLib.Error e) {
				warning(e.message);
			}
			
		}*/
		
	}
	
}

[ModuleInit]
public void peas_register_types (GLib.TypeModule module) {
	var objmodule = module as Peas.ObjectModule;
	objmodule.register_extension_type (typeof (Rubric.Modularity.Module), 
		typeof (Tienda.Modules.Stock.Module));
}
