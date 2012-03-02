package utilities
{
	import spark.components.View;

	//[Bindable]
	public class AppSettings
	{
		static private var _instance:AppSettings;

		/**
		 * The Constructor
		 * <p>The constructor requires a SingletonEnforcer, so that another
		 * instance of the constructor can't be called directly.</p>
		 **/
		public function AppSettings(enforcer:SingletonEnforcer) {
		}
		
		/**
		 * Most Singleton Objects have a point of entry, the "getInstance" static function.
		 * <p>The "getInstance" static function checks to see if the "_instance" private
		 * variable exists, if it does return the existing "_instance", if not, return
		 * a new MySingleton "_instance" variable.</p>
		 **/
		public static function getInstance():AppSettings {
			if (AppSettings._instance == null)
				AppSettings._instance = new AppSettings(new SingletonEnforcer())
			return AppSettings._instance;
		}
		
		public var webServicesURL:String = "http://www.bombajob.bg/_mob_service_json.php";
		
		public function logThis(ctrl:View, ... args):void {
			var output:String = "";
			for (var i:uint = 0; i<args.length; i++) {
				output += " " + args[i];
			}
			trace("_______[BombaJob-DEBUG] " + ((ctrl == null) ? "XXX" : ctrl.name) + " // " + output);
		}
	}
}

/**
 * A Class, found declared such as this one, is only available to the package it is found in.
 * <p>This ensures that the class can only be called from the Singleton Object
 * "getInstance" static function</p>
 **/
class SingletonEnforcer{};