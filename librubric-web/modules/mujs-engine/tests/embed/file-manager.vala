namespace TestObjects {

	public class FileManager : Object {

		public string ReadFile(string path) {

			string content;
			
			FileUtils.get_contents(path, out content);

			return content;
		}
	}
}
