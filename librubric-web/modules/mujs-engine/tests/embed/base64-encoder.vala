namespace TestObjects {

	public class Base64Encoder	{

		public const int DATA_URI_MAX = 32768;

		public static string encode(string value) {
			return Base64.encode((uchar[])value.to_utf8());
		}
	}
}
