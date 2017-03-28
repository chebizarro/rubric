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
 */

namespace Rubric {

	public errordomain XmlFileError {
		ERROR
	}

	public class XmlFile {
		
		private Xml.Doc* document;
		private Xml.XPath.Context context;
		private Xml.XPath.Object* result;

		public int size {
			get {
				if(result == null || result->type != Xml.XPath.ObjectType.NODESET || result->nodesetval == null)
					return 0;
				return result->nodesetval->length();
			}
		}
		
		public XmlFile(string path) throws Error {
			document = Xml.Parser.parse_file(path);

			if (document == null)
				throw new XmlFileError.ERROR(
					"There was an error parsing the file at %s", path);

			context = new Xml.XPath.Context (document);
		}

		public XmlFile.from_resource(string path) throws Error {

			var resource = resources_lookup_data(path, 0);
			var data = resource.get_data();
			document = Xml.Parser.parse_memory ((string)data, data.length);

			if (document == null)
				throw new XmlFileError.ERROR(
					"There was an error parsing the file at %s", path);

			context = new Xml.XPath.Context (document);
		}
		
		public void register_ns(string prefix, string ns) {
			context.register_ns(prefix, ns);
		}

		public XmlFile eval(string expression) {

			if(result != null) delete result;

			result = context.eval_expression (expression);

			return this;
		}

		public Xml.Node* get(int i)
			requires(size > 0)
			requires(i < size)
			requires(i >= 0)
		{
			return result->nodesetval->item (i);
		}
		
		~XmlFile() {
			delete document;
			if(result != null) delete result;
		}
		
		
	}


}
