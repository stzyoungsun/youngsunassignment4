package Window
{
	import flash.geom.Rectangle;
	
	import Component.ButtonClass;
	import Component.RadioButtonClass;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	
	public class AnimationWindow extends Sprite
	{
		
		private var _cloaderClass: LoaderClass;
		
		private var _windowRect : Rectangle;
		
		private var _startButton : ButtonClass;
		private var _stopButton : ButtonClass;
		private var _pauseButton : ButtonClass;
		private var _loadSpriteButton : ButtonClass;
	
		
		public function AnimationWindow(posx:int, posy:int, width:int, height:int, cloaderClass :LoaderClass)
		{
			_windowRect = new Rectangle(posx, posy, width, height);
			_cloaderClass = cloaderClass;
			addEventListener(Event.ADDED_TO_STAGE, onDrawWindow);
		}
		
		public function onDrawWindow(e:Event) : void
		{
			var viewerImage:Image = new Image(Texture.fromBitmap(_cloaderClass.getComponentDictionary()["Window.png"]));
			
			var startImage:Image = new Image(Texture.fromBitmap(_cloaderClass.getComponentDictionary()["Start.png"]));
			var stopImage:Image = new Image(Texture.fromBitmap(_cloaderClass.getComponentDictionary()["Stop.png"]));
			var pauseImage:Image = new Image(Texture.fromBitmap(_cloaderClass.getComponentDictionary()["Pause.png"]));
			var loadImage : Image = new Image(Texture.fromBitmap(_cloaderClass.getComponentDictionary()["LoadSprite.png"]));
			
			_startButton = new ButtonClass(new Rectangle(_windowRect.width/2+150, viewerImage.height+40, startImage.width, startImage.height),startImage);
			_stopButton = new ButtonClass(new Rectangle(_windowRect.width/2+220, viewerImage.height+40, stopImage.width, stopImage.height),stopImage);
			_pauseButton = new ButtonClass(new Rectangle(_windowRect.width/2+150, viewerImage.height+40, pauseImage.width, pauseImage.height),pauseImage);
			_loadSpriteButton = new ButtonClass(new Rectangle(_windowRect.x, viewerImage.height+45, loadImage.width, loadImage.height),loadImage, "Load SpriteSheets");
			
			viewerImage.x = _windowRect.x;
			viewerImage.y = _windowRect.y;
			viewerImage.width = _windowRect.width;
			viewerImage.height = _windowRect.height/2 + 50;
			
			addChild(viewerImage);
			addChild(_startButton.getButton());
			addChild(_stopButton.getButton());
			addChild(_loadSpriteButton.getButton());
		}
	}
	
	
}