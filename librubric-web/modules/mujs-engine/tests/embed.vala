using TestObjects;
using TestObjects.Drawing;

namespace RubricWeb.Mujs.Tests {

	public class EmbededObjects : Valadate.Framework.TestCase {
		
		construct {
			var repo = GI.Repository.get_default();
			repo.prepend_library_path(Environment.get_variable("srcdir"));
			repo.prepend_search_path(Environment.get_current_dir());
			repo.prepend_library_path(Environment.get_current_dir());
			repo.prepend_search_path(Environment.get_variable("srcdir"));
			repo.require("TestObjects", "1.0", 0);
			
		}
		
		
		// Embedding of objects

		// Objects with fields

		public void test_embedding_of_instance_of_custom_value_type_with_fields () {
			// Arrange
			var date = new TestObjects.Date(2017, 01, 28);
			const string updateCode = "date.Day += 1;";

			const string input1 = "date.Year";
			const int targetOutput1 = 2017;

			const string input2 = "date.Month";
			const int targetOutput2 = 1;

			const string input3 = "date.Day";
			const int targetOutput3 = 29;
			var engine = new Engine();

			// Act
			int output1;
			int output2;
			int output3;

			engine.embed_host_object("date", date);
			engine.execute(updateCode);

			output1 = engine.evaluate<int>(input1);
			output2 = engine.evaluate<int>(input2);
			output3 = engine.evaluate<int>(input3);

			// Assert
			debug("%d : %d\n", targetOutput1, output1);
			debug("%d : %d\n", targetOutput2, output2);
			debug("%d : %d\n", targetOutput3, output3);
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
			assert(targetOutput3 == output3);
		}

		public void test_embedding_of_instance_of_custom_reference_type_with_fields () {
			// Arrange
			var product = new Product("Red T-shirt", 995.00);

			const string updateCode = "product.Price *= 1.15;";

			const string input1 = "product.Name";
			const string targetOutput1 = "Red T-shirt";

			const string input2 = "product.Price";
			const double targetOutput2 = 1144.25;
			var engine = new Engine();

			// Act
			string output1;
			double output2;

			engine.embed_host_object("product", product);
			engine.execute(updateCode);

			output1 = engine.evaluate<string>(input1);
			output2 = engine.evaluate<double?>(input2);

			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
		}


		// Objects with properties

		public void _test_embedding_of_instance_of_builtin_value_type_with_properties () {
			/*
			// Arrange
			var timeSpan = new TimeSpan(4840780000000);

			const string input1 = "timeSpan.Days";
			const int targetOutput1 = 5;

			const string input2 = "timeSpan.Hours";
			const int targetOutput2 = 14;

			const string input3 = "timeSpan.Minutes";
			const int targetOutput3 = 27;

			const string input4 = "timeSpan.Seconds";
			const int targetOutput4 = 58;
			var engine = new Engine();

			// Act
			int output1;
			int output2;
			int output3;
			int output4;

			engine.embed_host_object("timeSpan", timeSpan);

			output1 = engine.evaluate<int>(input1);
			output2 = engine.evaluate<int>(input2);
			output3 = engine.evaluate<int>(input3);
			output4 = engine.evaluate<int>(input4);

			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
			assert(targetOutput3 == output3);
			assert(targetOutput4 == output4);
			*/
		}

		public void _test_embedding_of_instance_of_builtin_reference_type_with_properties () {
			/*
			// Arrange
			var uri = new Uri("https://github.com/Taritsyn/MsieJavaScriptEngine");

			const string input1 = "uri.Scheme";
			const string targetOutput1 = "https";

			const string input2 = "uri.Host";
			const string targetOutput2 = "github.com";

			const string input3 = "uri.PathAndQuery";
			const string targetOutput3 = "/Taritsyn/MsieJavaScriptEngine";
			var engine = new Engine();

			// Act
			string output1;
			string output2;
			string output3;

			engine.embed_host_object("uri", uri);

			output1 = engine.evaluate<string>(input1);
			output2 = engine.evaluate<string>(input2);
			output3 = engine.evaluate<string>(input3);

			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
			assert(targetOutput3 == output3);
			*/
		}

		public void test_embedding_of_instance_of_custom_value_type_with_properties () {
			// Arrange
			var temperature = new Temperature(-17.3, TemperatureUnits.Celsius);

			const string input1 = "temperature.Celsius";
			const double targetOutput1 = -17.3;

			const string input2 = "temperature.Kelvin";
			const double targetOutput2 = 255.85;

			const string input3 = "temperature.Fahrenheit";
			const double targetOutput3 = 0.86;
			var engine = new Engine();

			// Act
			double output1;
			double output2;
			double output3;

			engine.embed_host_object("temperature", temperature);

			output1 = Math.round(engine.evaluate<double?>(input1));
			output2 = Math.round(engine.evaluate<double?>(input2));
			output3 = Math.round(engine.evaluate<double?>(input3));

			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
			assert(targetOutput3 == output3);
		}

