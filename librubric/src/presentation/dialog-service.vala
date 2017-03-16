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

namespace Rubric.PM {

	public errordomain DialogServiceError {
		VIEW_MODEL_NOT_FOUND,
		VIEW_NOT_REGISTERED
	}

	public interface DialogService : Object {
	
		public abstract void show<T>(ViewModel owner, ViewModel view);
		
		public abstract void show_custom<T>(ViewModel owner, ViewModel view);
		
		public abstract bool show_dialog<T>(ViewModel owner, ViewModel view);
		
		public abstract bool show_custom_dialog<T>(ViewModel owner, ViewModel view);
		
		public abstract bool show_open_file_dialog<T>(ViewModel owner, ViewModel view);
		
		public abstract bool show_save_file_dialog<T>(ViewModel owner, ViewModel view);

		public abstract void show_message_box<T>(ViewModel owner, ViewModel view);
	
	
	}

}
