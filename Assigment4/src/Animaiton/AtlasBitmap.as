package Animaiton
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;

	public class AtlasBitmap
	{
		private var _sprtieSheet:Bitmap;
		private var _subSpriteSheet: Dictionary;
		private var _subSheetVector:Vector.<Bitmap> = new Vector.<Bitmap>;
		
		private var _subTextureNames:Vector.<String> = new Vector.<String>;
		
		public function AtlasBitmap(sprtieSheet:Bitmap, spriteXml:XML = null)
		{
			_subSpriteSheet = new  Dictionary();
			_sprtieSheet = sprtieSheet;
			
			if (spriteXml)
			{
				parseAtlasXml(spriteXml);
			}
		}
		
		/**
		 * 
		 * @param spriteXml
		 * Note @유영선 xml에 SubBitmap에 접근하여 원하는 정보를 얻어 옵니다 
		 */		
		protected function parseAtlasXml(spriteXml:XML):void
		{
			var region:Rectangle = new Rectangle();
			
			for(var i : int =0; i < spriteXml.child("SubTexture").length(); i++)
			{
				var name:String = spriteXml.child("SubTexture")[i].attribute("name");
				var x:Number = parseFloat(spriteXml.child("SubTexture")[i].attribute("x"));
				var y:Number = parseFloat(spriteXml.child("SubTexture")[i].attribute("y"));
				var width:Number = parseFloat(spriteXml.child("SubTexture")[i].attribute("width"));
				var height:Number = parseFloat(spriteXml.child("SubTexture")[i].attribute("height"));
				
				region.setTo(x,y,width,height);
				createSubTexure(name, region);
			}
		}
		
		public function createSubTexure(name : String, region:Rectangle):void
		{
			var tempBitmapData : BitmapData = new BitmapData(region.width,region.height);
	
			tempBitmapData.copyPixels(_sprtieSheet.bitmapData,region,new Point(0,0));
			
			_subSpriteSheet[name] = new Bitmap(tempBitmapData);
			_subTextureNames.push(name);
			//_subSheetVector.push(Texture.fromTexture(_sprtieSheet,region));
			
		}
		
		public function addSubBitmap(subBitmap : Bitmap, name : String) : void
		{
			_subSpriteSheet[name] =  subBitmap;
			_subTextureNames.push(name);
		}
		
		public function getsubSpriteSheet() :Dictionary   //subtecture를  Dictionary로 리턴
		{
			return _subSpriteSheet;
		}
		
		public function getsubBitmapName() : Vector.<String > //subtecture에 이름만 리턴
		{
			return _subTextureNames;
		}
	}
}