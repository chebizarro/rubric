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

namespace Rubric.ORM {

	public abstract class BaseAdapter : Adapter, Object {

		private enum CmdType {
			OPEN,
			READ,
			WRITE,
			CLOSE
		}

		private class Worker {
			private Adapter adapter;
			private AdapterCallback callback;

			public CmdType cmd_type {get;set;}
			
			public Worker(Adapter adapter, CmdType type, AdapterCallback callback) {
				this.adapter = adapter;
				this.cmd_type = type;
				this.callback = callback;
			}

			public void run() {
				callback(adapter);
			}
			
		}


		private ThreadPool<Worker> thread_pool;

		construct {
			thread_pool = new ThreadPool<Worker>.with_owned_data((w) => {
				w.run();
			}, 3, false);
		}

		~BaseAdapter() {
			close();
		}

		public abstract bool open(string dsn) throws Rubric.ORM.Error;

		public async bool open_async (string dsn) throws Rubric.ORM.Error {
			GLib.SourceFunc cb = open_async.callback;
			bool res = false;
			
			thread_pool.add(new Worker(this, CmdType.OPEN, (a) => {
				res = open(dsn);
				GLib.Idle.add((owned) cb);
			}));
			
			yield;
			return res;
		}

		public abstract bool close () throws Rubric.ORM.Error;
		
		public async bool close_async () throws Rubric.ORM.Error {
			GLib.SourceFunc cb = close_async.callback;
			bool res = false;
			
			thread_pool.add(new Worker(this, CmdType.CLOSE, (a) => {
				res = close();
				GLib.Idle.add((owned) cb);
			}));
			
			yield;
			return res;
		}

		public bool execute_sql (string sql) throws Rubric.ORM.Error {
			return true;
		}
		
		public abstract void* get_handle();

		public abstract CommandBuilder get_command_builder(Parameter[] parameters);
		
	}
	
}

