
namespace RubricWebV8.Tests {

	public class V8JSEngine : Valadate.Framework.TestCase {

		public void test_new_engine() {

			var engine = new Engine();

			assert(engine is RubricWebV8.Engine);
			
		}

		public void test_eval_expression_null_result() {
			// Arrange
			string input = "null";
			var engine = new Engine();

			// Act
			var output = engine.evaluate<void*>(input);

			// Assert
			assert(output == null);
		}

		public void test_eval_expression_bool_result() {
			// Arrange
			string input1 = "7 > 5";
			bool targetOutput1 = true;

			string input2 = "null === undefined";
			bool targetOutput2 = false;

			var engine = new Engine();

			// Act
			var output1 = engine.evaluate<bool>(input1);
			var output2 = engine.evaluate<bool>(input2);
			
			// Assert
			assert(targetOutput1 == output1);
			assert(targetOutput2 == output2);
		}

		public void test_eval_expression_integer_result() {
			// Arrange
			string input = "7 * 8 - 20";
			int targetOutput = 36;

			var engine = new Engine();

			// Act
			var output = engine.evaluate<int>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void test_eval_expression_double_result() {
			// Arrange
			string input = "Math.PI + 0.22";
			double targetOutput = Math.PI + 0.22;
			var engine = new Engine();

			// Act
			var output = engine.evaluate<double?>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void test_eval_expression_string_result() {
			// Arrange
			const string input = "'Hello, ' + \"Sup\" + '?';";
			const string targetOutput = "Hello, Sup?";
			var engine = new Engine();

			// Act
			string output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void test_eval_expression_unicode_string_result() {
			// Arrange
			const string input = "'Привет, ' + \"Вася\" + '?';";
			const string targetOutput = "Привет, Вася?";
			var engine = new Engine();

			// Act
			string output = engine.evaluate<string>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void test_execution_of_code() {
			// Arrange
			const string functionCode = @"function add(num1, num2) {
				return (num1 + num2);
			}";
			const string input = "add(7, 9);";
			const int targetOutput = 16;
			var engine = new Engine();

			// Act
			engine.execute(functionCode);
			var output = engine.evaluate<int>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void test_execution_of_file() {
			// Arrange
			string filePath = Environment.get_variable("srcdir") + "/data/square.js";
			const string input = "square(6);";
			const int targetOutput = 36;
			var engine = new Engine();

			// Act
			engine.execute_file(filePath);
			var output = engine.evaluate<int>(input);

			// Assert
			assert(targetOutput == output);
		}

		public void test_calling_of_function_without_parameters() {
			// Arrange
			const string functionCode = @"function hooray() {
	return 'Hooray!';
}";
			const string targetOutput = "Hooray!";
			var engine = new Engine();

			// Act
			engine.execute(functionCode);
			var output = engine.call_function<string>("hooray");

			// Assert
			assert(targetOutput == output);
		}

		public void test_calling_of_function_with_undefined_result() {
			// Arrange
			const string functionCode = @"function testUndefined(value) {
	if (typeof value !== 'undefined') {
		throw new TypeError();
	}
	return undefined;
}";
			var input = RubricWeb.Undefined.value();
			var engine = new Engine();

			engine.execute(functionCode);
			var output = engine.call_function<RubricWeb.Undefined>("testUndefined", { input });

			// Assert
			assert(input == output);
		}

		public void test_calling_of_function_with_null_result() {
			// Arrange
			const string functionCode = @"function testNull(value) {
	if (value !== null) {
		throw new TypeError();
	}
	return null;
}";
			void* input = null;
			var engine = new Engine();

			// Act
			void* output;

			engine.execute(functionCode);
			output = engine.call_function<void*>("testNull", { null });

			// Assert
			assert(output == null);
		}

		public void test_calling_of_function_with_boolean_result() {
			// Arrange
			const string functionCode = @"function inverse(value) {
	return !value;
}";
			const bool input = false;
			const bool targetOutput = true;
			var engine = new Engine();

			// Act
			engine.execute(functionCode);
			bool output = engine.call_function<bool>("inverse", { input });

			// Assert
			assert(targetOutput == output);
		}

		public void test_calling_of_function_with_integer_result() {

			// Arrange
			const string functionCode = @"function negate(value) {
	return -1 * value;
}";
			const int input = 28;
			const int targetOutput = -28;
			var engine = new Engine();

			// Act
			engine.execute(functionCode);
			int output = engine.call_function<int>("negate", { input });

			// Assert
			assert(targetOutput == output);
		}

		public void test_calling_of_function_with_double_result() {

			// Arrange
			const string functionCode = @"function triple(value) {
	return 3 * value;
}";
			const double input = 3.2;
			const double targetOutput = 9.6;
			var engine = new Engine();

			// Act

			engine.execute(functionCode);
			var output = Math.round(engine.call_function<double?>("triple", { input }));

