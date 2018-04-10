namespace TestObjects.Drawing {

	internal class KnownColorTable	{

		public static int KnownColorToArgb(KnownColor color) {
			if (color == KnownColor.ORANGE_RED)
				return -1286;
			return 0;
		}

		public static string KnownColorToName(KnownColor color)	{
			if (color == KnownColor.ORANGE_RED)
				return "OrangeRed";
			return null;
		}
	}
}
