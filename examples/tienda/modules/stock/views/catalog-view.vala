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
using Rubric;
using RubricGtk.Widgets;
using RubricGtk.PM;

namespace Tienda.Modules.Stock {

	
	public class ProductModel : Gom.Resource {
		static construct {
			set_table ("products");
			set_primary_key ("ref");
		}
		public string ref {get;set;} 
		public string name {get;set;} 
		public float price {get;set;} 
	}

	public class CategoryModel : Gom.Resource {
		static construct {
			set_table ("categories");
			set_primary_key ("id");
		}
		public int id {get;set;} 
		public string name {get;set;} 
		public string image {get;set;} 
		public Gdk.Pixbuf icon {
			owned get {
				Gdk.Pixbuf px;
				if(image != null) {
					var path = "/org/tienda/modules/stock/data/images/%s.svg".printf(image);
					px = new Gdk.Pixbuf.from_resource(path);
				} else {
					Gtk.IconTheme icon_theme = Gtk.IconTheme.get_default ();
					px = icon_theme.load_icon("image-missing", 20, 0);
				}
				return px;
			}
		} 
	}

	

	public class DashboardViewModel : ViewModel {
		
		public Gom.ResourceGroup categories {get;set;}
		
		public Container container {get;construct set;}
		
		construct {
			try {
				categories = container.resolve<Gom.ResourceGroup>("tienda-db",
					{ Parameter() {name = "type", value = typeof (CategoryModel) }});
			} catch (GLib.Error error) {
				message(error.message);
			}
		}
		
		public DashboardViewModel(Container container) {
			Object(container : container);
		}
		
	}
	

	
	[GtkTemplate (ui = "/org/tienda/modules/stock/views/catalog.ui")]
	public class CatalogView : BoxView {

		[GtkChild]
		Gtk.IconView icon_view;

		[GtkCallback]
		private void activate_item(Gtk.TreePath path) {

		}

		construct {
			view_model = new DashboardViewModel(container);
			var model = new CategoryTreeStore(((DashboardViewModel)view_model).categories);
			icon_view.model = model;
			icon_view.set_pixbuf_column(4);
			icon_view.set_text_column(2);
		}

	}
	
}

