/*
 * Rubric -- a Vala framework for responsive applications
 * Copyright 2017 Chris Daley <chebizarro@gmail.com>
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

/*
 * Conceptually based on MVVM Dialogs https://github.com/FantasticFiasco/mvvm-dialogs 
 */

namespace RubricGtk.PM {

	using Rubric;
	using Rubric.PM;

	public class GtkDialogService : Object, DialogService {

		private Container container;
		
		public GtkDialogService(Container container) {
			this.container = container;
		}
	
		public void show<T>(Rubric.PM.ViewModel owner, Rubric.PM.ViewModel view) {
			
		}
		
		public void show_custom<T>(Rubric.PM.ViewModel owner, Rubric.PM.ViewModel view) {
			
		}
		
		public bool show_dialog<T>(Rubric.PM.ViewModel owner, Rubric.PM.ViewModel view) {
			return false;
		}
		
		public bool show_custom_dialog<T>(Rubric.PM.ViewModel owner, Rubric.PM.ViewModel view) {
			return false;
		}
		
		public bool show_open_file_dialog<T>(Rubric.PM.ViewModel owner, Rubric.PM.ViewModel view) {
			return false;
		}
		
		public bool show_save_file_dialog<T>(Rubric.PM.ViewModel owner, Rubric.PM.ViewModel view) {
			return false;
		}

		public void show_message_box<T>(Rubric.PM.ViewModel owner, Rubric.PM.ViewModel view) {
			
		}
	
	}

}
