namespace RubricWeb {
	
	public class V8Engine : Object, JSEngine {
		
		private const string _name = "V8Engine"; 

		private const string _version = "1.0"; 
		
		public string name { get { return _name; } }
		
		public string version { get { return _version; } }
		
		public bool supports_gc { get { return true; } }
		
		public T? evaluate<T>(string expression, string? doc_name = null) throws EngineError {
			return null;
		}
		
		public void execute(string code,  string? doc_name = null) throws EngineError {
			
		}

		public void execute_file(string path, string? encoding = null) throws EngineError {
			
		}
		
		public void execute_resource(string resource_name) throws EngineError {
			
		}
		
		public T call_function<T>(string function_name, Value?[]? args = null, Value? _this = null) {
			return null;
		}
		
		public bool has_variable(string name) {
			return false;
		}
		
		public T get_variable<T>(string name) {
			return null;
		}
		
		public void set_variable(string name, Value? value) {
			
		}
		
		public void remove_variable(string name) {
			
		}
		
		public void embed_host_object(string name, Object value) {
			
		}
		
		public void embed_host_type(string name, Type type) {
			
		}
		
		public void collect_garbage() {
			
		}
		
	}
	
}
