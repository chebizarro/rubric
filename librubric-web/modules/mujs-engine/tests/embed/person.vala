namespace TestObjects {
	
	public class Person : Object	{

		public string first_name { get;	set; }

		public string last_name	{ get; set; }

		public Person(string firstName, string lastName) {
			first_name = firstName;
			last_name = lastName;
		}

		public string to_string() {
			return "{{first_name=%s,last_name=%s}}".printf(first_name, last_name);
		}
		
	}
}
