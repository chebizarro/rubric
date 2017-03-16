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

namespace Rubric.Presentation {

	public abstract class FileDialogSettings : Object {
	
		public bool add_extension {get;set;default=true;}

		public bool check_file_exists {get;set;default=true;}

		public bool check_path_exists {get;set;default=true;}
		
		public string default_extension {get;set;default="";}

		public string filename {get;set;}
		
		public string[] filenames {get;set;}

		public string filter {get;set;}

		public string initial_directory {get;set;}

		public string title {get;set;}
	
	}
	
}
