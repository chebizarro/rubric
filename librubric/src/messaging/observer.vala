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

	public abstract class Observer : Object {
		
		private ArrayList<Subscriber> _subscribers = new ArrayList<Subscriber>();
		
		public Gee.List<Subscriber> subscribers {
			get {
				return _subscribers;
			}
		}
		

		public virtual bool contains(Subscriber.Token token) {
			
			lock (_subscribers) {
				
				Subscriber? sub = null;
				
				foreach(var event in _subscribers) {
					sub = (event.token == token) ? event : null;
					if(sub != null)
						break;
				}
				
				return (sub != null);
			}
		}
		
		
		public abstract Subscriber.Token subscribe();
		
		public virtual void unsubscribe(Subscriber.Token token) {

			lock (_subscribers) {
				
				Subscriber? sub = null;
				foreach(var event in _subscribers) {
					sub = (event.token == token) ? event : null;
					if(sub != null) {
						_subscribers.remove(sub);
						break;
					}
				}
			}
		}

		public abstract void publish(Value payload);
		
	}
}
