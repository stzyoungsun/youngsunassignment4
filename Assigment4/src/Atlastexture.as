package 
{
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.textures.SubTexture;
	import starling.textures.Texture;

	public class Atlastexture
	{
		private var _sprtieSheet:Texture;
		private var _subSpriteSheet: Dictionary;
		private var _subTextureNames:Vector.<String >;
		
		public function Atlastexture(sprtieSheet:Texture, spriteXml:XML = null)
		{
			_subSpriteSheet = new  Dictionary();
			_sprtieSheet = sprtieSheet;
			
			if (spriteXml)
			{
				parseAtlasXml(spriteXml);
			}
		}
		
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
		}
		
		public function getsubSpriteSheet() :Dictionary
		{
			return _subSpriteSheet;
		}
	}
}