package utilities {
	
	import com.adobe.serializers.json.JSONEncoder;
	import com.facebook.graph.Facebook;
	import com.facebook.graph.FacebookMobile;
	
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import views.OfferDetailsView;
	
	public class SNFacebook {

		private var _message:String = "";
		private var _stage:Stage;
		
		public var _view:OfferDetailsView;
		
		public function SNFacebook(stage:Stage) {
			this._stage = stage;
		}
		
		public function PostToFacebook(msg:String):void {
			this._message = msg;
			FacebookMobile.init(AppSettings.getInstance().socFacebookAppID, initHandler);
		}
		
		protected function initHandler(result:Object, fail:Object):void {						
			if (result) {
				AppSettings.getInstance().logThis(null, "onInit, Already logged in.");
				this.postMessage();
			}
			else {
				AppSettings.getInstance().logThis(null, "onInit, No logged in. Possible error - " + fail.message);
				var fbView:StageWebView = new StageWebView();
				fbView.viewPort = new Rectangle(10, 10, this._stage.width - 10, this._stage.height - 10);
				FacebookMobile.login(loginHandler, this._stage, ["publish_stream"], fbView);
			}
		}

		protected function loginHandler(success:Object, fail:Object):void {
			if (success)
				postMessage();
			else if (fail != null && fail.error != null)
				AppSettings.getInstance().logThis(null, "Login error - " + fail.error.code + " - " + fail.error.message);
		}
		
		protected function postMessage():void {
			FacebookMobile.api("/me/feed", submitPostHandler, {message:this._message}, "POST");
		}
		
		protected function submitPostHandler(result:Object, fail:Object):void {
			AppSettings.getInstance().logThis(null, "FB result");
			this._view.postFacebookFinished(result, fail);
		}
	}
}