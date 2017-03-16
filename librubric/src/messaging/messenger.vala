/* 
 * Rubric -- a Vala framework for responsive applications
 * Copyright (C) 2016 Chris Daley
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
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

using Gee;

namespace Rubric.Messaging {

	public class Messenger : Object, Observable {
		
		private HashMap<Type, Observer> observers = new HashMap<Type, Observer>();
		
		public T get_observer<T>() throws Messaging.Error {
			Type t = typeof(T);
			
			if(!t.is_a(typeof(Observer)))
				throw new Messaging.Error.TYPE("Type: %s is not an Event type", t.name());
			
			lock(observers) {
				if(!observers.has_key(t)) {
					T newobserver = GLib.Object.new(t);
					observers.set(t, (Observer)newobserver);
				}
				return observers.get(t);
			}
		}
		
	}

}
