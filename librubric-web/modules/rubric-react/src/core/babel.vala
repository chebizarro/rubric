/*
 * Rubric -- a Vala framework for responsive applications
 * Copyright 2017 Chris Daley <bizarro@localhost.localdomain>
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

namespace RubricReact {
	
	public class Babel : Object {

		private const string JSX_CACHE_KEY = "JSX_v3_%s";
		private const string COMPILED_FILE_SUFFIX = ".generated.js";
		private const string SOURCE_MAP_FILE_SUFFIX = ".map";
		private const int LINES_IN_HEADER = 5;	
				
		protected RubricReact.Environment environment;
		
		public string transform_file (string filename) {
			return transform_file_with_source_map(filename, false).code;
		}		
		
		public JavaScriptWithSourceMap transform_file_with_source_map (
			string filename, bool force_generate_source_map = false) {
			
			var cacheKey = JSX_CACHE_KEY.printf(filename);

			return null;
		}
		
		protected JavaScriptWithSourceMap load_from_file_cache (
			string filename, string hash, bool force_generate_source_map) {		

			return null;
		
		}

		protected JavaScriptWithSourceMap transform_with_header (
			string filename, string contents, string hash = null) {	

			return null;
		
		}

		public string transform (string input, string filename = "unknown") {
			return null;
		}

		public JavaScriptWithSourceMap transform_with_source_map (
			string input, string filename = "unknown" ) {
			return null;
		}

		protected string get_file_header (string hash, string babel_version) {
			return null;
		}

		public string get_output_path (string path) {
			return null;
		}

		public string get_source_map_output_path (string path) {
			return get_output_path(path) + SOURCE_MAP_FILE_SUFFIX;
		}

		public string transform_and_save_file (string filename) {
			return null;
		}
	
		public bool cache_is_valid(string input_file_contents, string output_path) {
			return false;
		}

	}
	
}