		public void test_embedding_of_instance_of_custom_reference_type_with_properties () {
			// Arrange
			var person = new Person("Vanya", "Ivanov");
			const string updateCode = "person.LastName = person.LastName.substr(0, 5) + 'ff';";

			const string input1 = "person.FirstName";
			const string targetOutput1 = "Vanya";

			const string input2 = "person.LastName";
			const string targetOutput2 = "Ivanoff";
			var engine = new Engine();

			// Act
			string output1;
			string output2;

			engine.embed_host_object("person", person);
			engine.execute(updateCode);

			output1 = engine.evaluate<string>(input1);
			output2 = engine.evaluate<string>(input2);

			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
		}


		// Objects with methods

		public void test_embedding_of_instance_of_builtin_value_type_with_methods () {
			// Arrange
			var color = Color.FromArgb(84, 139, 212);

			const string input1 = "color.GetHue()";
			const double targetOutput1 = 214.21875;

			const string input2 = "color.GetSaturation()";
			const double targetOutput2 = 0.59813;

			const string input3 = "color.GetBrightness()";
			const double targetOutput3 = 0.58039;
			var engine = new Engine();

			// Act
			double output1;
			double output2;
			double output3;

			engine.embed_host_object("color", color);

			output1 = Math.round(engine.evaluate<double?>(input1));
			output2 = Math.round(engine.evaluate<double?>(input2));
			output3 = Math.round(engine.evaluate<double?>(input3));

			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
			assert(targetOutput3 == output3);
		}

		public void test_embedding_of_instance_of_builtin_reference_type_with_method () {
			// Arrange
			var random = new Rand();

			const string input = "random.Next(1, 3)";
			int[] targetOutput = { 1, 3 };
			var engine = new Engine();

			// Act
			int output;

			engine.embed_host_object("random", random);
			output = engine.evaluate<int>(input);

			// Assert
			assert(output in targetOutput);
		}

