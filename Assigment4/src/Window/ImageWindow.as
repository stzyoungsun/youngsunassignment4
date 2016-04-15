package Window
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class ImageWindow extends Sprite
	{
		private var _componentDictionary: Dictionary;
		private var _windowRect : Rectangle;
		private var _vewImage : Image;
		
		public function ImageWindow(posx:int, posy:int, width:int, height:int, componentDictionary :Dictionary)
		{
			_windowRect = new Rectangle(posx, posy, width, height);
			_componentDictionary = componentDictionary;
			
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onDrawWindow);
		}
		
		public function onDrawWindow(e:starling.events.Event) : void
		{
			_vewImage = new Image(_componentDictionary["Window.png"]);
			
			_vewImage.x = _windowRect.x;
			_vewImage.y = _windowRect.y;
			_vewImage.width = _windowRect.width;
			_vewImage.height = _windowRect.height/2 + 50;
			
			addChild(_vewImage);
		}
	}
}