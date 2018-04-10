namespace TestObjects {

	public class SimpleSingleton : Object {

		public static SimpleSingleton Instance = new SimpleSingleton();

		private SimpleSingleton() { }

		public string to_string() {
			return "[simple singleton]";
		}
	}
}
