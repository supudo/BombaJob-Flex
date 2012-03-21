package utilities {
	import com.adobe.fiber.services.wrapper.HTTPServiceWrapper;
	import com.adobe.serializers.json.JSONDecoder;
	import com.adobe.serializers.json.JSONEncoder;
	
	import database.DataModel;
	import database.Database;
	import database.DatabaseEvent;
	import database.DatabaseResponder;
	
	import events.DataEvent;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import utilities.AppSettings;
	
	import views.LoadingView;

	public class Synchronization extends com.adobe.fiber.services.wrapper.HTTPServiceWrapper {
		
		public var doFullSync:Boolean;

		private var httpService:HTTPService = new HTTPService();
		public var dbHelper:Database = new Database();
		private var dbResponder:DatabaseResponder = new DatabaseResponder();
		
		private var SERVICE_TEXTCONTENT:String = "?action=getTextContent";
		private var SERVICE_CATEGORIES:String = "?action=getCategories";
		private var SERVICE_NEWOFFERS:String = "?action=get500Jobs&wd=2";
		private var SERVICE_SEARCHJOBS:String = "?action=searchJobs&wd=2";
		private var SERVICE_SEARCHPEOPLE:String = "?action=searchPeople&wd=2";
		private var SERVICE_SEARCH:String = "?action=searchOffers&wd=2";
		private var SERVICE_POSTOFFER:String = "?action=postNewJob";
		private var SERVICE_POSTMESSAGE:String = "?action=postMessage";
		private var SERVICE_SENDEMAIL:String = "?action=sendEmailMessage";
		
		private var SERVICE_ID_TEXTCONTENT:uint = 1;
		private var SERVICE_ID_CATEGORIES:uint = 2;
		private var SERVICE_ID_NEWOFFERS:uint = 3;
		private var SERVICE_ID_SEARCHJOBS:uint = 4;
		private var SERVICE_ID_SEARCHPEOPLE:uint = 5;
		private var SERVICE_ID_SEARCH:uint = 6;
		private var SERVICE_ID_POSTOFFER:uint = 7;
		private var SERVICE_ID_POSTMESSAGE:uint = 8;
		private var SERVICE_ID_SENDEMAIL:uint = 9;
		
		private var ServiceID:uint = 0;

		private var loadingView:LoadingView;

		public function Synchronization(caller:LoadingView) {
			this.loadingView = caller;
			this.httpService.contentType = "application/json";
			this.httpService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			this.dbHelper = new Database();
		}

		public function StartSync():void {
			this.dbHelper.addEventListener("dbConnInitiated", dbConnectionInitiated);
			this.dbHelper.init(this.dbResponder);
		}
		
		public function dbConnectionInitiated(event:Event):void {
			this.removeEventListener("dbConnInitiated", dbConnectionInitiated);
			if (this.doFullSync)
				this.dbHelper.wipeDatabase();
			AppSettings.getInstance().dbHelper = this.dbHelper;
			this.StartSyncWithService(this.SERVICE_TEXTCONTENT);
		}
		
		public function StartSyncWithService(serviceName:String):void {
			try {
				AppSettings.getInstance().logThis(null, "Synchronizing ... " + serviceName);
				if (serviceName == this.SERVICE_TEXTCONTENT)
					this.syncTextContent();
				else if (serviceName == this.SERVICE_CATEGORIES)
					this.syncCategories();
				else if (serviceName == this.SERVICE_NEWOFFERS)
					this.syncNewOffers();
			}
			catch (e:Error) {
				AppSettings.getInstance().logThis(this, "Synchronizing error - " + e.message);
			}
		}

		private function syncCompleted():void {
			this.loadingView.syncCompleted();
		}
		
		/**
		 * Sync'ers
		 **/
		private function syncTextContent():void {
			AppSettings.getInstance().logThis(null, "Calling syncTextContent...");
			this.ServiceID = this.SERVICE_ID_TEXTCONTENT;
			this.httpService.url = AppSettings.getInstance().webServicesURL + this.SERVICE_TEXTCONTENT;
			this.httpService.addEventListener(ResultEvent.RESULT, serviceResult);
			this.httpService.addEventListener(FaultEvent.FAULT, serviceError);
			var token:AsyncToken = this.httpService.send();
			token.addResponder(new mx.rpc.Responder(onJSONResult, onJSONFault));
		}

		private function syncCategories():void {
			AppSettings.getInstance().logThis(null, "Calling syncCategories...");
			this.ServiceID = this.SERVICE_ID_CATEGORIES;
			this.httpService.url = AppSettings.getInstance().webServicesURL + this.SERVICE_CATEGORIES;
			this.httpService.addEventListener(ResultEvent.RESULT, serviceResult);
			this.httpService.addEventListener(FaultEvent.FAULT, serviceError);
			var token:AsyncToken = this.httpService.send();
			token.addResponder(new mx.rpc.Responder(onJSONResult, onJSONFault));
		}
		
		private function syncNewOffers():void {
			AppSettings.getInstance().logThis(null, "Calling syncNewOffers...");
			this.ServiceID = this.SERVICE_ID_NEWOFFERS;
			this.httpService.url = AppSettings.getInstance().webServicesURL + this.SERVICE_NEWOFFERS;
			this.httpService.addEventListener(ResultEvent.RESULT, serviceResult);
			this.httpService.addEventListener(FaultEvent.FAULT, serviceError);
			var token:AsyncToken = this.httpService.send();
			token.addResponder(new mx.rpc.Responder(onJSONResult, onJSONFault));
		}

		/**
		 * Service events
		 **/
		private function serviceResult(event:ResultEvent):void {
			AppSettings.getInstance().logThis(null, "Service OK - " + (event.result as String));
		}

		private function serviceError(event:FaultEvent):void {
			AppSettings.getInstance().logThis(null, "Service error:");
			AppSettings.getInstance().logThis(null, "     - Code:" + event.fault.faultCode);
			AppSettings.getInstance().logThis(null, "     - Description:" + event.fault.faultString);
			AppSettings.getInstance().logThis(null, "     - Detail:" + event.fault.faultString);
		}
		
		/**
		 * JSON events
		 **/
		private function onJSONResult(event:ResultEvent):void {
			var jsonResponse:String = (event.message.body as String);
			AppSettings.getInstance().logThis(null, "Got response from " + this.ServiceID + " = " + jsonResponse);
			switch (this.ServiceID) {
				case this.SERVICE_ID_TEXTCONTENT: {
					this.handleTextContent(jsonResponse);
					break;
				}
				case this.SERVICE_ID_CATEGORIES: {
					this.handleCategories(jsonResponse);
					break;
				}
				case this.SERVICE_ID_NEWOFFERS: {
					this.handleNewOffers(jsonResponse);
					break;
				}
				case this.SERVICE_ID_SEARCH: {
					this.handleSearchOffers(jsonResponse);
					break;
				}
				case this.SERVICE_ID_POSTOFFER: {
					this.handlePostOffer(jsonResponse);
					break;
				}
				default: {
					break;
				}
			}
		}

		private function onJSONFault(event:FaultEvent):void {
			AppSettings.getInstance().logThis(null, "JSON error:");
			AppSettings.getInstance().logThis(null, "     - Code:" + event.fault.faultCode);
			AppSettings.getInstance().logThis(null, "     - Description:" + event.fault.faultString);
			AppSettings.getInstance().logThis(null, "     - Detail:" + event.fault.faultString);
		}
		
		/**
		 * Handlers
		 **/
		private function handleTextContent(jsonResponse:String):void {
			var entities:Object = JSON.parse(jsonResponse);
			for (var i:uint=0; i<entities.getTextContent.length; i++) {
				var ent:Object = entities.getTextContent[i];
				var cid:uint = ent.id;
				this.dbHelper.addTextContent(ent);
			}
			this.syncCategories();
		}

		private function handleCategories(jsonResponse:String):void {
			var entities:Object = JSON.parse(jsonResponse);
			for (var i:uint=0; i<entities.getCategories.length; i++) {
				var ent:Object = entities.getCategories[i];
				var cid:uint = ent.id;
				this.dbHelper.addCategory(ent);
			}
			this.syncNewOffers();
		}
		
		private function handleNewOffers(jsonResponse:String):void {
			var entities:Object = JSON.parse(jsonResponse);
			for (var i:uint=0; i<entities.getNewJobs.length; i++) {
				var ent:Object = entities.getNewJobs[i];
				var cid:uint = ent.id;
				this.dbHelper.addJobOffers(ent);
			}
			this.syncCompleted();
		}
		
		private function handleSearchOffers(jsonResponse:String):void {
			var entities:Object = JSON.parse(jsonResponse);
			if (entities != null && entities.searchOffers != null) {
				for (var i:uint=0; i<entities.searchOffers.length; i++) {
					var ent:Object = entities.searchOffers[i];
					var cid:uint = ent.id;
					this.dbHelper.addJobOffers(ent);
				}
			}
			this.dispatchEvent(new Event("searchFinished", true));
		}
		
		private function handlePostOffer(jsonResponse:String):void {
			var returnObject:Object = new Object();
			var response:Object = JSON.parse(jsonResponse);
			if (response != null && response.postNewJob != null) {
				if (response.postNewJob.result == "true")
					returnObject.postResponse = "true";
				else
					returnObject.postResponse = response.postNewJob.result;
			}
			this.dispatchEvent(new DataEvent("postFinished", true, false, returnObject));
		}
		
		/**
		 * Publics
		 **/
		public function startSearch(searchQuery:String, freelanceYn:int):void {
			AppSettings.getInstance().logThis(null, "startSearch : freelanceYn = '" + freelanceYn + "', searchQuery = '" + searchQuery + "'");
			this.ServiceID = this.SERVICE_ID_SEARCH;
			this.httpService.url = AppSettings.getInstance().webServicesURL + this.SERVICE_SEARCH + "&keyword=" + searchQuery + "&freelance=" + freelanceYn;
			this.httpService.addEventListener(ResultEvent.RESULT, serviceResult);
			this.httpService.addEventListener(FaultEvent.FAULT, serviceError);
			var token:AsyncToken = this.httpService.send();
			token.addResponder(new mx.rpc.Responder(onJSONResult, onJSONFault));
		}
		
		public function postOffer(off:Object):void {
			if (off != null) {
				AppSettings.getInstance().logThis(null, "postOffer...");
				this.ServiceID = this.SERVICE_ID_POSTOFFER;
				var j:JSONEncoder = new JSONEncoder();
				var json:String = j.encode(off);
				this.httpService.url = AppSettings.getInstance().webServicesURL + this.SERVICE_POSTOFFER;
				this.httpService.contentType = "application/json";
				this.httpService.addEventListener(ResultEvent.RESULT, serviceResult);
				this.httpService.addEventListener(FaultEvent.FAULT, serviceError);
				var token:AsyncToken = this.httpService.send(json);
				token.addResponder(new mx.rpc.Responder(onJSONResult, onJSONFault));
			}
		}
	}

}