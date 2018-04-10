namespace TestObjects {

	public struct Date {

		private const int[] _cumulativeDays = { 0, 31, 59, 90, 120, 151, 181,
			212, 243, 273, 304, 334 };

		public int Year;
		public int Month;
		public int Day;

		public static Date Today {
			owned get {
				DateTime currentDateTime = new DateTime.now_local();
				Date currentDate = new Date(currentDateTime.get_year(), currentDateTime.get_month(), currentDateTime.get_day_of_month());
				return currentDate;
			}
		}

		public Date(int year, int month, int day) {
			Year = year;
			Month = month;
			Day = day;
		}


		public static bool IsLeapYear(int year) {
			return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
		}

		public int GetDayOfYear() {
			return _cumulativeDays[Month - 1] +
				Day + (Month > 2 && IsLeapYear(Year) ? 1 : 0);
		}
	}
}
