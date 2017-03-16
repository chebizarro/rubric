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

namespace GladeCataloger {

	private Xml.XPath.Context cntx;
	private List<Class> classes;
	private Xml.Doc* doc;
	
	public class Class {
		
		public string name {get;set;}
		public string generic_name {get;set;}
		public string title {get;set;}
		public string parent {get;set;}
		public bool top_level {get;set;default=false;}
		
		public Class(string name, string generic_name, string title) {
			this.name = name;
			this.generic_name = generic_name;
			this.title = title;
		}
		
		public string to_xml() {
			var result = "\t\t<glade-widget-class name=\"%s\" generic-name=\"%s\" title=\"%s\" ".printf(name, generic_name, title);
			result += (top_level) ? " top-level=\"True\"" : " parent=\"%s\"".printf(parent);
			result += "/>\n";
			return result;
		}
		
	}
	
	private string camel_to_snake(string input) {
		
		var reg = new Regex("[A-Z]+");
		string res = "";
		
		MatchInfo info;
		
		reg.match_all_full(input, input.length, 0, RegexMatchFlags.NOTBOL, out info);
		
		for(int i=0; i<info.get_match_count(); i++) {
			string word = info.fetch(i);
			res += "_" + word;
			//info.next();
		}
		return res;
	}
	
	public string get_name(string xpath, string propname = "name") {
		Xml.XPath.Object* res = cntx.eval_expression (xpath);
		Xml.Node* node = res->nodesetval->item (0);
		string name = node->get_prop(propname);
		delete res;
		return name;
	}
	
	private void get_classes() {
		Xml.XPath.Object* res = cntx.eval_expression ("//xmlns:class");

		for (int i = 0; i < res->nodesetval->length (); i++) {
			Xml.Node* node = res->nodesetval->item (i);
			
			if (node->get_prop("abstract") == "1")
				continue;
			
			var title = node->get_prop("name");
			var name = node->get_prop("type");
			var generic_name = title; //camel_to_snake(title);
			var xpath = "//xmlns:class[@name='%s']/xmlns:field[@name='parent_instance']/xmlns:type".printf(title);
			var parent = get_name(xpath, "type");

			var cls = new Class(name, generic_name, title);

			if (parent != "GObject")
				cls.parent = parent;
			else
				cls.top_level = true;
			
			classes.append(cls);
		}
		delete res;
	}

	private bool setup_context(string file) {
		doc = Xml.Parser.parse_file (file);
		if (doc == null) {
			return false;
		}
		cntx = new Xml.XPath.Context (doc);
		cntx.register_ns("xmlns", "http://www.gtk.org/introspection/core/1.0");
		cntx.register_ns("c", "http://www.gtk.org/introspection/c/1.0");
		cntx.register_ns("glib", "http://www.gtk.org/introspection/glib/1.0");
		return true;
	}
	
	public static int main(string[] args) {
		
		if (args.length < 2) {
			warning("glade-cataloger requires at least one input file");
			return 1;
		}
		
		var dir = Environment.get_current_dir();
		var filename = "%s%s%s".printf(dir, Path.DIR_SEPARATOR_S, args[1]);
		
		if(!setup_context(filename)) {
			stdout.printf ("File %s not found\n", filename);
			return 0;
		}

		var pkg = get_name("//xmlns:package");
		var ns = get_name("//xmlns:namespace");

		var header = "<glade-catalog name=\"%s\" library=\"lib%s.so\" depends=\"gtk+\">".printf(pkg, pkg);
		var grpname = "\t<glade-widget-group name=\"%s-widgets\" title=\"%s Widgets\">".printf(pkg, ns);

		classes = new List<Class>();
		get_classes();

		var filedata = "%s\n".printf(header);
		filedata += "\t<glade-widget-classes>\n";
		foreach(var cls in classes)
			filedata += cls.to_xml();
		filedata += "\t</glade-widget-classes>\n";
		filedata += "\n";
		filedata += "%s\n".printf (grpname);
		foreach(var cls in classes)
			filedata += "\t\t<glade-widget-class-ref name=\"%s\" />\n".printf (cls.name);
		filedata += "\t</glade-widget-group>\n";
		filedata += "</glade-catalog>\n";

		var newfilename = "%s%s%s-glade-catalog.xml".printf(dir, Path.DIR_SEPARATOR_S, pkg);
		File file = File.new_for_path(newfilename);
		try {
			if(file.query_exists())
				file.delete();
			FileOutputStream os = file.create (FileCreateFlags.NONE);
			os.write (filedata.data);
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
		}
		
		delete doc;
		return 0;
		
	}
	
	
}
