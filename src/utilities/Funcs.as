package utilities {
	import mx.resources.ResourceManager;

	[ResourceBundle("resources")]
	public class Funcs {

		public function Funcs() {
		}
		
		public function getListDate(dt:Date, today:Date, withYear:Boolean):String {
			var d:String = "";
			d += dt.date + " ";
			d += ResourceManager.getInstance().getString('resources','monthsLong_' + dt.month) + " ";
			if (withYear || dt.fullYear != today.fullYear)
				d += dt.fullYear;
			if (dt.date == today.date && dt.month == today.month && dt.fullYear == today.fullYear)
				d = ResourceManager.getInstance().getString('resources','date_Now');
			return d;
		}

	}

}