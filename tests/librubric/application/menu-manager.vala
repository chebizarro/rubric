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

	public class MenuManager : Valadate.Framwork.TestCase {

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
		<section>
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
	</section>
	""";
		
		public void test_menu_manager_new () {
			var shell = new MockShell ();
			var testmm = new MenuManager(shell);
			assert_true (testmm is MenuManager);
		}

		public void test_menu_manager_add_menu () {

			string test_result = """<section>
		<submenu>
			<attribute name="label">_File</attribute>
			<attribute name="id">file-section</attribute>
			<section>
				<attribute name="valarade-merge-id">7</attribute>
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
			<attribute name="label">View</attribute>
			<attribute name="id">view-section</attribute>
			<section>
				<attribute name="id">view-section-plugins</attribute>
			</section>
			<section>
				<attribute name="id">view-section-windows</attribute>
			</section>
		</submenu>
	</section>
	""";
			var shell = new MockShell ();
			var testmm = new MenuManager(shell);

			var menubldrstr = "<interface><menu id=\"menubar\">%s</menu></interface>".printf(this.menubar);
			var menubar_builder = new Gtk.Builder.from_string (menubldrstr, menubldrstr.length);
			var menubar = menubar_builder.get_object ("menubar") as GLib.MenuModel;

			testmm.add_menu (menubar as GLib.Menu);

			var pluginbldrstr = "<interface><menu id=\"plugin\">%s</menu></interface>".printf(this.pluginmenu);
			var plugin_menu_builder = new Gtk.Builder.from_string (pluginbldrstr, pluginbldrstr.length);
			var plugin_menu = plugin_menu_builder.get_object ("plugin") as GLib.MenuModel;

			testmm.add_menu (plugin_menu as GLib.Menu);

			assert_true (iterate_menu (menubar,0) == test_result);
			
			testmm.remove_menu (plugin_menu as GLib.Menu);

			assert_true (iterate_menu (menubar,0) == this.menubar);

		}

		public void test_menu_manager_append_menu () {

			string test_result = """<section>
		<submenu>
			<attribute name="label">_File</attribute>
			<attribute name="id">file-section</attribute>
			<section>
				<attribute name="valarade-merge-id">8</attribute>
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
			<attribute name="label">View</attribute>
			<attribute name="id">view-section</attribute>
			<section>
				<attribute name="id">view-section-plugins</attribute>
			</section>
			<section>
				<attribute name="id">view-section-windows</attribute>
			</section>
		</submenu>
	</section>
	""";
			var shell = new MockShell ();
			var testmm = new MenuManager(shell);

			var menubldrstr = "<interface><menu id=\"menubar\">%s</menu></interface>".printf(this.menubar);
			var menubar_builder = new Gtk.Builder.from_string (menubldrstr, menubldrstr.length);
			var menubar = menubar_builder.get_object ("menubar") as GLib.MenuModel;

			testmm.add_menu (menubar as GLib.Menu);

			var pluginbldrstr = "<interface><menu id=\"plugin\">%s</menu></interface>".printf(this.pluginmenu);
			var plugin_menu_builder = new Gtk.Builder.from_string (pluginbldrstr, pluginbldrstr.length);
			var plugin_menu = plugin_menu_builder.get_object ("plugin") as GLib.MenuModel;

			testmm.append_menu (plugin_menu as GLib.Menu);

			assert_true (iterate_menu (menubar,0) == test_result);
			
			testmm.remove_menu (plugin_menu as GLib.Menu);

			assert_true (iterate_menu (menubar,0) == this.menubar);

		}

		public void test_menu_manager_prepend_menu () {


			string test_item = """
			<section>
				<attribute name="id">view-section-plugins</attribute>
				<section>
					<attribute name="label">Test Section %d</attribute>
				</section>
			</section>
			""";


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
				<section>
					<attribute name="label">Test Section 2</attribute>
					<attribute name="valarade-merge-id">11</attribute>
				</section>
				<section>
					<attribute name="label">Test Section 1</attribute>
					<attribute name="valarade-merge-id">10</attribute>
				</section>
				<section>
					<attribute name="label">Test Section 0</attribute>
					<attribute name="valarade-merge-id">9</attribute>
				</section>
			</section>
			<section>
				<attribute name="id">view-section-windows</attribute>
			</section>
		</submenu>
	</section>
	""";
			var shell = new MockShell ();
			var testmm = new MenuManager(shell);

			var menubldrstr = "<interface><menu id=\"menubar\">%s</menu></interface>".printf(this.menubar);
			var menubar_builder = new Gtk.Builder.from_string (menubldrstr, menubldrstr.length);
			var menubar = menubar_builder.get_object ("menubar") as GLib.MenuModel;

			testmm.add_menu (menubar as GLib.Menu);

			for (int i = 0; i < 3; i++) {
				var testbldrstr = "<interface><menu id=\"test\">%s</menu></interface>".printf(test_item.printf (i));
				var test_builder = new Gtk.Builder.from_string (testbldrstr, testbldrstr.length);
				testmm.prepend_menu (test_builder.get_object ("test") as GLib.Menu);
			}

			assert_true (iterate_menu (menubar,0) == test_result);
			//message (iterate_menu (menubar,0));
		}

		public void test_menu_manager_remove_menu () {

			string test_result = """<section>
		<submenu>
			<attribute name="label">_File</attribute>
			<attribute name="id">file-section</attribute>
			<section>
				<attribute name="valarade-merge-id">12</attribute>
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
			<attribute name="label">View</attribute>
			<attribute name="id">view-section</attribute>
			<section>
				<attribute name="id">view-section-plugins</attribute>
			</section>
			<section>
				<attribute name="id">view-section-windows</attribute>
			</section>
		</submenu>
	</section>
	""";
			var shell = new MockShell ();
			var testmm = new MenuManager(shell);

			var menubldrstr = "<interface><menu id=\"menubar\">%s</menu></interface>".printf(this.menubar);
			var menubar_builder = new Gtk.Builder.from_string (menubldrstr, menubldrstr.length);
			var menubar = menubar_builder.get_object ("menubar") as GLib.MenuModel;

			testmm.add_menu (menubar as GLib.Menu);

			var pluginbldrstr = "<interface><menu id=\"plugin\">%s</menu></interface>".printf(this.pluginmenu);
			var plugin_menu_builder = new Gtk.Builder.from_string (pluginbldrstr, pluginbldrstr.length);
			var plugin_menu = plugin_menu_builder.get_object ("plugin") as GLib.MenuModel;

			testmm.append_menu (plugin_menu as GLib.Menu);

			assert_true (iterate_menu (menubar,0) == test_result);
			
			testmm.remove_menu (plugin_menu as GLib.Menu);

			assert_true (iterate_menu (menubar,0) == this.menubar);

		}

		public void test_menu_manager_get_menu () {

			string test_result = """<section>
		<attribute name="id">view-section-plugins</attribute>
	</section>
	<section>
		<attribute name="id">view-section-windows</attribute>
	</section>
	""";

			var shell = new MockShell ();
			var testmm = new MenuManager(shell);

			var menubldrstr = "<interface><menu id=\"menubar\">%s</menu></interface>".printf(this.menubar);
			var menubar_builder = new Gtk.Builder.from_string (menubldrstr, menubldrstr.length);
			var menubar = menubar_builder.get_object ("menubar") as GLib.MenuModel;

			testmm.add_menu (menubar as GLib.Menu);
			var menu = testmm.get_menu("view-section");
			assert_true(iterate_menu (menu,0) == test_result);

			try {
				menu = testmm.get_menu("menu-does-not-exist");
				assert_not_reached();
			} catch (MenuManagerError e) {
				assert_true(iterate_menu (menu,0) == test_result);
			}

		}


	}
}
