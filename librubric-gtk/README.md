Rubric Application Launch Process

application_id = "org.valadate-rev.desktop"
namespace="ValadateRevDesktop"
version="1.0.233aa"

Gsettings files - keyed by resource path
Gir files - Namespace + Version
ui files - keyed by resource path


Constructor : app_id, args
- sets application_id which is the DBus id the app will be registered under and all resources will be accessed
- parses the args, creating the Assembly


Assembly
- container
- actions
- logging
- resources
- preferences
- menus?


*create container
*load preferences
MenuManager
~Logging
ModuleManager

+Gtk.Builder
MenuAdapterFactory
Shell
ViewRegistry
~RegionManager
AdapterFactory
DialogService
