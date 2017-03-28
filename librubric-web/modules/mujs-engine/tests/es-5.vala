
namespace RubricWeb.Mujs.Tests {

	public class Es5 : Valadate.Framework.TestCase {
	
		// Array methods

		public void test_array_every_method_is_supported() {
			// Arrange
			const string initCode = "var engines = ['Chakra', 'V8', 'SpiderMonkey', 'Jurassic'];";

			const string input1 = "engines.every(function (value, index, array) { return value.length > 1; });";
			const bool targetOutput1 = true;

			const string input2 = "engines.every(function (value, index, array) { return value.length < 10; });";
			const bool targetOutput2 = false;

			var engine = new Engine();

			// Act
			bool output1;
			bool output2;

			engine.execute(initCode);

			output1 = engine.evaluate<bool>(input1);
			output2 = engine.evaluate<bool>(input2);

			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
		}

		public void test_array_filter_method_is_supported() {
			// Arrange
			const string initCode = "var engines = ['Chakra', 'V8', 'SpiderMonkey', 'Jurassic'];";
			const string input = @"engines
	.filter(
		function (value, index, array) {
			return value.length > 5;
		})
	.toString();";
			const string targetOutput = "Chakra,SpiderMonkey,Jurassic";

			var engine = new Engine();

			// Act
			string output;

			engine.execute(initCode);
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void test_array_for_each_method_is_supported() {
			// Arrange
			const string resultVariableName = "enginesString";
			string initCode = """var engines = ['Chakra', 'V8', 'SpiderMonkey', 'Jurassic'],
	%s = ''
	;

engines.forEach(function(value, index, array) {{
	if (index > 0) {{
		%s += ';';
	}}
	%s += value;
}});""";
			initCode = initCode.printf(resultVariableName, resultVariableName, resultVariableName);
			const string targetOutput = "Chakra;V8;SpiderMonkey;Jurassic";

			var engine = new Engine();

			// Act
			string output;
			engine.execute(initCode);
			output = engine.get_variable<string>(resultVariableName);

			// Assert
			assert(targetOutput == output);
		}

		public void test_array_index_of_method_is_supported() {
			// Arrange
			const string initCode = "var arr = [2, 5, 9, 2]";

			const string input1 = "arr.indexOf(2);";
			const int targetOutput1 = 0;

			const string input2 = "arr.indexOf(7);";
			const int targetOutput2 = -1;

			const string input3 = "arr.indexOf(2, 3)";
			const int targetOutput3 = 3;

			const string input4 = "arr.indexOf(2, 2);";
			const int targetOutput4 = 3;

			const string input5 = "arr.indexOf(2, -2);";
			const int targetOutput5 = 3;

			const string input6 = "arr.indexOf(2, -1);";
			const int targetOutput6 = 3;

			const string input7 = "[].lastIndexOf(2, 0);";
			const int targetOutput7 = -1;

			var engine = new Engine();

			// Act
			int output1;
			int output2;
			int output3;
			int output4;
			int output5;
			int output6;
			int output7;


			engine.execute(initCode);

			output1 = engine.evaluate<int>(input1);
			output2 = engine.evaluate<int>(input2);
			output3 = engine.evaluate<int>(input3);
			output4 = engine.evaluate<int>(input4);
			output5 = engine.evaluate<int>(input5);
			output6 = engine.evaluate<int>(input6);
			output7 = engine.evaluate<int>(input7);

			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
			assert(targetOutput3 == output3);
			assert(targetOutput4 == output4);
			assert(targetOutput5 == output5);
			assert(targetOutput6 == output6);
			assert(targetOutput7 == output7);
		}

		public void test_array_is_array_method_is_supported() {
			// Arrange
			const string input1 = "Array.isArray({ length: 0 });";
			const bool targetOutput1 = false;

			const string input2 = "Array.isArray([1, 2, 3, 4, 5]);";
			const bool targetOutput2 = true;

			var engine = new Engine();

			// Act
			bool output1;
			bool output2;


			output1 = engine.evaluate<bool>(input1);
			output2 = engine.evaluate<bool>(input2);
			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
		}

		public void test_array_last_index_of_method_is_supported() {
			// Arrange
			const string initCode = "var arr = [2, 5, 9, 2]";

			const string input1 = "arr.lastIndexOf(2);";
			const int targetOutput1 = 3;

			const string input2 = "arr.lastIndexOf(7);";
			const int targetOutput2 = -1;

			const string input3 = "arr.lastIndexOf(2, 3)";
			const int targetOutput3 = 3;

			const string input4 = "arr.lastIndexOf(2, 2);";
			const int targetOutput4 = 0;

			const string input5 = "arr.lastIndexOf(2, -2);";
			const int targetOutput5 = 0;

			const string input6 = "arr.lastIndexOf(2, -1);";
			const int targetOutput6 = 3;

			const string input7 = "[].lastIndexOf(2, 0);";
			const int targetOutput7 = -1;

			var engine = new Engine();

			// Act
			int output1;
			int output2;
			int output3;
			int output4;
			int output5;
			int output6;
			int output7;

			engine.execute(initCode);

			output1 = engine.evaluate<int>(input1);
			output2 = engine.evaluate<int>(input2);
			output3 = engine.evaluate<int>(input3);
			output4 = engine.evaluate<int>(input4);
			output5 = engine.evaluate<int>(input5);
			output6 = engine.evaluate<int>(input6);
			output7 = engine.evaluate<int>(input7);
			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
			assert(targetOutput3 == output3);
			assert(targetOutput4 == output4);
			assert(targetOutput5 == output5);
			assert(targetOutput6 == output6);
			assert(targetOutput7 == output7);
		}

		public void test_array_map_method_is_supported() {
			// Arrange
			const string initCode = "var engines = ['Chakra', 'V8', 'SpiderMonkey', 'Jurassic'];";
			const string input = @"engines
	.map(
		function (value, index, array) {
			return value + ' JS Engine';
		})
	.toString();";
			const string targetOutput = "Chakra JS Engine,V8 JS Engine,SpiderMonkey JS Engine,Jurassic JS Engine";

			var engine = new Engine();

			// Act
			string output;
			engine.execute(initCode);
			output = engine.evaluate<string>(input);
			// Assert
			assert(targetOutput == output);
		}

		public void test_array_reduce_method_is_supported() {
			// Arrange
			const string input1 = @"[1, 2, 3, 4, 5].reduce(function (accum, value, index, array) {
	return accum + value;
});";
			const int targetOutput1 = 15;

