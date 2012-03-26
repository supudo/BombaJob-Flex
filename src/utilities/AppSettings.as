package utilities
{
	import database.Database;
	import database.DatabaseResponder;
	
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

		public var dbHelper:Database;
		public var webServicesURL:String = "http://www.bombajob.bg/_mob_service_json.php";
		public var stStorePrivateData:Boolean = true;
		public var stPDEmail:String = "";
		public var stShowCategories:Boolean = true;
		public var stOnlineSearch:Boolean = true;
		public var stInAppEmail:Boolean = false;
		public var socFacebookAppID:String = "";
		public var socFacebookAppURL:String = "";
		public var FacebookUID:String = "";
		public var TwitterConsumerKey:String = "";
		public var TwitterConsumerSecret:String = "";
		public var AppCallbackURI:String = "http://www.bombajob.bg/";
		//public var AppCallbackURI:String = "bombajobflex";
		public var TwitterCallbackURI:String = AppCallbackURI;// + "://twitter";
		public var TwitterOAuthToken:String = "";
		public var TwitterOAuthTokenSecret:String = "";
		
		public function logThis(ctrl:View, ... args):void {
			var output:String = "";
			for (var i:uint = 0; i<args.length; i++) {
				output += " " + args[i];
			}
			trace("_______[BombaJob-DEBUG] " + ((ctrl == null) ? "XXX" : ctrl.name) + " // " + output);
		}
		
		public function loadAppSettings():void {
			if (this.dbHelper == null) {
				this.dbHelper = new Database();
				this.dbHelper.init(new DatabaseResponder());
			}

			var setts:Array = this.dbHelper.getSettings();
			for (var i:uint; i<setts.length; i++) {
				switch(setts[i].sname) {
					case "stStorePrivateData": {
						AppSettings.getInstance().stStorePrivateData = setts[i].svalue == "true";
						break;
					}
					case "stPDEmail": {
						AppSettings.getInstance().stPDEmail = setts[i].svalue;
						break;
					}
					case "stShowCategories": {
						AppSettings.getInstance().stShowCategories = setts[i].svalue == "true";
						break;
					}
					case "stOnlineSearch": {
						AppSettings.getInstance().stOnlineSearch = setts[i].svalue == "true";
						break;
					}
					case "stInAppEmail": {
						AppSettings.getInstance().stInAppEmail = setts[i].svalue == "true";
						break;
					}
					default: {
						break;
					}
				}
			}
		}
		
		public function saveAppSettings():void {
			if (this.dbHelper == null) {
				this.dbHelper = new Database();
				this.dbHelper.init(new DatabaseResponder());
			}
			
			this.dbHelper.addSettings("stStorePrivateData", AppSettings.getInstance().stStorePrivateData.toString(), true);
			this.dbHelper.addSettings("stPDEmail", AppSettings.getInstance().stPDEmail, true);
			this.dbHelper.addSettings("stShowCategories", AppSettings.getInstance().stShowCategories.toString(), true);
			this.dbHelper.addSettings("stOnlineSearch", AppSettings.getInstance().stOnlineSearch.toString(), true);
			this.dbHelper.addSettings("stInAppEmail", AppSettings.getInstance().stInAppEmail.toString(), true);
		}
	}
}

/**
 * A Class, found declared such as this one, is only available to the package it is found in.
 * <p>This ensures that the class can only be called from the Singleton Object
 * "getInstance" static function</p>
 **/
class SingletonEnforcer{};