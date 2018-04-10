namespace TestObjects {

	public struct Point3D {

		public int x;
		public int y;
		public int z;

		//public static Point3D empty;

		public Point3D(int x, int y, int z) {
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public string to_string() {
			return "{{x=%d,y=%d,z=%d}}".printf(x, y, z);
		}
	}
}
