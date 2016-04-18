package Animaiton 
{
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;

	public class Atlastexture
	{
		private var _sprtieSheet:Texture;
		private var _subSpriteSheet: Dictionary;
		private var _subSheetVector:Vector.<Texture> = new Vector.<Texture>;
		
		private var _subTextureNames:Vector.<String> = new Vector.<String>;
		
		public function Atlastexture(sprtieSheet:Texture, spriteXml:XML = null)
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
		 * Note @유영선 xml에 Subtexture에 접근하여 원하는 정보를 얻어 옵니다 
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
			_subSpriteSheet[name] =  Texture.fromTexture(_sprtieSheet,region);
			_subSheetVector.push(Texture.fromTexture(_sprtieSheet,region));
			_subTextureNames.push(name);
		}
		
		public function getsubSpriteSheet() :Dictionary   //subtecture를  Dictionary로 리턴
		{
			return _subSpriteSheet;
		}
		
		public function getsubVector() : Vector.<Texture>	//subtecture를  Vector로 리턴
		{
			return _subSheetVector;
		}
		public function getsubTextureName() : Vector.<String > //subtecture에 이름만 리턴
		{
			return _subTextureNames;
		}
	
		public function release() : void
		{
			// TODD @유영선 해제 필요 하면 여기다 추가
			trace("아트라스 텍스터 해제");
		}
	}
}