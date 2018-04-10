namespace TestObjects {

	public struct Temperature {

		double _celsius;

		public double Celsius {
			get	{
				return _celsius;
			}
			set	{
				_celsius = value;
			}
		}

		public double Kelvin {
			get	{
				return _celsius + 273.15;
			}
			set	{
				_celsius = value - 273.15;
			}
		}

		public double Fahrenheit {
			get {
				return 9 * _celsius / 5 + 32;
			}
			set	{
				_celsius = 5 * (value - 32) / 9;
			}
		}

		public Temperature(double degree, TemperatureUnits units) {
			_celsius = 0;

			switch (units) {
				case TemperatureUnits.Celsius:
					Celsius = degree;
					break;
				case TemperatureUnits.Kelvin:
					Kelvin = degree;
					break;
				case TemperatureUnits.Fahrenheit:
					Fahrenheit = degree;
					break;
				default:
					break;
					//throw new NotSupportedException();
			}
		}

		public string to_string() {
			return to_string_with_units(TemperatureUnits.Celsius);
		}

		public string to_string_with_units(TemperatureUnits units) {
			string formattedValue;

			switch (units)
			{
				case TemperatureUnits.Celsius:
					formattedValue = "%f\u00B0 C".printf(Celsius);
					break;
				case TemperatureUnits.Kelvin:
					formattedValue = "%f\u00B0 K".printf(Kelvin);
					break;
				case TemperatureUnits.Fahrenheit:
					formattedValue = "%f\u00B0 F".printf(Fahrenheit);
					break;
				default:
					formattedValue = "";
					break;
			}

			return formattedValue;
		}
	}

	public enum TemperatureUnits {
		Celsius,
		Kelvin,
		Fahrenheit
	}
}
