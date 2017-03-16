/*
 * Rubric -- a Vala framework for responsive applications
 * Copyright 2016 Chris Daley <bizarro@localhost.localdomain>
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

namespace Rubric.ORM {

	[CCode (has_target = false)]
	public delegate void ResourceFromBytesFunc (GLib.Bytes bytes, GLib.Value value);

	[CCode (has_target = false)]
	public delegate GLib.Bytes ResourceToBytesFunc (GLib.Value value);


	public class RubricResource : Object, Rubric.ORM.Resource {


		internal static GLib.Quark to_bytes_func_quark () {
			return Quark.from_string("rubric_resource_to_bytes_func_quark");
		}

		internal static GLib.Quark from_bytes_func_quark () {
			return Quark.from_string("rubric_resource_from_bytes_func_quark");
		}

		public static void set_primary_key(ObjectClass klass, string primary_key) { 
			var pspec = klass.find_property(primary_key);

			if (pspec == null) {
				warning("Property for primary key '%s' (class %s) isn't declared yet. Are you running set_primary_key() too early?",
					primary_key, klass.get_type().name());
				return;
			}

			if (pspec.flags == pspec.flags & GLib.ParamFlags.CONSTRUCT_ONLY) {
				warning("Property for primary key '%s' (class %s) is declared as construct-only. This will not work as expected.",
					primary_key, klass.get_type().name());
				return;
			}

			var val = pspec.get_default_value();

			if (val.get_pointer() != null) {
				warning("Property for primary key '%s' (class %s) has a non-NULL/non-zero default value. This will not work as expected.",
					primary_key, klass.get_type().name());
				return;
			}
		}

	}
	
}

