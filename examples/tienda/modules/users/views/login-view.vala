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

using Rubric.PM;
using Rubric;
using RubricGtk.Widgets;

namespace Tienda.Modules.Users {
	
	[GtkTemplate (ui = "/org/tienda/modules/users/views/login.ui")]
	public class LoginView : BoxView {
		
		[GtkChild]
		private LoginViewModel user_view_model;

		[GtkCallback]
		public void login() {
			region_manager.navigate("content", "TiendaModulesDashboardDashboardView");
		}

		construct {
			view_model = user_view_model;
		}

	}
	
}

