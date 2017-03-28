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
using Rubric.PM;
using Rubric.Regions;
using RubricWeb.Regions;

namespace RubricWeb.PM {
	
	public abstract class HTMLView : Object, View {

		public string name {get;set;}
	
		public Container container {get;construct set;} 

		public Rubric.PM.ViewModel view_model {get;set;}

		public Rubric.Regions.RegionManager region_manager {get;construct set;}

	}


	public abstract class HTMLElement : Object {

		private static Xml.Ns* ns = new Xml.Ns(null, "http://www.w3.org/1999/xhtml", "xmlns");

		public enum TextDirection {
			LTR,
			RTL,
			AUTO
		}

		public string name {get;set;}

		protected Xml.Node* node;
		
		public string[] accesskey {get;set;}

		public string[] class {get;set;}

		public bool contenteditable {get;set;}

		public TextDirection dir {get;set;}

		public bool hidden {get;set;}

		public string id {get;set;}

		public string lang {get;set;}

		public bool spellcheck {get;set;}

		public string style {get;set;}

		public int? tabindex {get;set;}

		public string? title {get;set;}

		public bool translate {get;set;}
		
		public HTMLElement(string name) {
			this.name = name;
			node = new Xml.Node(ns, name);
		}
		
		public HTMLElement.from_node(Xml.Node* node) {
			this.node = node;
			this.name = node->name;
		}
		
	}

	
}
