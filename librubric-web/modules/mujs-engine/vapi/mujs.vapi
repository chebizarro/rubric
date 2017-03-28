[CCode (cheader_filename = "mujs.h")]
namespace Mujs {

	[CCode (cprefix = "JS_", has_type_id = false)]
	public enum ConstructorFlags {
		STRICT
	}

	/* RegExp flags */
	[CCode (cprefix = "JS_", has_type_id = false)]
	public enum RegExFlags {
		REGEXP_G = 1,
		REGEXP_I = 2,
		REGEXP_M = 4,
	}

	/* Property attribute flags */
	[CCode (cprefix = "JS_", has_type_id = false)]
	public enum PropertyAttributeFlags {
		READONLY = 1,
		DONTENUM = 2,
		DONTCONF = 4,
	}

	[CCode (cname = "js_Alloc", has_target = false)]
	public delegate void* Alloc(void *memctx, void *ptr, int size);

	[CCode (cname = "js_Panic", has_target = false)]
	public delegate void Panic(State J);

	[CCode (cname = "js_CFunction", has_target = false)]
	public delegate void CFunction(State J);

	[CCode (cname = "js_Finalize", has_target = false)]
	public delegate void Finalize(State J, void *p);

	[CCode (cname = "js_HasProperty", has_target = false)]
	public delegate int HasProperty(State J, void *p, string name);

	[CCode (cname = "js_Put", has_target = false)]
	public delegate int Put(State J, void *p, string name);

	[CCode (cname = "js_Delete", has_target = false)]
	public delegate int Delete(State J, void *p, string name);


	[CCode (cname = "js_State", free_function = "js_freestate")]
	[Compact]
	public class State {
		
		[CCode (cname = "js_newstate")]
		public State(Alloc? alloc = null, void* context = null, ConstructorFlags flags = 0);

		[CCode (cname = "js_setcontext")]
		public void set_context(void *uctx);

		[CCode (cname = "js_getcontext")]
		public void* get_context();

		[CCode (cname = "js_atpanic")]
		public Panic at_panic(Panic panic);

		[CCode (cname = "js_gc")]
		public void gc(int report);

		[CCode (cname = "js_dostring ")]
		public bool do_string (owned string source);
		
		[CCode (cname = "js_dofile")]
		public bool do_file(string filename);

		[CCode (cname = "js_ploadstring ")]
		public int pload_string (string filename, string source);

		[CCode (cname = "js_ploadfile")]
		public int pload_file(string filename);

		[CCode (cname = "js_pcall")]
		public bool p_call(int n);

		[CCode (cname = "js_pconstruct")]
		public int p_construct(int n);

		/* returns a jmp_buf */
		[CCode (cname = "js_savetry")]
		public void* save_try();

		//#define js_try(J) \	setjmp(savetry(J))

		[CCode (cname = "js_endtry")]
		public void end_try();

		[CCode (cname = "js_newerror")]
		public void new_error(string message);

		[CCode (cname = "js_newevalerror")]
		public void new_eval_error(string message);

		[CCode (cname = "js_newrangeerror")]
		public void new_range_error(string message);

		[CCode (cname = "js_newreferenceerror")]
		public void new_reference_error(string message);

		[CCode (cname = "js_newsyntaxerror")]
		public void new_syntax_error(string message);

		[CCode (cname = "js_newtypeerror")]
		public void new_type_error(string message);

		[CCode (cname = "js_newurierror")]
		public void new_uri_error(string message);

		[NoReturn]
		[CCode (cname = "js_error")]
		public void error(string fmt, ...);

		[NoReturn]
		[CCode (cname = "js_evalerror")]
		public void eval_error(string fmt, ...);

		[NoReturn]
		[CCode (cname = "js_rangeerror")]
		public void range_error(string fmt, ...);

		[NoReturn]
		[CCode (cname = "js_referenceerror")]
		public void reference_error(string fmt, ...);

		[NoReturn]
		[CCode (cname = "js_syntaxerror")]
		public void syntax_error(string fmt, ...);

		[NoReturn]
		[CCode (cname = "js_typeerror")]
		public void type_error(string fmt, ...);

		[NoReturn]
		[CCode (cname = "js_urierror")]
		public void uri_error(string fmt, ...);

		[NoReturn]
		[CCode (cname = "js_throw")]
		public void @throw();

		[CCode (cname = "js_loadstring ")]
		public void load_string (string filename, string source);

		[CCode (cname = "js_loadfile")]
		public void load_file(string filename);

		[CCode (cname = "js_eval")]
		public void eval();

		[CCode (cname = "js_call")]
		public void call(int n);

		[CCode (cname = "js_construct")]
		public void @construct(int n);

		[NoReturn]
		[CCode (cname = "js_ref")]
		string  @ref();

		[CCode (cname = "js_unref")]
		public void unref(string ref);

		[CCode (cname = "js_getregistry")]
		public void get_registry(string name);

		[CCode (cname = "js_setregistry")]
		public void set_registry(string name);

		[CCode (cname = "js_delregistry")]
		public void del_registry(string name);

		[CCode (cname = "js_getglobal")]
		public void get_global(string name);

		[CCode (cname = "js_setglobal")]
		public void set_global(string name);

		[CCode (cname = "js_defglobal")]
		public void def_global(string name, int atts);

		[CCode (cname = "js_hasproperty")]
		public int has_property(int idx, string name);

		[CCode (cname = "js_getproperty")]
		public void get_property(int idx, string name);

		[CCode (cname = "js_setproperty")]
		public void set_property(int idx, string name);

		[CCode (cname = "js_defproperty")]
		public void def_property(int idx, string name, int atts);

		[CCode (cname = "js_delproperty")]
		public void del_property(int idx, string name);

