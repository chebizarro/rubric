namespace TestObjects.Drawing {

	public enum KnownColor {
		ORANGE_RED = 128
	}


	public struct Color	{

		string name;
		long value;
		short knownColor;
		short state;

		const short StateKnownColorValid = 1;
		const short StateARGBValueValid = 2;
		const short StateValueMask = StateARGBValueValid;
		const short StateNameValid = 8;
		const long NotDefinedValue = 0L;

		//public static Color Empty; // = Color();

		public bool IsKnownColor {
			get	{
				return ((uint)state & (uint)StateKnownColorValid) > 0U;
			}
		}

		public string Name {
			owned get	{
				if ((state & StateNameValid) != 0)
					return name;

				if (IsKnownColor) {
					var kc = (KnownColor)knownColor;
					return KnownColorTable.KnownColorToName(kc) ?? kc.to_string();
				}

				return "%16l".printf(value);
			}
		}

		private long Value {
			get	{
				if ((state & StateValueMask) != 0)
					return value;

				if (IsKnownColor) {
					var knownColor = (KnownColor)knownColor;
					return KnownColorTable.KnownColorToArgb(knownColor);
				}

				return NotDefinedValue;
			}
		}

		public static Color OrangeRed {
			owned get	{
				return new Color.known_color(KnownColor.ORANGE_RED);
			}
		}

		public uint8 R {
			get	{
				return (uint8)((ulong)(Value >> 16) & uint8.MAX);
			}
		}

		public uint8 G {
			get {
				return (uint8)((ulong)(Value >> 8) & uint8.MAX);
			}
		}

		public uint8 B {
			get	{
				return (uint8)((ulong)Value & uint8.MAX);
			}
		}

		public uint8 A {
			get	{
				return (uint8)((ulong)(Value >> 24) & uint8.MAX);
			}
		}


		internal Color.known_color(KnownColor knownColor) {
			value = 0L;
			state = StateKnownColorValid;
			name = null;
			this.knownColor = (short)knownColor;
		}

		private Color(long value, short state, string name, KnownColor knownColor) {
			this.value = value;
			this.state = state;
			this.name = name;
			this.knownColor = (short)knownColor;
		}


		private static void CheckByte(int value, string name)
			requires (value >= 0 && value <= uint8.MAX) {
		}

		private static long MakeArgb(uint8 alpha, uint8 red, uint8 green, uint8 blue) {
			return (uint)(red << 16 | green << 8 | blue | alpha << 24) & (long)uint.MAX;
		}

		public static Color FromArgb(int red, int green, int blue, int alpha = uint8.MAX) {
			CheckByte(alpha, "alpha");
			CheckByte(red, "red");
			CheckByte(green, "green");
			CheckByte(blue, "blue");

			return new Color(MakeArgb((uint8)alpha, (uint8)red, (uint8)green, (uint8)blue),
				StateARGBValueValid, null, 0);
		}

		public float GetBrightness() {
			double num1 = R / (double)uint8.MAX;
			float num2 = G / (float)uint8.MAX;
			float num3 = B / (float)uint8.MAX;
			float num4 = (float)num1;
			float num5 = (float)num1;
			if (num2 > num4)
				num4 = num2;
			if (num3 > num4)
				num4 = num3;
			if (num2 < num5)
				num5 = num2;
			if (num3 < num5)
				num5 = num3;
			return (float)((num4 + num5) / 2.0);
		}

		public float GetHue() {
			if (R == G && G == B)
				return 0.0f;

			float num1 = R / (float)uint8.MAX;
			float num2 = G / (float)uint8.MAX;
			float num3 = B / (float)uint8.MAX;
			float num4 = 0.0f;
			float num5 = num1;
			float num6 = num1;
			if (num2 > num5)
				num5 = num2;
			if (num3 > num5)
				num5 = num3;
			if (num2 < num6)
				num6 = num2;
			if (num3 < num6)
				num6 = num3;
			float num7 = num5 - num6;
			if (num1 == num5)
				num4 = (num2 - num3)/num7;
			else if (num2 == num5)
				num4 = (float)(2.0 + (num3 - num1) / num7);
			else if (num3 == num5)
				num4 = (float)(4.0 + (num1 - num2) / (double)num7);
			float num8 = num4 * 60f;
			if (num8 < 0.0)
				num8 += 360f;
			return num8;
		}

		public float GetSaturation() {
			double num1 = R / (double)uint8.MAX;
			float num2 = G / (float)uint8.MAX;
			float num3 = B / (float)uint8.MAX;
			float num4 = 0.0f;
			float num5 = (float)num1;
			float num6 = (float)num1;
			if (num2 > num5)
				num5 = num2;
			if (num3 > num5)
				num5 = num3;
			if (num2 < num6)
				num6 = num2;
			if (num3 < num6)
				num6 = num3;
			if (num5 != num6) {
				num4 = (num5 + num6) / 2.0 > 0.5 ?
					(float)((num5 -num6) / (2.0 - num5 - num6))
					:
					(num5 - num6) / (num5 + num6)
					;
			}
			return num4;
		}

		public string to_string() {

			var sb = new StringBuilder.sized(32);
			sb.append(typeof(Color).name());
			sb.append(" [");
			if ((state & StateNameValid) != 0)
				sb.append(Name);
			else if ((state & StateKnownColorValid) != 0)
				sb.append(Name);
			else if ((state & StateValueMask) != 0) {
				sb.append("A=");
				sb.append_c((char)A);
				sb.append(", R=");
				sb.append_c((char)R);
				sb.append(", G=");
				sb.append_c((char)G);
				sb.append(", B=");
				sb.append_c((char)B);
			} else {
				sb.append("Empty");
			}
			sb.append("]");

			return sb.str;
		}
	}
}
