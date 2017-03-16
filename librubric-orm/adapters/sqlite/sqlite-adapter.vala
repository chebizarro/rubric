/*
 * Rubric -- a Vala framework for responsive applications
 * Copyright 2016 Chris Daley <bizarro@localhost.localdomain>
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

namespace Rubric.ORM.Adapters {

	public class SqliteAdapter : BaseAdapter {

		private Sqlite.Database db;

		private static int OPEN_URI = 0x00000040;
		private static int OPEN_NOMUTEX = 0x00008000;

		public override bool open(string dsn) throws Rubric.ORM.Error {
			
			int flags = Sqlite.OPEN_CREATE | Sqlite.OPEN_READWRITE | OPEN_URI  | OPEN_NOMUTEX;
			
			int ret = Sqlite.Database.open_v2(dsn, out db, flags);
			
			if(ret != Sqlite.OK)
				throw new Rubric.ORM.Error.ADAPTER_OPEN("Failed to open database %s : %d: %s", dsn,  db.errcode (), db.errmsg ());
			
			return true;
		}

		public override bool close() throws Rubric.ORM.Error {
			db = null;
			return true;
		}


		public override void* get_handle() {
			return db;
		}

		public override CommandBuilder get_command_builder(Parameter[] parameters) {

			return Object.newv(typeof(SqliteCommandBuilder), parameters) as CommandBuilder;
		}


	}
	
}

