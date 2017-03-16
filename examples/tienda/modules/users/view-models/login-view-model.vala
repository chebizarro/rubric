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
	
	public class LoginViewModel : RubricGtk.PM.ViewModel {
				
		public string text {get;set;default="";}
		
		private const ActionEntry[] entries = {
			{ "enter-pin", enter_pin, "s" },
			{ "enter-backspace", enter_backspace },
			{ "login", login }
		};
		
		construct {
			((SimpleActionGroup)actions).add_action_entries(entries, this);
			
			this.notify["text"].connect((s,p) => {
				
				//message(text);
			});
		}
		
		public void enter_pin(SimpleAction action, Variant? param) {
			this.text += param.get_string();
			if(this.text.length >= 4)
				action.set_enabled(false);
		}
		
		public void enter_backspace() {
			if(text.length > 0)
				text = text[0:text.length-1];
			
		}

		public void login() {

		}
		
	}
}
