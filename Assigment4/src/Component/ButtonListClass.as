package Component
{
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	public class ButtonListClass
	{
		private var _buttonList : Sprite;
		private var _buttonListRect : Rectangle;
		private var _buttonListImage : Image;
		private var _subButton : Vector.<Sprite> = new Vector.<Sprite>;
		private var _drawSprite : Function;
		
		public function ButtonListClass(buttonListRect : Rectangle, buttonListImage : Image,drawSprite : Function)
		{
			_drawSprite = drawSprite;
			_buttonListRect = buttonListRect;
			_buttonListImage = buttonListImage;
			
			createImageButton();
		}
		
		private function createImageButton() : void
		{
			_buttonList = new Sprite();
			
			_buttonList.x = _buttonListRect.x;
			_buttonList.y = _buttonListRect.y;
			_buttonListImage.width = _buttonListRect.width;
			_buttonListImage.height = _buttonListRect.height;
			
			_buttonList.addChild(_buttonListImage);
			
		}
		
		public function getList() : Sprite
		{
			return _buttonList;
		}
		
		public function getButton() : Vector.<Sprite>
		{
			return _subButton;
		}
		/**
		 * 
		 * @param button  리스트에 삽일 할 버튼
		 * @param x	      리스트에서 평행이동 하는 x값
		 * @param y    리스트에서 평행이동하는 y값
		 * 
		 */		
		public function addButton(button : Sprite,x:int, y:int) : void  
		{
			_subButton.push(button);
			button.height=button.height/2+10;
			button.x = x;
			button.y = y;
			button.addEventListener(TouchEvent.TOUCH,onButtonClick);
			_buttonList.addChild(button);
		}
		
		private function onButtonClick(e:TouchEvent): void
		{
			var touch:Touch = e.getTouch(_buttonList,TouchPhase.BEGAN);
			var button : Sprite = e.currentTarget as Sprite;
		
			if(touch)
			{
				_drawSprite(button.name);
			}
		}
		
		public function release() : void
		{
			// TODD @유영선 해제 필요 하면 여기다 추가
			trace("버튼 리스트 클래스 해제");
			_buttonList.removeChildren();
			_buttonList.removeEventListeners();
		}
	}
}