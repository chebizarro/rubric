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
 
namespace Rubric {

	public class PreferencesDecorator : Object, ContainerExtension, DecoratorExtension {

		public unowned Container container {get;construct set;}

		public Preferences preferences {get;construct set;}

		public PreferencesDecorator(Container container, Preferences prefs) {
			Object(container : container, preferences : prefs);
		}

		public Value decorate(Type from, Value object, string? name = null) throws Error {
			try {
				var fname = from.name();
				if(name != null)
					fname = "%s.%s".printf(fname, name);
				
				return preferences.apply(object.get_object(), fname);
			} catch (Error e) {
				debug(e.message);
			}
			return object;
		}

		public Value decorate_all(Type from, Value objects) throws Error {
			
			return objects;
		}

	}

}
