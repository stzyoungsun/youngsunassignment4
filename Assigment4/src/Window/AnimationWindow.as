package Window
{

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import Component.ButtonClass;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class AnimationWindow extends Sprite
	{
		private var _cSpriteLoader: LoaderClass;
		
		private var _componentDictionary: Dictionary;
		
		private var _windowRect : Rectangle;
		
		private var _startButton : ButtonClass;
		private var _stopButton : ButtonClass;
		private var _pauseButton : ButtonClass;
		private var _loadSpriteButton : ButtonClass;

		private var _fileStream:FileStream = new FileStream(); 
		private var _loadFile:File = new File(); 
		public function AnimationWindow(posx:int, posy:int, width:int, height:int, componentDictionary :Dictionary)
		{
			_windowRect = new Rectangle(posx, posy, width, height);
			_componentDictionary = componentDictionary;
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onDrawWindow);
		}
		/**
		 * 
		 * @param e
		 * Note @유영선 Window창에 그리는 이벤트
		 */		
		public function onDrawWindow(e:starling.events.Event) : void
		{
			var viewerImage:Image = new Image(_componentDictionary["Window.png"]);
			
			var startImage:Image = new Image(_componentDictionary["Start.png"]);
			var stopImage:Image = new Image(_componentDictionary["Stop.png"]);
			var pauseImage:Image = new Image(_componentDictionary["Pause.png"]);
			var loadImage : Image = new Image(_componentDictionary["LoadSprite.png"]);
			
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
			
			_loadSpriteButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
		}
		/**
		 * 
		 * @param e
		 *Note @유영선 Window창에 있는 버튼을 클릭 했을때 이벤트 
		 */		
		private function onButtonClick(e:TouchEvent): void
		{
			var touch:Touch = e.getTouch(stage,TouchPhase.BEGAN);
			
			if(touch)
			{
				if(e.currentTarget == _loadSpriteButton.getButton())
				{
					CreateAnimation();
				}
			}
		}
		
		private function CreateAnimation() : void
		{
			
			_loadFile = File.applicationDirectory;
			_loadFile.addEventListener(flash.events.Event.SELECT,onSelectHandler);
			_loadFile.browseForDirectory("Load 할 Sprite-Sheet를 선택해주세요 (우측하단의 폴더선택을 눌러주세요!!)");
		}
		
		private function onSelectHandler(e:flash.events.Event):void
		{
			_loadFile.removeEventListener(flash.events.Event.SELECT, onSelectHandler);
			_cSpriteLoader = new LoaderClass(loadDropDown,_loadFile.nativePath);
		}
		
		private function loadDropDown(): void
		{
			trace("Sprite Sheet 로드 완료");
		}
	}
		
}