			// Assert
			assert("%1.0f".printf(targetOutput) == "%1.0f".printf(output));
		}

		public void test_calling_of_function_with_string_result() {

			// Arrange
			const string functionCode = @"function greeting(name) {
	return 'Hello, ' + name + '!';
}";
			const string input = "Vovan";
			const string targetOutput = "Hello, Vovan!";
			var engine = new Engine();

			// Act
			engine.execute(functionCode);
			var output = engine.call_function<string>("greeting", { input });

			// Assert
			assert(targetOutput == output);
		}

		public void test_calling_of_function_with_unicode_string_result() {

			// Arrange
			const string functionCode = @"function privet(name) {
	return 'Привет, ' + name + '!';
}";
			const string input = "Вован";
			const string targetOutput = "Привет, Вован!";
			var engine = new Engine();

			// Act
			engine.execute(functionCode);
			var output = engine.call_function<string>("privet", { input });

			// Assert
			assert(targetOutput == output);
		}

		public void test_calling_of_function_with_many_parameters() {

			// Arrange
			const string functionCode = @"function determineArgumentsTypes() {
	var result = '',
		argumentIndex,
		argumentCount = arguments.length
		;
	for (argumentIndex = 0; argumentIndex < argumentCount; argumentIndex++) {
		if (argumentIndex > 0) {
			result += ', ';
		}
		result += typeof arguments[argumentIndex];
	}
	return result;
}";
			var engine = new Engine();

			// Act
			engine.execute(functionCode);
			var output = engine.call_function<string>("determineArgumentsTypes",
				{ RubricWeb.Undefined.value(), null, true, 12, 3.14, "test" });

			// Assert
			assert("undefined, object, boolean, number, number, string" == output);
		}

		public void test_calling_of_function_with_many_parameters_and_boolean_result() {

			// Arrange
			const string functionCode = @"function and() {
	var result = null,
		argumentIndex,
		argumentCount = arguments.length,
		argumentValue
		;
	for (argumentIndex = 0; argumentIndex < argumentCount; argumentIndex++) {
		argumentValue = arguments[argumentIndex];
		if (result !== null) {
			result = result && argumentValue;
		}
		else {
			result = argumentValue;
		}
	}
	return result;
}";
			var engine = new Engine();

			// Act
			engine.execute(functionCode);
			var output = engine.call_function<bool>("and", { true, true, false, true });

			// Assert
			assert(false == output);
		}

		public void test_calling_of_function_with_many_parameters_and_integer_result() {

			// Arrange
			const string functionCode = @"function sum() {
	var result = 0,
		argumentIndex,
		argumentCount = arguments.length
		;
	for (argumentIndex = 0; argumentIndex < argumentCount; argumentIndex++) {
		result += arguments[argumentIndex];
	}
	return result;
}";
			var engine = new Engine();

			// Act
			engine.execute(functionCode);
			int output = engine.call_function<int>("sum", { 120, 5, 18, 63 });

			// Assert
			assert(206 == output);
		}

		public void test_calling_of_function_with_many_parameters_and_double_result() {

			// Arrange
			const string functionCode = @"function sum() {
	var result = 0,
		argumentIndex,
		argumentCount = arguments.length
		;
	for (argumentIndex = 0; argumentIndex < argumentCount; argumentIndex++) {
		result += arguments[argumentIndex];
	}
	return result;
}";
			var engine = new Engine();

			// Act
			engine.execute(functionCode);
			var output = engine.call_function<double?>("sum", { 22000, 8.5, 0.05, 3 });

			// Assert
			assert(22011.55 == output);
		}

		public void test_calling_of_function_with_many_parameters_and_string_result() {

			// Arrange
			const string functionCode = @"function concatenate() {
	var result = '',
		argumentIndex,
		argumentCount = arguments.length
		;
	for (argumentIndex = 0; argumentIndex < argumentCount; argumentIndex++) {
		result += arguments[argumentIndex];
	}
	return result;
}";
			var engine = new Engine();

			// Act
			engine.execute(functionCode);
			var output = engine.call_function<string>("concatenate", { "Hello", ",", " ", "Petya", "!" });

			// Assert
			assert("Hello, Petya!" == output);
		}

		public void test_calling_of_function_with_many_parameters_and_unicode_string_result() {

			// Arrange
			const string functionCode = @"function obedinit() {
	var result = '',
		argumentIndex,
		argumentCount = arguments.length
		;
	for (argumentIndex = 0; argumentIndex < argumentCount; argumentIndex++) {
		result += arguments[argumentIndex];
	}
	return result;
}";
			var engine = new Engine();

			// Act
			engine.execute(functionCode);
			var output = engine.call_function<string>("obedinit", { "Привет", ",", " ", "Петя", "!" });

			// Assert
			assert("Привет, Петя!" == output);
		}


		// Getting, setting and removing variables

		public void test_setting_and_getting_variable_with_undefined() {

			// Arrange
			const string variableName = "myVar1";
			var input = RubricWeb.Undefined.value();
			var engine = new Engine();

			// Act
			bool variableExists;

			engine.set_variable(variableName, input);
			variableExists = engine.has_variable(variableName);
			var output = engine.get_variable<RubricWeb.Undefined>(variableName);

			// Assert
			assert(!variableExists);
			assert(input == output);
		}

		public void test_setting_and_getting_variable_with_null() {

			// Arrange
			const string variableName = "myVar2";
			var engine = new Engine();

			// Act
			bool variableExists;

			engine.set_variable(variableName, null);
			variableExists = engine.has_variable(variableName);
			var output = engine.get_variable<void*>(variableName);

			// Assert
			assert(variableExists);
			assert(output == null);
		}

		public void test_setting_and_getting_variable_with_boolean() {

			// Arrange
			const string variableName = "isVisible";

			const bool input1 = true;
			const bool targetOutput1 = false;

			const bool input2 = true;
			var engine = new Engine();

			// Act
			bool variableExists;
			bool output1;
			bool output2;

			engine.set_variable(variableName, input1);
			variableExists = engine.has_variable(variableName);
			engine.execute("%s = !%s;".printf(variableName, variableName));
			output1 = engine.get_variable<bool>(variableName);

			engine.set_variable(variableName, input2);
			output2 = engine.get_variable<bool>(variableName);

			// Assert
			assert(variableExists);
			assert(targetOutput1 == output1);

			assert(input2 == output2);
		}

		public void test_setting_and_getting_variable_with_integer() {

			// Arrange
			const string variableName = "amount";

			const int input1 = 38;
			const int targetOutput1 = 41;

			const int input2 = 711;
			var engine = new Engine();

			// Act
			bool variableExists;
			int output1;
			int output2;

			engine.set_variable(variableName, input1);
			variableExists = engine.has_variable(variableName);
			engine.execute("%s += 3;".printf(variableName));
			output1 = engine.get_variable<int>(variableName);

			engine.set_variable(variableName, input2);
			output2 = engine.get_variable<int>(variableName);

			// Assert
			assert(variableExists);
			assert(targetOutput1 == output1);

			assert(input2 == output2);
		}

		public void test_setting_and_getting_variable_with_double() {

			// Arrange
			const string variableName = "price";

			const double input1 = 2.20;
			const double targetOutput1 = 2.17;

			const double input2 = 3.50;
			var engine = new Engine();

			// Act
			bool variableExists;
			string output1;
			string output2;

			engine.set_variable(variableName, input1);
			variableExists = engine.has_variable(variableName);
			engine.execute("%s -= 0.03;".printf(variableName));
			output1 = "%1.2f".printf(engine.get_variable<double?>(variableName));

			engine.set_variable(variableName, input2);
			output2 = "%1.2f".printf(engine.get_variable<double?>(variableName));

			// Assert
			assert(variableExists);
			assert("%1.2f".printf(targetOutput1) == output1);

			assert("%1.2f".printf(input2) == output2);
		}

		public void test_setting_and_getting_variable_with_string() {

			// Arrange
			const string variableName = "word";

			const string input1 = "Hooray";
			const string targetOutput1 = "Hooray!";

			const string input2 = "Hurrah";
			var engine = new Engine();

			// Act
			bool variableExists;
			string output1;
			string output2;

			engine.set_variable(variableName, input1);
			variableExists = engine.has_variable(variableName);
			engine.execute("%s += '!';".printf(variableName));
			output1 = engine.get_variable<string>(variableName);

			engine.set_variable(variableName, input2);
			output2 = engine.get_variable<string>(variableName);

			// Assert
			assert(variableExists);
			assert(targetOutput1 == output1);

			assert(input2 == output2);
		}

		public void test_setting_and_getting_variable_with_unicode_string() {

			// Arrange
			const string variableName = "slovo";

			const string input1 = "Ура";
			const string targetOutput1 = "Ура!";

			const string input2 = "Урааа";
			var engine = new Engine();

			// Act
			bool variableExists;
			string output1;
			string output2;

			engine.set_variable(variableName, input1);
			variableExists = engine.has_variable(variableName);
			engine.execute("%s += '!';".printf(variableName));
			output1 = engine.get_variable<string>(variableName);

			engine.set_variable(variableName, input2);
			output2 = engine.get_variable<string>(variableName);

			// Assert
			assert(variableExists);
			assert(targetOutput1 == output1);

			assert(input2 == output2);
		}

		public void test_removing_variable() {

			// Arrange
			const string variableName = "price";
			const double input = 120.55;
			var engine = new Engine();

			// Act
			bool variableBeforeRemovingExists;
			bool variableAfterRemovingExists;

			engine.set_variable(variableName, input);
			variableBeforeRemovingExists = engine.has_variable(variableName);
			engine.remove_variable(variableName);
			variableAfterRemovingExists = engine.has_variable(variableName);


			// Assert
			assert(variableBeforeRemovingExists);
			assert(!variableAfterRemovingExists);
		}

		// Garbage collection

		public void test_garbage_collection() {

			// Arrange
			const string input = """arr = []; for (i = 0; i < 1000000; i++) { arr.push(arr); }""";
			var engine = new Engine();

			// Act
			engine.execute(input);
			if (engine.supports_gc)
				engine.collect_garbage();
		}


	}
}
