package MakeSheet
{
	import flash.display.Bitmap;
	/**
	 * 
	 * Note @유영선 Bitmap에 ID속성을 부과하기 위한 클래스 
	 */
	public class IDBitmap
	{
		private var _bitmap : Bitmap;
		private var _filename : String;
		public function IDBitmap(bitmap:Bitmap, fileName:String)
		{
			_bitmap = bitmap;
			_filename = fileName;
		}
		
		public function getBitmap() : Bitmap
		{
			return _bitmap;
		}
		public function getFileName() : String
		{
			return _filename;
		}
	}
}