		public void test_embedding_of_instance_of_custom_value_type_with_method () {
			// Arrange
			var programmerDayDate = new TestObjects.Date(2015, 9, 13);

			const string input = "programmerDay.GetDayOfYear()";
			const int targetOutput = 256;
			var engine = new Engine();

			// Act
			int output;

			engine.embed_host_object("programmerDay", programmerDayDate);
			output = engine.evaluate<int>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void _test_embedding_of_instance_of_custom_reference_type_with_method () {
			/*
			// Arrange
			var fileManager = new FileManager();
			string filePath = Path.get_dirname(Path.build_path("/", _baseDirectoryPath, "../SharedFiles/link.txt"));

			string input = "fileManager.ReadFile('%s')".printf(filePath.replace("\\", "\\\\"));
			const string targetOutput = "http://www.panopticoncentral.net/2015/09/09/the-two-faces-of-jsrt-in-windows-10/";
			var engine = new Engine();

			// Act
			string output;

			engine.embed_host_object("fileManager", fileManager);
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
			*/
		}


		// Delegates

		public void _test_embedding_of_instance_of_delegate_without_parameters () {
			/*
			// Arrange
			Func<string> generateRandomStringFunc = () => {
				const string symbolString = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
				int symbolStringLength = symbolString.Length;
				Rand randomizer = new Rand();
				string result = string.Empty;

				for (int i = 0; i < 20; i++)
				{
					int randomNumber = randomizer.Next(symbolStringLength);
					string randomSymbol = symbolString.Substring(randomNumber, 1);

					result += randomSymbol;
				}

				return result;
			});

			const string input = "generateRandomString()";
			const int targetOutputLength = 20;
			var engine = new Engine();

			// Act
			string output;

			engine.embed_host_object("generateRandomString", generateRandomStringFunc);
			output = engine.evaluate<string>(input);

			// Assert
			assert(output != null);
			assert(output.length == targetOutputLength);
			*/
		}

		public void _test_embedding_of_instance_of_delegate_with_one_parameter () {
			// Arrange
			/*
			var squareFunc = new Func<int, int>(a => a * a);

			const string input = "square(7)";
			const int targetOutput = 49;
			var engine = new Engine();

			// Act
			int output;

			engine.embed_host_object("square", squareFunc);
			output = engine.evaluate<int>(input);

			// Assert
			assert(targetOutput == output);
			*/
		}

		public void _test_embedding_of_instance_of_delegate_with_two_parameters () {
			/*
			// Arrange
			var sumFunc = new Func<double, double, double>((a, b) => a + b);

			const string input = "sum(3.14, 2.20)";
			const double targetOutput = 5.34;
			var engine = new Engine();

			// Act
			double output;

			engine.embed_host_object("sum", sumFunc);
			output = engine.evaluate<double?>(input);

			// Assert
			assert(targetOutput == output);
			*/
		}


		// Embedding of types

		// Creating of instances

		public void test_creating_an_instance_of_embedded_builtin_value_type () {
			// Arrange
			Type pointType = typeof(Point);

			const string input = "(new Point()).to_string()";
			const string targetOutput = "{X=0,Y=0}";
			var engine = new Engine();

			// Act
			string output;

			engine.embed_host_type<Point>("Point");
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void _test_creating_an_instance_of_embedded_builtin_reference_type () {
			/*
			// Arrange
			Type uriType = typeof(Uri);

			const string input = @"var baseUri = new Uri('https://github.com'),
	relativeUri = 'Taritsyn/MsieJavaScriptEngine'
	;

(new Uri(baseUri, relativeUri)).to_string()";
			const string targetOutput = "https://github.com/Taritsyn/MsieJavaScriptEngine";
			var engine = new Engine();

			// Act
			string output;

			engine.embed_host_type("Uri", uriType);
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
			*/
		}

		public void test_creating_an_instance_of_embedded_custom_value_type () {
			// Arrange
			Type point3DType = typeof(Point3D);

			const string input = "(new Point3D(2, 5, 14)).to_string()";
			const string targetOutput = "{X=2,Y=5,Z=14}";
			var engine = new Engine();

			// Act
			string output;

			engine.embed_host_type<Point3D>("Point3D");
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void test_creating_an_instance_of_embedded_custom_reference_type () {
			// Arrange
			Type personType = typeof(Person);

			const string input = "(new Person('Vanya', 'Tutkin')).to_string()";
			const string targetOutput = "{FirstName=Vanya,LastName=Tutkin}";
			var engine = new Engine();

			// Act
			string output;

			engine.embed_host_type<Person>("Person");
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
		}


		// Types with constants

		public void _test_embedding_of_builtin_reference_type_with_constants () {
			/*
			// Arrange
			Type mathType = typeof(Math);

			const string input1 = "Math2.PI";
			const double targetOutput1 = 3.1415926535897931d;

			const string input2 = "Math2.E";
			const double targetOutput2 = 2.7182818284590451d;
			var engine = new Engine();

			// Act
			double output1;
			double output2;

			engine.embed_host_type("Math2", mathType);

			output1 = engine.evaluate<double?>(input1);
			output2 = engine.evaluate<double?>(input2);

			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
			*/
		}

		public void test_embedding_of_custom_value_type_with_constants () {
			// Arrange
			Type predefinedStringsType = typeof(PredefinedStrings);

			const string input1 = "PredefinedStrings.VeryLongName";
			const string targetOutput1 = "Very Long Name";

			const string input2 = "PredefinedStrings.AnotherVeryLongName";
			const string targetOutput2 = "Another Very Long Name";

			const string input3 = "PredefinedStrings.TheLastVeryLongName";
			const string targetOutput3 = "The Last Very Long Name";
			var engine = new Engine();

			// Act
			string output1;
			string output2;
			string output3;

			engine.embed_host_type<PredefinedStrings>("PredefinedStrings");

			output1 = engine.evaluate<string>(input1);
			output2 = engine.evaluate<string>(input2);
			output3 = engine.evaluate<string>(input3);

			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
			assert(targetOutput3 == output3);
		}

		public void test_embedding_of_custom_reference_type_with_constant () {
			// Arrange
			Type base64EncoderType = typeof(Base64Encoder);

			const string input = "Base64Encoder.DATA_URI_MAX";
			const int targetOutput = 32768;
			var engine = new Engine();

			// Act
			int output;

			engine.embed_host_type<Base64Encoder>("Base64Encoder");
			output = engine.evaluate<int>(input);

			// Assert
			assert(targetOutput == output);
		}


		// Types with fields

		public void _test_embedding_of_builtin_value_type_with_field () {
			/*
			// Arrange
			Type guidType = typeof(Guid);

			const string input = "Guid.Empty.to_string()";
			const string targetOutput = "00000000-0000-0000-0000-000000000000";
			var engine = new Engine();

			// Act
			string output;

			engine.embed_host_type("Guid", guidType);
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
			*/
		}

		public void _test_embedding_of_builtin_reference_type_with_field () {
			/*
			// Arrange
			Type bitConverterType = typeof(BitConverter);

			const string input = "BitConverter.IsLittleEndian";
			const bool targetOutput = true;
			var engine = new Engine();

			// Act
			bool output;

			engine.embed_host_type("BitConverter", bitConverterType);
			output = (bool)engine.evaluate(input);

			// Assert
			assert(targetOutput == output);
			*/
		}

		public void test_embedding_of_custom_value_type_with_field () {
			// Arrange
			Type point3DType = typeof(Point3D);

			const string input = "Point3D.Empty.to_string()";
			const string targetOutput = "{X=0,Y=0,Z=0}";
			var engine = new Engine();

			// Act
			string output;

			engine.embed_host_type<Point3D>("Point3D");
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void test_embedding_of_custom_reference_type_with_field () {
			// Arrange
			Type simpleSingletonType = typeof(SimpleSingleton);

			const string input = "SimpleSingleton.Instance.to_string()";
			const string targetOutput = "[simple singleton]";
			var engine = new Engine();

			// Act
			string output;

			engine.embed_host_type<SimpleSingleton>("SimpleSingleton");
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
		}


		// Types with properties

		public void _test_embedding_of_builtin_value_type_with_property () {
			// Arrange
			/*
			Type colorType = typeof(Color);

			const string input = "Color.OrangeRed.to_string()";
			const string targetOutput = "Color [OrangeRed]";
			var engine = new Engine();

			// Act
			string output;

			engine.embed_host_type<Color>("Color");
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
			*/
		}

		public void _test_embedding_of_builtin_reference_type_with_property () {
			/*
			// Arrange
			Type environmentType = typeof(Environment);

			const string input = "Environment.NewLine";
			string[] targetOutput = { "\r", "\r\n", "\n", "\n\r" };
			var engine = new Engine();

			// Act
			string output;

			engine.embed_host_type("Environment", environmentType);
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput.Contains(output));
			*/
		}

		public void test_embedding_of_custom_value_type_with_property () {
			// Arrange
			Type dateType = typeof(TestObjects.Date);

			const string initCode = "var currentDate = Date2.Today;";

			const string inputYear = "currentDate.Year";
			const string inputMonth = "currentDate.Month";
			const string inputDay = "currentDate.Day";

			DateTime targetOutput = new DateTime.now_local();
			var engine = new Engine();

			// Act
			DateTime output;

			engine.embed_host_type<TestObjects.Date>("Date2");
			engine.execute(initCode);

			var outputYear = engine.evaluate<int>(inputYear);
			var outputMonth = engine.evaluate<int>(inputMonth);
			var outputDay = engine.evaluate<int>(inputDay);

			output = new DateTime.local(outputYear, outputMonth, outputDay, 0, 0, 0);

			// Assert
			assert(targetOutput == output);
		}

		public void _test_embedding_of_custom_reference_type_with_property () {
			/*
			// Arrange
			Type bundleTableType = typeof(BundleTable);
			const string updateCode = "BundleTable.EnableOptimizations = false;";

			const string input = "BundleTable.EnableOptimizations";
			const bool targetOutput = false;
			var engine = new Engine();

			// Act
			bool output;

			engine.embed_host_type("BundleTable", bundleTableType);
			engine.execute(updateCode);

			output = engine.evaluate<bool>(input);

			// Assert
			assert(targetOutput == output);
			*/
		}


		// Types with methods

		public void test_embedding_of_builtin_value_type_with_method () {
			// Arrange
			Type dateTimeType = typeof(DateTime);

			const string input = "DateTime.DaysInMonth(2016, 2)";
			const int targetOutput = 29;
			var engine = new Engine();

			// Act
			int output;

			engine.embed_host_type<DateTime>("DateTime");
			output = engine.evaluate<int>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void _test_embedding_of_builtin_reference_type_with_method () {
			/*
			// Arrange
			Type mathType = typeof(Math);

			const string input = "Math2.Max(5.37, 5.56)";
			const double targetOutput = 5.56;
			var engine = new Engine();

			// Act
			double output;

			engine.embed_host_type("Math2", mathType);
			output = engine.evaluate<double?>(input);

			// Assert
			assert(targetOutput == output);
			*/
		}

		public void test_embedding_of_custom_value_type_with_method () {
			// Arrange
			var dateType = typeof(TestObjects.Date);

			const string input = "Date2.IsLeapYear(2016)";
			const bool targetOutput = true;
			var engine = new Engine();

			// Act
			bool output;

			engine.embed_host_type<TestObjects.Date>("Date2");
			output = engine.evaluate<bool>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void test_embedding_of_custom_reference_type_with_method () {
			// Arrange
			Type base64EncoderType = typeof(Base64Encoder);

			const string input = "Base64Encoder.Encode('https://github.com/Taritsyn/MsieJavaScriptEngine')";
			const string targetOutput = "aHR0cHM6Ly9naXRodWIuY29tL1Rhcml0c3luL01zaWVKYXZhU2NyaXB0RW5naW5l";
			var engine = new Engine();

			// Act
			string output;

			engine.embed_host_type<Base64Encoder>("Base64Encoder");
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
		}


	}
}
