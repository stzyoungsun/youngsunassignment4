package Window
{

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import Animaiton.AnimaitonClip;
	import Animaiton.Atlastexture;
	
	import Component.ButtonClass;
	import Component.ButtonListClass;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class AnimationWindow extends Sprite
	{
		private var _cSpriteLoader: LoaderClass;
		
		private var _componentDictionary: Dictionary;
		
		private var _windowRect : Rectangle;
		
		private var _startButton : ButtonClass;
		private var _stopButton : ButtonClass;
		private var _pauseButton : ButtonClass;
		private var _loadSpriteButton : ButtonClass;
		private var _buttonList : ButtonListClass;
		private var _nextButton : ButtonClass;
		private var _prevButton : ButtonClass;
		private var _vewImage : Image;
		
		private var _fileStream:FileStream = new FileStream(); 
		private var _loadFile:File = new File(); 
		var _cClip : AnimaitonClip;
		
		private var _viewButtonCnt : int = 0;
		private var _drawFirst : Boolean = false;
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
			
			_vewImage = new Image(_componentDictionary["Window.png"]);
			
			var startImage:Image = new Image(_componentDictionary["Start.png"]);
			var stopImage:Image = new Image(_componentDictionary["Stop.png"]);
			var pauseImage:Image = new Image(_componentDictionary["Pause.png"]);
			var nextImage:Image = new Image(_componentDictionary["Next.png"]);
			var prevImage:Image = new Image(_componentDictionary["Prev.png"]);
			var loadImage : Image = new Image(_componentDictionary["LoadSprite.png"]);
			var buttonListImage : Image = new Image(_componentDictionary["List.png"]);
			
			_vewImage.x = _windowRect.x;
			_vewImage.y = _windowRect.y;
			_vewImage.width = _windowRect.width;
			_vewImage.height = _windowRect.height/2 + 50;
			
			_startButton = new ButtonClass(new Rectangle(_windowRect.width/2+150, _vewImage.height+30, startImage.width, startImage.height),startImage);
			_stopButton = new ButtonClass(new Rectangle(_windowRect.width/2+220, _vewImage.height+30, stopImage.width, stopImage.height),stopImage);
			_pauseButton = new ButtonClass(new Rectangle(_windowRect.width/2+150, _vewImage.height+30, pauseImage.width, pauseImage.height),pauseImage);
			_loadSpriteButton = new ButtonClass(new Rectangle(_windowRect.x+40, _vewImage.height+35, loadImage.width, loadImage.height),loadImage,"LoadDic SpriteSheets");
			_nextButton = new ButtonClass(new Rectangle(_windowRect.x+190, _vewImage.height+30, nextImage.width, nextImage.height),nextImage);
			_prevButton = new ButtonClass(new Rectangle(_windowRect.x+40, _vewImage.height+30, prevImage.width, prevImage.height),prevImage);
			
			_buttonList = new ButtonListClass(new Rectangle(_windowRect.x-30, _vewImage.height+55, loadImage.width+130, loadImage.height*2+100),buttonListImage,drawSprite);
			
			
			
			
			addChild(_vewImage);
			addChild(_startButton.getButton());
			addChild(_stopButton.getButton());
			addChild(_loadSpriteButton.getButton());
			
			_loadSpriteButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_nextButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_prevButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_startButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_pauseButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_stopButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
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
				switch(e.currentTarget)
				{
					case _loadSpriteButton.getButton():
						CreateAnimation();
						break;
					
					case _nextButton.getButton():  //다음 리스트를 보여주기 위한 부분
						_viewButtonCnt+=3;
						if(_viewButtonCnt >= _cSpriteLoader.getspriteName().length)
							_viewButtonCnt -= 3;
						viewListButton();
						break;
					
					case _prevButton.getButton():  //이전 리스트를 보여주기 위한 부분
						_viewButtonCnt-=3;
						if(_viewButtonCnt < 0)
							_viewButtonCnt = 0;
						viewListButton();
						break;
					case _startButton.getButton():
						_cClip.getTimer().start();
						break;
					case _stopButton.getButton():
						_cClip.getTimer().stop();
						break;
				}
			}
		}
		/**
		 * Note @유영선 AnmaionSheet 선택
		 * 
		 */		
		private function CreateAnimation() : void
		{
			
			_loadFile = File.applicationDirectory;
			_loadFile.addEventListener(flash.events.Event.SELECT,onSelectHandler);
			_loadFile.browseForDirectory("Load 할 Sprite-Sheet를 선택해주세요 (우측하단의 폴더선택을 눌러주세요!!)");
		}
		/**
		 * 
		 * @param e
		 * CSpriteLoader로 선택 된 시트와 xml 로더 시작
		 */		
		private function onSelectHandler(e:flash.events.Event):void
		{
			_loadFile.removeEventListener(flash.events.Event.SELECT, onSelectHandler);
			_cSpriteLoader = new LoaderClass(loadList,_loadFile.nativePath);
		}
		
		/**
		 * List를 등록하기 위한 함수 
		 * 
		 */		
		private function loadList(): void
		{	
			trace("Sprite Sheet 로드 완료");
			removeChild(_loadSpriteButton.getButton());
			_loadSpriteButton.getButton().removeEventListeners();
			
			addChild(_buttonList.getList());
			addChild(_nextButton.getButton());
			addChild(_prevButton.getButton());
			
			
			addSheetButton();
		}
		/**
		 * 버튼 리스트 안에있는 SpriteSheet 개수만큼 등록 
		 * 
		 */		
		private function addSheetButton() : void
		{
			var buttonPos : int = 0;
			
			for(var i :int = 0; i < _cSpriteLoader.getspriteName().length; i++)
			{
				trace(_cSpriteLoader.getspriteName()[i]);
				var button :ButtonClass = new ButtonClass(new Rectangle(),new Image(_componentDictionary["LoadSprite.png"]),_cSpriteLoader.getspriteName()[i])
				_buttonList.addButton(button.getButton(),65,50+buttonPos*40);
				button.getButton().visible = false;
				
				
				if(buttonPos == 2)
					buttonPos = 0;
				else 
					buttonPos++;
			}
			viewListButton();
		}
		/**
		 * 리스트에 버튼을 뿌려주기 위한 함수 
		 * 
		 */		
		private function viewListButton() : void
		{
			//한 리스트에 3개씩 뿌려주고 Next Prev 버튼을 누를 때마다 그 다음 버튼을 보여줍니다.
			var endCount : int = _viewButtonCnt + 3;   
			for(var i :int = 0; i < _cSpriteLoader.getspriteName().length; i++)
			{
				_buttonList.getButton()[i].visible = false;
			}
			if(endCount > _cSpriteLoader.getspriteName().length) endCount = _cSpriteLoader.getspriteName().length;
				
			for(var j :int = _viewButtonCnt; j < endCount; j++)
			{
				_buttonList.getButton()[j].visible = true;
			}
		}
		
		private function drawSprite(spriteName : String) : void
		{
			trace(spriteName);
			if(_drawFirst == false)
				_drawFirst = true;
			else
				removeChild(_cClip);
			
			var spritexml : String = spriteName.replace("png","xml");
			var spriteImage : Image = new Image(Texture.fromBitmap(_cSpriteLoader.getSpriteSheetDictionary()[spriteName]));
			var at : Atlastexture = new Atlastexture(Texture.fromBitmap(_cSpriteLoader.getSpriteSheetDictionary()[spriteName]),_cSpriteLoader.getxmlDictionary()[spritexml]);
			_cClip= new AnimaitonClip(at.getsubVector(),5,drawAnimation);
			_cClip.x = 30;
			_cClip.y = 100;
			
			addChild(_cClip);
		}
		
		private function drawAnimation(_textures : Texture) : void
		{
			_cClip.texture = _textures;
		}
	}
		
}