			const string input2 = @"[1, 2, 3, 4, 5].reduce(function (accum, value, index, array) {
	return accum + value;
}, 3);";
			const int targetOutput2 = 18;

			var engine = new Engine();

			// Act
			int output1;
			int output2;

			output1 = engine.evaluate<int>(input1);
			output2 = engine.evaluate<int>(input2);
			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
		}

		public void test_array_reduce_right_method_is_supported() {
			// Arrange
			const string input1 = @"[1, 2, 3, 4, 5].reduceRight(function (accum, value, index, array) {
	return accum - value;
});";
			const int targetOutput1 = -5;

			const string input2 = @"[1, 2, 3, 4, 5].reduceRight(function (accum, value, index, array) {
	return accum - value;
}, 7);";
			const int targetOutput2 = -8;

			var engine = new Engine();

			// Act
			int output1;
			int output2;

			output1 = engine.evaluate<int>(input1);
			output2 = engine.evaluate<int>(input2);
			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
		}

		public void test_array_some_method_is_supported() {
			// Arrange
			const string initCode = "var engines = ['Chakra', 'V8', 'SpiderMonkey', 'Jurassic'];";

			const string input = "engines.some(function (value, index, array) { return value.length < 10; });";
			const bool targetOutput = true;

			var engine = new Engine();

			// Act
			bool output;
			engine.execute(initCode);
			output = engine.evaluate<bool>(input);
			// Assert
			assert(targetOutput == output);
		}


		// Date methods

		public void _test_date_now_method_is_supported() {
			// Arrange
			const string input = "Date.now();";
			DateTime targetOutput = new DateTime.now_utc();

			var engine = new Engine();

			// Act
			DateTime output = new DateTime.utc(1970, 01, 01, 0, 0, 0);
			output = output.add_seconds(Math.fabs(engine.evaluate<double?>(input)));
			
			// Assert
			debug("%s", output.to_string());
			assert(Math.fabs(targetOutput.difference(output)) < 1000);
		}

		public void test_date_to_iso_string_method_is_supported() {
			// Arrange
			const string input = @"(new Date(1386696984000)).toISOString();";
			const string targetOutput = "2013-12-10T17:36:24.000Z";

			var engine = new Engine();

			// Act
			string output;
			output = engine.evaluate<string>(input);
			// Assert
			assert(targetOutput == output);
		}


		// Function methods

		public void test_function_bind_is_supported() {
			// Arrange
			const string initCode = @"var a = 5,
	module = {
		a: 12,
		getA: function() { return this.a; }
	},
	getA = module.getA
	;";

			const string input1 = "getA();";
			const int targetOutput1 = 5;

			const string input2 = "getA.bind(module)();";
			const int targetOutput2 = 12;

			var engine = new Engine();

			// Act
			int output1;
			int output2;
			engine.execute(initCode);

			output1 = engine.evaluate<int>(input1);
			output2 = engine.evaluate<int>(input2);
			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
		}


		// JSON methods

		public void test_json_parse_method_is_supported() {
			// Arrange
			const string initCode = "var obj = JSON.parse('{ \"foo\": \"bar\" }');";
			const string input = "obj.foo;";
			const string targetOutput = "bar";

			var engine = new Engine();

			// Act
			string output;


			engine.execute(initCode);
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void test_json_stringify_method_is_supported() {
			// Arrange
			const string initCode = @"var obj = new Object();
obj['foo'] = 'bar';";
			const string input = "JSON.stringify(obj);";
			const string targetOutput = "{\"foo\":\"bar\"}";

			var engine = new Engine();

			// Act
			string output;
			engine.execute(initCode);
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
		}


		// Object methods

		public void test_object_create_method_is_supported() {
			// Arrange
			const string initCode1 = "var obj1 = Object.create(null);";
			const string input1 = "obj1.prototype";
			RubricWeb.Undefined targetOutput1 = RubricWeb.Undefined.value();

			const string initCode2 = "var obj2 = Object.create(Object.prototype);";
			const string input2 = "typeof obj2;";
			const string targetOutput2 = "object";

			const string initCode3 = @"var greeter = {
	id: 678,
	name: 'stranger',
	greet: function() {
		return 'Hello, ' + this.name + '!';
	}
};

var myGreeter = Object.create(greeter);
greeter.name = 'Vasya'";
			const string input3A = "myGreeter.id";
			const string input3B = "myGreeter.greet()";

			const int targetOutput3A = 678;
			const string targetOutput3B = "Hello, Vasya!";

			var engine = new Engine();

			// Act
			RubricWeb.Undefined output1;
			string output2;
			int output3A;
			string output3B;

			engine.execute(initCode1);
			output1 = engine.evaluate<RubricWeb.Undefined>(input1);

			engine.execute(initCode2);
			output2 = engine.evaluate<string>(input2);

			engine.execute(initCode3);
			output3A = engine.evaluate<int>(input3A);
			output3B = engine.evaluate<string>(input3B);

			// Assert
			//assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);

			assert(targetOutput3A == output3A);
			assert(targetOutput3B == output3B);
		}

		public void test_object_keys_method_is_supported() {
			// Arrange
			const string input1 = "Object.keys(['a', 'b', 'c']).toString();";
			const string targetOutput1 = "0,1,2";

			const string input2 = "Object.keys({ 0: 'a', 1: 'b', 2: 'c' }).toString();";
			const string targetOutput2 = "0,1,2";

			const string input3 = "Object.keys({ 100: 'a', 2: 'b', 7: 'c' }).toString();";
			const string targetOutput3 = "100,2,7";

			const string initCode4 = @"var myObj = function() { };
myObj.prototype = { getFoo: { value: function () { return this.foo } } };;
myObj.foo = 1;
";
			const string input4 = "Object.keys(myObj).toString();";
			const string targetOutput4 = "foo";

			var engine = new Engine();

			// Act
			string output1;
			string output2;
			string output3;
			string output4;
			output1 = engine.evaluate<string>(input1);
			output2 = engine.evaluate<string>(input2);
			output3 = engine.evaluate<string>(input3);

			engine.execute(initCode4);
			output4 = engine.evaluate<string>(input4);

			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
			//debug("%s:%s", targetOutput4,output4);
			assert(targetOutput3 == output3);
			//assert(targetOutput4 == output4);
		}


		// String methods

		public void test_string_split_method() {
			// Arrange
			const string input1 = "'aaaa'.split('a').length;";
			const int targetOutput1 = 5;

			const string input2 = "'|a|b|c|'.split('|').length";
			const int targetOutput2 = 5;

			const string input3 = "'1, 2, 3, 4'.split(/\\s*(,)\\s*/).length";
			const int targetOutput3 = 7;

			var engine = new Engine();

			// Act
			int output1;
			int output2;
			int output3;
			output1 = engine.evaluate<int>(input1);
			output2 = engine.evaluate<int>(input2);
			output3 = engine.evaluate<int>(input3);

			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
			assert(targetOutput3 == output3);
		}

		public void test_string_trim_method_is_supported() {
			// Arrange
			const string input = "'	foo '.trim();";
			const string targetOutput = "foo";

			var engine = new Engine();

			// Act
			string output;
			output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
		}

	}
}