		[CCode (cname = "js_defaccessor")]
		public void def_accessor(int idx, string name, int atts);

		[CCode (cname = "js_getlength")]
		public int get_length(int idx);

		[CCode (cname = "js_setlength")]
		public void set_length(int idx, int len);

		[CCode (cname = "js_hasindex")]
		public int has_index(int idx, int i);

		[CCode (cname = "js_getindex")]
		public void get_index(int idx, int i);

		[CCode (cname = "js_setindex")]
		public void set_index(int idx, int i);

		[CCode (cname = "js_delindex")]
		public void del_index(int idx, int i);

		[CCode (cname = "js_currentfunction")]
		public void current_function();

		[CCode (cname = "js_pushglobal")]
		public void push_global();

		[CCode (cname = "js_pushundefined")]
		public void push_undefined();

		[CCode (cname = "js_pushnull")]
		public void push_null();

		[CCode (cname = "js_pushboolean")]
		public void push_boolean(bool v);

		[CCode (cname = "js_pushnumber")]
		public void push_number(double v);

		[CCode (cname = "js_pushstring ")]
		public void push_string (string v);

		[CCode (cname = "js_pushlstring ")]
		public void push_lstring (string v, int n);

		[CCode (cname = "js_pushliteral")]
		public void push_literal(string v);

		[CCode (cname = "js_newobject")]
		public void new_object();

		[CCode (cname = "js_newarray")]
		public void new_array();

		[CCode (cname = "js_newboolean")]
		public void new_boolean(bool v);

		[CCode (cname = "js_newnumber")]
		public void new_number(double v);

		[CCode (cname = "js_newstring ")]
		public void new_string (string v);

		[CCode (cname = "js_newcfunction")]
		public void new_cfunction(CFunction fun, string name, int length);

		[CCode (cname = "jsnewcconstructor")]
		public void new_cconstructor(CFunction fun, CFunction con, string name, int length);

		[CCode (cname = "js_newuserdata")]
		public void new_userdata(string tag, void *data, Finalize finalize);

		[CCode (cname = "js_newuserdatax")]
		public void new_userdatax(string tag, void *data, HasProperty has, Put put, Delete delete, Finalize finalize);

		[CCode (cname = "js_newregexp")]
		public void new_regexp(string pattern, int flags);

		[CCode (cname = "js_pushiterator")]
		public void push_iterator(int idx, int own);

		[CCode (cname = "js_nextiterator")]
		string next_iterator(int idx);

		[CCode (cname = "js_isdefined")]
		public bool is_defined(int idx);

		[CCode (cname = "js_isundefined")]
		public bool is_undefined(int idx);

		[CCode (cname = "js_isnull")]
		public bool is_null(int idx);

		[CCode (cname = "js_isboolean")]
		public bool is_boolean(int idx);

		[CCode (cname = "js_isnumber")]
		public bool is_number(int idx);

		[CCode (cname = "js_isstring ")]
		public bool is_string (int idx);

		[CCode (cname = "js_isprimitive")]
		public int is_primitive(int idx);

		[CCode (cname = "js_isobject")]
		public int is_object(int idx);

		[CCode (cname = "js_isarray")]
		public int is_array(int idx);

		[CCode (cname = "js_isregexp")]
		public int is_regexp(int idx);

		[CCode (cname = "js_iscoercible")]
		public int is_coercible(int idx);

		[CCode (cname = "js_iscallable")]
		public int is_callable(int idx);

		[CCode (cname = "js_isuserdata")]
		public int is_userdata(int idx, string tag);

		[CCode (cname = "js_toboolean")]
		public bool to_boolean(int idx);

		[CCode (cname = "js_tonumber")]
		public double to_number(int idx);

		[CCode (cname = "js_tostring ")]
		public unowned string to_string (int idx);

		[CCode (cname = "js_touserdata")]
		public void* to_userdata(int idx, string tag);

		[CCode (cname = "js_tointeger")]
		public int to_integer(int idx);

		[CCode (cname = "js_toint32")]
		public int32 to_int32(int idx);

		[CCode (cname = "js_touint32")]
		public uint32 to_uint32(int idx);

		[CCode (cname = "js_toint16")]
		public int16 to_int16(int idx);
		
		[CCode (cname = "js_touint16")]
		public uint16 to_uint16(int idx);

		[CCode (cname = "js_gettop")]
		public int get_top();

		[CCode (cname = "js_settop")]
		public void set_top(int idx);

		[CCode (cname = "js_pop")]
		public void pop(int n);

		[CCode (cname = "js_rot")]
		public void rot(int n);

		[CCode (cname = "js_copy")]
		public void copy(int idx);

		[CCode (cname = "js_remove")]
		public void remove(int idx);

		[CCode (cname = "js_insert")]
		public void insert(int idx);

		[CCode (cname = "js_replace")]
		public void replace(int idx);

		[CCode (cname = "js_dup")]
		public void dup();

		[CCode (cname = "js_dup2")]
		public void dup2();

		[CCode (cname = "js_rot2")]
		public void rot2();

		[CCode (cname = "js_rot3")]
		public void rot3();

		[CCode (cname = "js_rot4")]
		public void rot4();

		[CCode (cname = "js_rot2pop1")]
		public void rot2_pop1();

		[CCode (cname = "js_rot3pop2")]
		public void rot3_pop2();

		[CCode (cname = "js_concat")]
		public void concat();

		[CCode (cname = "js_compare")]
		public int compare(int okay);

		[CCode (cname = "js_equal")]
		public int equal();

		[CCode (cname = "js_strictequal")]
		public int strict_equal();

		[CCode (cname = "js_instanceof")]
		public int instance_of();
		
		
	}

}
