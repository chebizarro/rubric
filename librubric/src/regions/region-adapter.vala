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
using Gee;

namespace Rubric.Regions {
	
	public abstract class RegionAdapter : Object, Navigator, Region {
		
		public Object object {get;construct set;}
		
		public Container container {get;construct set;}
		
		private ViewCollection _views = new ViewCollection();
		
		public ViewCollection views {
			get {
				return _views;
			}
		}

		private ViewCollection _active_views = new ViewCollection();

		private HashMap<string, View> _named_views = new HashMap<string, View>();

		public ViewCollection active_views {
			get {
				return _active_views;
			}
		}
		
		public string name {get;set;}

		public RegionManager region_manager {get;construct set;}
		
		public virtual RegionManager add_view(View view, string? name = null) {
			if(name != null)
				_named_views.set(name, view);
			_views.add(view);
			return region_manager;
		}
		
		public virtual View? get_view(string name) {
			return _named_views.get(name);
		}

		public virtual bool has_view(string name) {
			return _named_views.has_key(name);
		}

		public virtual void remove_view(View view) {
			_active_views.remove(view);
			
			foreach(var entry in _named_views.entries)
				if(entry.value == view)
					_named_views.unset(entry.key);
		}
		
		public virtual void remove_all_views() {
			_active_views.remove_all();
			_views.remove_all();
			_named_views.clear();
		}
		
		public virtual void activate_view(View view) {
			
		}
		
		public virtual void deactivate_view(View view) {
			
		}
		
		
		public virtual void navigate(string target, Parameter[]? params = null, Func<NavigationResult>? callback = null) {
			try {
				var view = container.resolve_type(Type.from_name(target)) as View;
				remove_all_views();
				add_view(view);
				
			} catch (Error e) {
				warning(e.message);
			}
		}

	}
	
}
