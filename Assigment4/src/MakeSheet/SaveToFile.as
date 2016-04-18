package MakeSheet
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class SaveToFile
	{
		
		
		private var _fileStream:FileStream = new FileStream(); 
		private var _saveFile:File = new File(); 
		
		private var _spriteSheetBitmap : Vector.<Bitmap>;
		private var _spriteSheetRect :  Vector.<Vector.<Rectangle>>;
		private var _spriteSheetName : Vector.<Array>;
		
		private var _bitmapByteArray:ByteArray; 
		
		public function SaveToFile(bitmap:Vector.<Bitmap>, spriteSheetRect : Vector.<Vector.<Rectangle>>, spriteSheetName : Vector.<Array>)
		{
			_saveFile = File.applicationDirectory;
			_saveFile.addEventListener(Event.SELECT, onSelectHandler);
			_saveFile.browseForDirectory("저장 할 png, xml의 폴더를 선택해주세요. (우측하단의 폴더선택을 눌러주세요!!)");
		
			_spriteSheetBitmap = bitmap;
			_spriteSheetRect = spriteSheetRect;
			_spriteSheetName = spriteSheetName;
		}
		/**
		 * 
		 * @param bitmap 병합 된  bitmap
		 * Note @유영선 병합 된 bitmap을 PNGEncoder 라이브러리를 이용하여 png 변환 후 파일로 출력
		 * 
		 * 
		 * spriteSheetRect [sheet 개수][sheet 안에 이미지 개수의 위치 값] 의 이차원 벡터
		 * spriteSheetName [sheet 개수][sheet 안에 이미지 이름] 의 이차원 벡터
		 * 
		 */		

		private function onSelectHandler(e:Event):void
		{
			_saveFile.removeEventListener(Event.SELECT, onSelectHandler);
			var tempPath : String =  _saveFile.nativePath;
			
			for(var i : int =0; i < _spriteSheetBitmap.length; i++)
			{
				_bitmapByteArray = PNGEN.encode(_spriteSheetBitmap[i].bitmapData);
				_saveFile.nativePath += "\\NewSprite_Sheet"+i+".png";
				_fileStream.open(_saveFile, FileMode.WRITE);
				_fileStream.writeBytes(_bitmapByteArray);
				_saveFile.nativePath = tempPath;
				_fileStream.close();
			}
			
			for(var j : int = 0; j< _spriteSheetName.length; j++)
			{
				_saveFile.nativePath += "\\NewSprite_Sheet"+j+".xml";
				_fileStream.open(_saveFile, FileMode.WRITE);
				_fileStream.writeUTFBytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
				_fileStream.writeUTFBytes("<TextureAtlas ImagePath=\"" + "sprite_sheet["+j+"].png" + "\">\n");
				for(var k : int = 0; k< _spriteSheetName[j].length; k++)
				{
					_fileStream.writeMultiByte("<SubTexture name=\"" + _spriteSheetName[j][k] + "\" x=\"" + _spriteSheetRect[j][k].x 
						+ "\" y=\"" + _spriteSheetRect[j][k].y + "\" width=\"" + _spriteSheetRect[j][k].width + "\" height=\"" + _spriteSheetRect[j][k].height + " \"/>\n","EUC-KR");
				}
				_fileStream.writeUTFBytes("</TextureAtlas>");
				_fileStream.close();
				_saveFile.nativePath = tempPath;
			}
			
		}
	}
}