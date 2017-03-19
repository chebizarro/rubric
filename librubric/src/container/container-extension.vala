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
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 */
 
namespace Rubric {

	public interface ContainerExtension : Object {
		public abstract unowned Container container {get;construct set;}
	}

	public interface ResolverExtension : Object, ContainerExtension {
		public abstract T resolve<T>(string? name = null, Parameter[]? params = null) throws ContainerError;
		public abstract Value resolve_type(Type from, string? name = null, Parameter[]? params = null) throws ContainerError;
		public abstract Value resolve_all<T>(Parameter[]? params = null) throws ContainerError;
		public abstract Value resolve_type_all(Type from, Parameter[]? params = null) throws ContainerError;
		
	}

	public interface DecoratorExtension : Object, ContainerExtension {

		public abstract Value decorate(Type from, Value object, string? name = null) throws Error;

		public abstract Value decorate_all(Type from, Value objects) throws Error;
	}

	public interface ResourceHandler : Object, ContainerExtension {
		public abstract bool handles(string filename);
		public abstract void add(string filename, Assembly? assembly = null) throws ContainerError;
	}

}
