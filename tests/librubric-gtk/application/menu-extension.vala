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

	public class MenuExtensionTests : Valadate.Framework.TestCase {
		
		private string menubar =
"""<section>
	<submenu>
		<attribute name="label">_File</attribute>
		<attribute name="id">file-section</attribute>
	</submenu>
	<submenu>
		<attribute name="label">View</attribute>
		<attribute name="id">view-section</attribute>
		<section>
			<attribute name="id">view-section-plugins</attribute>
		</section>
		<section>
			<attribute name="id">view-section-windows</attribute>
		</section>
	</submenu>
	<submenu>
		<attribute name="label">Tools</attribute>
		<attribute name="id">tools-section</attribute>
		<section>
			<attribute name="id">tools-section-1</attribute>
		</section>
	</submenu>
</section>
""";	

		private string appmenu =
	"""<section>
		<item>
			<attribute name="label">_Preferences</attribute>
			<attribute name="action">app.preferences</attribute>
		</item>
	</section>
	<section>
		<item>
			<attribute name="accel">&lt;Primary&gt;q</attribute>
			<attribute name="label">_Quit</attribute>
			<attribute name="action">app.quit</attribute>
		</item>
	</section>
	""";

		private string pluginmenu =
	"""<section>
		<attribute name="id">file-section</attribute>
		<item>
			<attribute name="accel">&lt;Primary&gt;n</attribute>
			<attribute name="label">_New</attribute>
			<attribute name="action">win.file_new</attribute>
		</item>
		<submenu>
			<attribute name="label">New</attribute>
			<section>
				<attribute name="id">wizard-section</attribute>
			</section>
		</submenu>
		<item>
			<attribute name="accel">&lt;Primary&gt;o</attribute>
			<attribute name="label">_Open</attribute>
			<attribute name="action">win.file_open</attribute>
		</item>
		<submenu>
			<attribute name="label">Open Recent</attribute>
			<attribute name="id">recent-section</attribute>
			<section>
			</section>
		</submenu>
	</section>
	""";

		public void test_menu_extension_new () {
			var testmenu = new GLib.Menu ();
			testmenu.append ("New Menu", null);
			var extension = new MenuExtension(testmenu);
			assert_true (extension is MenuExtension);
		}

		public void test_menu_extension_append_menu_item () {

			string test_result = """<section>
	<submenu>
		<attribute name="label">_File</attribute>
		<attribute name="id">file-section</attribute>
	</submenu>
	<submenu>
		<attribute name="label">View</attribute>
		<attribute name="id">view-section</attribute>
		<section>
			<attribute name="id">view-section-plugins</attribute>
		</section>
		<section>
			<attribute name="id">view-section-windows</attribute>
		</section>
		<section>
			<attribute name="rubric-merge-id">2</attribute>
			<attribute name="id">file-section</attribute>
			<item>
				<attribute name="accel"><Primary>n</attribute>
				<attribute name="label">_New</attribute>
				<attribute name="action">win.file_new</attribute>
			</item>
			<submenu>
				<attribute name="label">New</attribute>
				<section>
					<attribute name="id">wizard-section</attribute>
				</section>
			</submenu>
			<item>
				<attribute name="accel"><Primary>o</attribute>
				<attribute name="label">_Open</attribute>
				<attribute name="action">win.file_open</attribute>
			</item>
			<submenu>
				<attribute name="label">Open Recent</attribute>
				<attribute name="id">recent-section</attribute>
				<section>
				</section>
			</submenu>
		</section>
	</submenu>
	<submenu>
		<attribute name="label">Tools</attribute>
		<attribute name="id">tools-section</attribute>
		<section>
			<attribute name="id">tools-section-1</attribute>
		</section>
	</submenu>
</section>
""";

			var menubldrstr = "<interface><menu id=\"menubar\">%s</menu></interface>".printf(this.menubar);
			var menubar_builder = new Gtk.Builder.from_string (menubldrstr, menubldrstr.length);
			var menubar = menubar_builder.get_object ("menubar") as GLib.Menu;

			var pluginbldrstr = "<interface><menu id=\"plugin\">%s</menu></interface>".printf(this.pluginmenu);
			var plugin_menu_builder = new Gtk.Builder.from_string (pluginbldrstr, pluginbldrstr.length);
			var plugin_menu = plugin_menu_builder.get_object ("plugin") as GLib.Menu;

			var extpt = menubar.get_item_link (0, GLib.Menu.LINK_SECTION).get_item_link (1, GLib.Menu.LINK_SUBMENU);
			var ext = new MenuExtension(extpt as GLib.Menu);
			ext.append_menu_item (new MenuItem.from_model(plugin_menu,0));

			assert_true (iterate_menu(menubar, 0) == test_result);
		}

		public void test_menu_extension_prepend_menu_item () {

			string test_result = """<section>
	<submenu>
		<attribute name="label">_File</attribute>
		<attribute name="id">file-section</attribute>
	</submenu>
	<submenu>
		<attribute name="label">View</attribute>
		<attribute name="id">view-section</attribute>
		<section>
			<attribute name="rubric-merge-id">3</attribute>
			<attribute name="id">file-section</attribute>
			<item>
				<attribute name="accel"><Primary>n</attribute>
				<attribute name="label">_New</attribute>
				<attribute name="action">win.file_new</attribute>
			</item>
			<submenu>
				<attribute name="label">New</attribute>
				<section>
					<attribute name="id">wizard-section</attribute>
				</section>
			</submenu>
			<item>
				<attribute name="accel"><Primary>o</attribute>
				<attribute name="label">_Open</attribute>
				<attribute name="action">win.file_open</attribute>
			</item>
			<submenu>
				<attribute name="label">Open Recent</attribute>
				<attribute name="id">recent-section</attribute>
				<section>
				</section>
			</submenu>
		</section>
		<section>
			<attribute name="id">view-section-plugins</attribute>
		</section>
		<section>
			<attribute name="id">view-section-windows</attribute>
		</section>
	</submenu>
	<submenu>
		<attribute name="label">Tools</attribute>
		<attribute name="id">tools-section</attribute>
		<section>
			<attribute name="id">tools-section-1</attribute>
		</section>
	</submenu>
</section>
""";

			var menubldrstr = "<interface><menu id=\"menubar\">%s</menu></interface>".printf(this.menubar);
			var menubar_builder = new Gtk.Builder.from_string (menubldrstr, menubldrstr.length);
			var menubar = menubar_builder.get_object ("menubar") as GLib.Menu;

			var pluginbldrstr = "<interface><menu id=\"plugin\">%s</menu></interface>".printf(this.pluginmenu);
			var plugin_menu_builder = new Gtk.Builder.from_string (pluginbldrstr, pluginbldrstr.length);
			var plugin_menu = plugin_menu_builder.get_object ("plugin") as GLib.Menu;

			var extpt = menubar.get_item_link (0, GLib.Menu.LINK_SECTION).get_item_link (1, GLib.Menu.LINK_SUBMENU);
			var ext = new MenuExtension(extpt as GLib.Menu);
			ext.prepend_menu_item (new MenuItem.from_model(plugin_menu,0));
			assert_true (iterate_menu(menubar, 0) == test_result);
			
		}

		public void menu_extension_remove_items () {

			string test_result = """<section>
	<submenu>
		<attribute name="label">_File</attribute>
		<attribute name="id">file-section</attribute>
	</submenu>
	<submenu>
		<attribute name="label">View</attribute>
		<attribute name="id">view-section</attribute>
		<section>
			<attribute name="rubric-merge-id">4</attribute>
			<attribute name="id">file-section</attribute>
			<item>
				<attribute name="accel"><Primary>n</attribute>
				<attribute name="label">_New</attribute>
				<attribute name="action">win.file_new</attribute>
			</item>
			<submenu>
				<attribute name="label">New</attribute>
				<section>
					<attribute name="id">wizard-section</attribute>
				</section>
			</submenu>
			<item>
				<attribute name="accel"><Primary>o</attribute>
				<attribute name="label">_Open</attribute>
				<attribute name="action">win.file_open</attribute>
			</item>
			<submenu>
				<attribute name="label">Open Recent</attribute>
				<attribute name="id">recent-section</attribute>
				<section>
				</section>
			</submenu>
		</section>
		<section>
			<attribute name="id">view-section-plugins</attribute>
		</section>
		<section>
			<attribute name="id">view-section-windows</attribute>
		</section>
	</submenu>
	<submenu>
		<attribute name="label">Tools</attribute>
		<attribute name="id">tools-section</attribute>
		<section>
			<attribute name="id">tools-section-1</attribute>
		</section>
	</submenu>
</section>
""";

			var menubldrstr = "<interface><menu id=\"menubar\">%s</menu></interface>".printf(this.menubar);
			var menubar_builder = new Gtk.Builder.from_string (menubldrstr, menubldrstr.length);
			var menubar = menubar_builder.get_object ("menubar") as GLib.Menu;

			var pluginbldrstr = "<interface><menu id=\"plugin\">%s</menu></interface>".printf(this.pluginmenu);
			var plugin_menu_builder = new Gtk.Builder.from_string (pluginbldrstr, pluginbldrstr.length);
			var plugin_menu = plugin_menu_builder.get_object ("plugin") as GLib.Menu;

			var extpt = menubar.get_item_link (0, GLib.Menu.LINK_SECTION).get_item_link (1, GLib.Menu.LINK_SUBMENU);
			var ext = new MenuExtension(extpt as GLib.Menu);
			ext.prepend_menu_item (new MenuItem.from_model(plugin_menu,0));
			var menubar_add_result = iterate_menu(menubar, 0);
			assert_true (menubar_add_result == test_result);

			ext.remove_items ();
			assert_true (iterate_menu(menubar, 0) == this.menubar);

			var plugin_extpt = plugin_menu.get_item_link (0, GLib.Menu.LINK_SECTION).get_item_link (1, GLib.Menu.LINK_SUBMENU);
			var plugin_ext = new MenuExtension(plugin_extpt as GLib.Menu);
			
			ext.prepend_menu_item (new MenuItem.from_model(plugin_menu,0));
			assert_true (menubar_add_result == iterate_menu(menubar, 0));

			string plugin_extend =
	"""<section>
		<attribute name="id">wizard-section</attribute>
	</section>
	""";
			
			var plugextbldrstr = "<interface><menu id=\"pluginext\">%s</menu></interface>".printf(plugin_extend);
			var plugext_menu_builder = new Gtk.Builder.from_string (plugextbldrstr, plugextbldrstr.length);
			var plugext_menu = plugext_menu_builder.get_object ("pluginext") as GLib.Menu;
		
			plugin_ext.prepend_menu_item (new MenuItem.from_model(plugext_menu,0));

			assert_true (menubar_add_result != iterate_menu(menubar, 0));

			plugin_ext.remove_items ();
			assert_true (menubar_add_result == iterate_menu(menubar, 0));
			
		}


		public void test_menu_extension_destructor () {

			string test_result = """<section>
	<submenu>
		<attribute name="label">_File</attribute>
		<attribute name="id">file-section</attribute>
	</submenu>
	<submenu>
		<attribute name="label">View</attribute>
		<attribute name="id">view-section</attribute>
		<section>
			<attribute name="id">view-section-plugins</attribute>
		</section>
		<section>
			<attribute name="id">view-section-windows</attribute>
		</section>
		<section>
			<attribute name="rubric-merge-id">4</attribute>
			<attribute name="id">file-section</attribute>
			<item>
				<attribute name="accel"><Primary>n</attribute>
				<attribute name="label">_New</attribute>
				<attribute name="action">win.file_new</attribute>
			</item>
			<submenu>
				<attribute name="label">New</attribute>
				<section>
					<attribute name="id">wizard-section</attribute>
				</section>
			</submenu>
			<item>
				<attribute name="accel"><Primary>o</attribute>
				<attribute name="label">_Open</attribute>
				<attribute name="action">win.file_open</attribute>
			</item>
			<submenu>
				<attribute name="label">Open Recent</attribute>
				<attribute name="id">recent-section</attribute>
				<section>
				</section>
			</submenu>
		</section>
	</submenu>
	<submenu>
		<attribute name="label">Tools</attribute>
		<attribute name="id">tools-section</attribute>
		<section>
			<attribute name="id">tools-section-1</attribute>
		</section>
	</submenu>
</section>
""";

			var menubldrstr = "<interface><menu id=\"menubar\">%s</menu></interface>".printf(this.menubar);
			var menubar_builder = new Gtk.Builder.from_string (menubldrstr, menubldrstr.length);
			var menubar = menubar_builder.get_object ("menubar") as GLib.Menu;

			var pluginbldrstr = "<interface><menu id=\"plugin\">%s</menu></interface>".printf(this.pluginmenu);
			var plugin_menu_builder = new Gtk.Builder.from_string (pluginbldrstr, pluginbldrstr.length);
			var plugin_menu = plugin_menu_builder.get_object ("plugin") as GLib.Menu;

			var extpt = menubar.get_item_link (0, GLib.Menu.LINK_SECTION).get_item_link (1, GLib.Menu.LINK_SUBMENU);
			var ext = new MenuExtension(extpt as GLib.Menu);
			ext.append_menu_item (new MenuItem.from_model(plugin_menu,0));

			assert_true (iterate_menu(menubar, 0) == test_result);
			
			ext = null;

			assert_true (iterate_menu(menubar, 0) == this.menubar);
			
		}

	}
}
