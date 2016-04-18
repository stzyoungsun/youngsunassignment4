package Window
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import Animaiton.Atlastexture;
	
	import Component.ButtonClass;
	import Component.ButtonListClass;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ImageWindow extends Sprite
	{
		private var _componentDictionary: Dictionary;	//컴포넌트 이미지
		private var _curTexture : Atlastexture; 	//사용자가 로드한 SprtieSheet 안에 의미지
		private var _windowRect : Rectangle;
		private var _vewImage : Image;
		
		private var _nextButton : ButtonClass;
		private var _prevButton : ButtonClass;
		private var _buttonList : ButtonListClass;
		
		private var _curImage : Image;
		private var _drawFirst : Boolean = false;
		private var _viewButtonCnt : int = 0;
		public function ImageWindow(posx:int, posy:int, width:int, height:int, componentDictionary :Dictionary,curTexture : Atlastexture )
		{
			_windowRect = new Rectangle(posx, posy, width, height);
			_componentDictionary = componentDictionary;
			_curTexture = curTexture;
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onDrawWindow);
		}
		
		public function onDrawWindow(e:starling.events.Event) : void
		{
			_vewImage = new Image(_componentDictionary["Window.png"]);
		
			var buttonListImage : Image = new Image(_componentDictionary["List.png"]);
			var nextImage:Image = new Image(_componentDictionary["Next.png"]);
			var prevImage:Image = new Image(_componentDictionary["Prev.png"]);
			
			_vewImage.x = _windowRect.x;
			_vewImage.y = _windowRect.y;
			_vewImage.width = _windowRect.width;
			_vewImage.height = _windowRect.height/2 + 50;
			
			_buttonList = new ButtonListClass(new Rectangle(_windowRect.x-30, _vewImage.height+55,350 ,200 ),buttonListImage,drawSprite);
			_nextButton = new ButtonClass(new Rectangle(_windowRect.x+190, _vewImage.height+30, nextImage.width, nextImage.height),nextImage);
			_prevButton = new ButtonClass(new Rectangle(_windowRect.x+40, _vewImage.height+30, prevImage.width, prevImage.height),prevImage);
			
			addChild(_vewImage);
			addChild(_buttonList.getList());
			addChild(_nextButton.getButton());
			addChild(_prevButton.getButton());
			
			_nextButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			_prevButton.getButton().addEventListener(TouchEvent.TOUCH,onButtonClick);
			
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
				}
			}
		}
		
		/**
		 * 버튼 리스트 안에있는 SpriteSheet 개수만큼 등록 
		 * 
		 */		
		private function addSheetButton() : void
		{
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
			
			if(_drawFirst == false)
				_drawFirst = true;
			else
				removeChild(_curImage);
			
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