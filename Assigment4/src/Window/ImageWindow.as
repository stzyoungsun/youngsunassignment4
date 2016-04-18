package Window
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import Animaiton.AtlasBitmap;
	import Animaiton.Atlastexture;
	
	import Component.ButtonClass;
	import Component.ButtonListClass;
	
	import MakeSheet.MakeSpriteSheet;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class ImageWindow extends Sprite
	{
		private var _cAddImageLoader: LoaderClass;
		
		private var _buttonListImage : Image;
		
		private var _componentDictionary: Dictionary;	//컴포넌트 이미지
		private var _curTexture : Atlastexture; 	//사용자가 로드한 SprtieSheet 안에 의미지
		private var _curBitmap : AtlasBitmap;
		private var _windowRect : Rectangle;
		private var _vewImage : Image;
		
		private var _nextButton : ButtonClass;
		private var _prevButton : ButtonClass;
		private var _addButton : ButtonClass;
		private var _buttonList : ButtonListClass;
		private var _makeSheet : ButtonClass;		//추가된 이미지를 이용하여 Sprtie Sheet를 재 생성
		
		private var _curImage : Image;
		private var _viewButtonCnt : int = 0;
		/**
		 * 
		 * @param posx 윈도우 위치
		 * @param posy 윈도우 위치
		 * @param width 윈도우 크기
		 * @param height 윈도우 크기
		 * @param componentDictionary 컴포넌트 이미지
		 * @param curTexture Animation윈도우에서 클릭 한 이미지의 Texture
		 * @param curBitmap Animation윈도우에서 클릭 한 이미지의 Bitmap
		 * 
		 */		
		public function ImageWindow(posx:int, posy:int, width:int, height:int, componentDictionary :Dictionary
									,curTexture : Atlastexture ,curBitmap : AtlasBitmap)
		{
			_windowRect = new Rectangle(posx, posy, width, height);
			_componentDictionary = componentDictionary;
			_curTexture = curTexture;
			_curBitmap = curBitmap;
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onDrawWindow);
		}
		
		public function onDrawWindow(e:starling.events.Event) : void
		{
			_vewImage = new Image(_componentDictionary["Window.png"]);
		
			var nextImage:Image = new Image(_componentDictionary["Next.png"]);
			var prevImage:Image = new Image(_componentDictionary["Prev.png"]);
			var addImage : Image = new Image(_componentDictionary["LoadSprite.png"]);
			_buttonListImage = new Image(_componentDictionary["List.png"]);
			var makeButtonImage : Image  = new Image(_componentDictionary["LoadSprite.png"]);
			
			_vewImage.x = _windowRect.x;
			_vewImage.y = _windowRect.y;
			_vewImage.width = _windowRect.width;
			_vewImage.height = _windowRect.height/2 + 50;
			
			_nextButton = new ButtonClass(new Rectangle(_windowRect.x+190, _vewImage.height+30, nextImage.width, nextImage.height),nextImage);
			_prevButton = new ButtonClass(new Rectangle(_windowRect.x+40, _vewImage.height+30, prevImage.width, prevImage.height),prevImage);
			_addButton = new ButtonClass(new Rectangle(460, 390, addImage.width/2, addImage.height),addImage, "이미지 추가");
			_makeSheet = new ButtonClass(new Rectangle(345, 450, addImage.width*2, addImage.height/2),makeButtonImage, "Remake Sprite Sheet");
			_makeSheet.getButton().visible = false;
			
			addChild(_vewImage);
			addChild(_addButton.getButton());
			addChild(_nextButton.getButton());
			addChild(_prevButton.getButton());
			addChild(_makeSheet.getButton());
			
			_nextButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_prevButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_addButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			
			addSheetButton();
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
					case _nextButton.getButton():  //다음 리스트를 보여주기 위한 부분
						_viewButtonCnt+=3;
						if(_viewButtonCnt >= _curTexture.getsubTextureName().length)
							_viewButtonCnt -= 3;
						viewListButton();
						break;
					case _prevButton.getButton():  //이전 리스트를 보여주기 위한 부분
						_viewButtonCnt-=3;
						if(_viewButtonCnt < 0)
							_viewButtonCnt = 0;
						viewListButton();
						break;
					case _addButton.getButton():
						addImage();
						break;
					case _makeSheet.getButton():
						var cMakeSpriteSheet : MakeSpriteSheet = new MakeSpriteSheet(_curBitmap);
						cMakeSpriteSheet.getSheet();
						break;
				}
			}
		}
		/**
		 * Note #유영선 이미지 추가 기능 함수 
		 * 추가 할 이미지들이 있는 폴더 선택
		 */		
		private function addImage() : void
		{
			var file : File = File.applicationDirectory;
			file.browseForDirectory("추가 할 이미지들이 있는 폴더를 선택해 주세요");
			file.addEventListener(flash.events.Event.SELECT,onDicSelected);
			
			function onDicSelected(e:flash.events.Event):void
			{
				_makeSheet.getButton().visible = true;
				_makeSheet.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
				_cAddImageLoader = new LoaderClass(addImageToList,file.nativePath,false);	
			}
		}
		
		/**
		 * 
		 * Note @유영선 메모리에 새로운 이미지 추가
		 */		
		private function addImageToList(): void
		{	
			for(var i :int = 0; i < _cAddImageLoader.getspriteName().length; i++)
			{
				var newTexture : Texture = Texture.fromBitmap(_cAddImageLoader.getSpriteSheetDictionary()[_cAddImageLoader.getspriteName()[i]]);
				_curTexture.addSubTexure(newTexture,_cAddImageLoader.getspriteName()[i]);
				_curBitmap.addSubBitmap(_cAddImageLoader.getSpriteSheetDictionary()[_cAddImageLoader.getspriteName()[i]],_cAddImageLoader.getspriteName()[i]);
			}
				
			_buttonList.release();
			
			_buttonList = null;
			addSheetButton();
		}
		/**
		 * 버튼 리스트 안에있는 SpriteSheet 개수만큼 등록 
		 * 
		 */		
		private function addSheetButton() : void
		{
			if(!_buttonList)
			{
				_buttonList = new ButtonListClass(new Rectangle(_windowRect.x-30, _vewImage.height+55,350 ,200 ),_buttonListImage,drawSprite);
				addChild(_buttonList.getList());
			}
				
			var buttonPos : int = 0;
			
			for(var i :int = 0; i < _curTexture.getsubVector().length; i++)
			{
				var button :ButtonClass = new ButtonClass(new Rectangle(),new Image(_componentDictionary["LoadSprite.png"]),_curTexture.getsubTextureName()[i]);
				_buttonList.addButton(button.getButton(),70,50+buttonPos*40);
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
			for(var i :int = 0; i < _curTexture.getsubTextureName().length; i++)
			{
				_buttonList.getButton()[i].visible = false;
			}
			if(endCount > _curTexture.getsubTextureName().length) endCount = _curTexture.getsubTextureName().length;
			
			for(var j :int = _viewButtonCnt; j < endCount; j++)
			{
				_buttonList.getButton()[j].visible = true;
			}
		}
		/**
		 * 
		 * @param spriteName 선택 된 리스튼 버튼에 들어 있는 이미지 이름
		 * Note @유영선 사용자가 선택 한 List버튼에 연관된 이미지를 창에 띠어줍니다
		 */		
		private function drawSprite(spriteName : String) : void
		{
			trace (spriteName);
			
			if(_curImage)
			{
				removeChild(_curImage);
			}
			
			_curImage = new Image(_curTexture.getsubSpriteSheet()[spriteName]);
			_curImage.x = 30;
			_curImage.y = 100;
			addChild(_curImage);
		}
		
		public function release() : void
		{
			// TODD @유영선 해제 필요 하면 여기다 추가
			trace("이미지 윈도우 해제");
			if(_nextButton)
				_nextButton.release();
			if(_prevButton)
				_prevButton.release();
			if(_buttonList)
				_buttonList.release();
			
			this.removeChildren();
			this.removeEventListeners();
		}
	}
}