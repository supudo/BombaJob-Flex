package database {

	public class DatabaseSchema {

		public const TABLES_CREATED:String = "TABLES_CREATED";
		
		public const CREATE_TABLE_TEXTCONTENT:String = "CREATE TABLE IF NOT EXISTS text_content (id INTEGER PRIMARY KEY AUTOINCREMENT, cid NUMERIC, title TEXT, content TEXT);";
		public const CREATE_TABLE_CATEGORIES:String = "CREATE TABLE IF NOT EXISTS categories (id INTEGER PRIMARY KEY AUTOINCREMENT, cid NUMERIC, title TEXT, offerscount NUMERIC);";
		public const CREATE_TABLE_JOBOFFERS:String = "CREATE TABLE IF NOT EXISTS job_offers (id INTEGER PRIMARY KEY AUTOINCREMENT, oid NUMERIC, cid NUMERIC, title TEXT, categorytitle TEXT, email TEXT, freelanceyn BOOLEAN, humanyn BOOLEAN, negativism TEXT, positivism TEXT, publishdate DATE, publishdatestamp NUMERIC, readyn BOOLEAN, sentmessageyn BOOLEAN);";
		
		public const GET_TEXTCONTENT:String = "SELECT * FROM text_content WHERE cid = :cid";

		public const GET_CATEGORIES:String = "SELECT * FROM categories ORDER BY title";
		public const GET_CATEGORY:String = "SELECT * FROM categories WHERE cid = :cid";

		public const GET_JOBOFFERS:String = "SELECT * FROM job_offers";
		public const GET_JOBOFFERS_FOR_JOBOFFER_ID:String = "SELECT * FROM job_offers WHERE oid = :oid";
		public const GET_JOBOFFERS_FOR_CATEGORY_ID:String = "SELECT * FROM job_offers WHERE cid = :cid";

		public const GET_LAST_INSERT_ROWID:String = "SELECT last_insert_rowid()";
		
		public const INSERT_TEXTCONTENT:String = "INSERT INTO text_content (cid, title, content) VALUES (:cid, :title, :content)";
		public const INSERT_CATEGORIES:String = "INSERT INTO categories (cid, title, offerscount) VALUES (:cid, :title, :offerscount)";
		public const INSERT_JOBOFFERS:String = "INSERT INTO job_offers (oid, cid, title, categorytitle, email, freelanceyn, humanyn, negativism, positivism, publishdate, publishdatestamp, readyn, sentmessageyn) VALUES (:oid, :cid, :title, :categorytitle, :email, :freelanceyn, :humanyn, :negativism, :positivism, :publishdate, :publishdatestamp, :readyn, :sentmessageyn)";

		public const UPDATE_TEXTCONTENT:String = "UPDATE text_content SET title = :title, content = :content WHERE cid = :cid";
		public const UPDATE_CATEGORIES:String = "UPDATE categories SET title = :title, offerscount = :offerscount WHERE cid = :cid";
		public const UPDATE_JOBOFFERS:String = "UPDATE job_offers SET cid = :cid, title = :title, categorytitle = :categorytitle, email = :email, freelanceyn = :freelanceyn, humanyn = :humanyn, negativism = :negativism, positivism = :positivism, publishdate = :publishdate, publishdatestamp = :publishdatestamp WHERE oid = :oid";

		public const DELETE_TEXTCONTENT:String = "DELETE FROM text_content";
		public const DELETE_CATEGORIES:String = "DELETE FROM categories";
		public const DELETE_JOBOFFERS:String = "DELETE FROM job_offers";

		public function DatabaseSchema() {
		}
	}
}