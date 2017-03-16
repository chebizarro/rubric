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
using RubricGtk.Widgets;

namespace Tienda.Modules.Sales {
	
	public class OrderModel : Object {
		
		public string name {get;set;}
		public int id {get;set;}
		
		public OrderModel(string name, int id) {
			this.name = name;
			this.id = id;
		}
		
	}
	
	
	[GtkTemplate (ui = "/org/tienda/modules/sales/views/order.ui")]
	public class OrderView : BoxView {

		
		[GtkChild]
		private Gtk.TreeView order_treeview;

		construct {
			
			var orders = new Gee.ArrayList<OrderModel>();
			
			orders.add(new OrderModel("test", 0));
			orders.add(new OrderModel("test", 2));
			orders.add(new OrderModel("test", 3));
			
			var listview = new ListTreeStore(orders);
			
			order_treeview.set_model(listview);

			Gtk.CellRendererText cell = new Gtk.CellRendererText ();
			order_treeview.insert_column_with_attributes (-1, "Name", cell, "text", 0);
			order_treeview.insert_column_with_attributes (-1, "Id", cell, "text", 1);
			
		}


	}
	
}

