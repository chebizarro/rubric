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
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */
 
namespace Rubric.Tests {

	public static string tabs (int ntabs) {
		return string.nfill(ntabs, "\t".get(0));
	}


	public static string iterate_menu (GLib.MenuModel? model, int depth) {

		if (model == null)
			return "";

		string result = "";

		int n_items = model.get_n_items ();

		for (int i = 0; i < n_items; i++) {

			var link_iter = model.iterate_item_links (i);
			bool islink = false;
			
			while (link_iter.next()) {
				
				string link_name = link_iter.get_name();
				result += "%s<%s>\n".printf(tabs(depth), link_name);
				
				var attr_iter = model.iterate_item_attributes (i);
				string att_result = null;
				while (attr_iter.next()) {
					string attr_name = attr_iter.get_name();
					string vartype = attr_iter.get_value().get_type_string();
					char* attr_value;
					string attr_str = "%" + vartype + "</attribute>\n";
					if (model.get_item_attribute (i, attr_name, vartype, out attr_value)) {
						att_result = tabs(depth+1) + "<attribute name=\"%s\">".printf(attr_name) + attr_str.printf (attr_value) + att_result;
					}
				}
				result += att_result;
				
				string link_value = iterate_menu(link_iter.get_value(), depth + 1);
				result += "%s%s</%s>\n".printf(link_value, tabs(depth), link_name);
				islink = true;
			}

			if (!islink) {
				var item_iter = model.iterate_item_attributes (i);
				string item_result = null;
				while (item_iter.next()) {
					string item_name = item_iter.get_name();
					string itemvartype = item_iter.get_value().get_type_string();
					char* item_value;
					string item_str = "%" + itemvartype + "</attribute>\n";
					if (model.get_item_attribute (i, item_name, itemvartype, out item_value)) {
						item_result = tabs(depth+1) + "<attribute name=\"%s\">".printf(item_name) + item_str.printf (item_value) + item_result;
					}
				}
				result += (item_result != null) ? "%s<item>\n%s%s</item>\n".printf(tabs(depth), item_result, tabs(depth)) :"";
			}

		}
		return result;
	}
}
