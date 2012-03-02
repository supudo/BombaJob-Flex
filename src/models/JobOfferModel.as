package models {
	
	[Bindable]
	public class JobOfferModel {

		import mx.collections.ArrayCollection;

		private static var _instance:JobOfferModel;
		public var items:ArrayCollection;
		
		public function JobOfferModel() {
		}
		
		public static function getInstance():JobOfferModel {
			if (_instance == null)
				_instance = new JobOfferModel();
			return _instance;
		}
	}
}