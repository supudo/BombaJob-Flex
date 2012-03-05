package models {
	
	[Bindable]
	public class CategoryModel {
		
		import mx.collections.ArrayCollection;
		
		private static var _instance:CategoryModel;
		public var items:ArrayCollection;
		
		public function CategoryModel() {
		}
		
		public static function getInstance():CategoryModel {
			if (_instance == null)
				_instance = new CategoryModel();
			return _instance;
		}
	}
}