package utilities {
	
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import views.OfferDetailsView;
	
	public class SNTwitter {
		
		private var _message:String = "";
		private var _stage:Stage;

		public var _view:OfferDetailsView;
		
		public function SNTwitter(stage:Stage) {
			this._stage = stage;
		}
		
		public function PostToTwitter(msg:String):void {
			this._message = msg;
			var twView:StageWebView = new StageWebView();
			twView.viewPort = new Rectangle(10, 10, this._stage.width - 10, this._stage.height - 10);
		}
		
		private function postFinished():void {
			this._view.postTwitterFinished(null, null);
		}
	}
}