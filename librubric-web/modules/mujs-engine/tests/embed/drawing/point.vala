namespace TestObjects.Drawing {

	public struct Point	{
		//int _x;
		//int _y;

		//public static Point empty;

		public int x { get; set; }

		public int y  { get; set; }

		public bool is_empty {
			get	{
				if (x == 0 && y == 0)
					return true;
				return false;
			}
		}

		public Point(int x, int y) {
			this.x = x;
			this.y = y;
		}

		public string to_string() {
			return "{x=" + x.to_string() +
				",y=" + y.to_string() + "}";
		}
	}
}
