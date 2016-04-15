package Component
{
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class ButtonListClass
	{
		private var _buttonList : Sprite;
		private var _buttonListRect : Rectangle;
		private var _buttonListImage : Image;
		private var _subButton : Vector.<Sprite> = new Vector.<Sprite>;
		
		public function ButtonListClass(buttonListRect : Rectangle, buttonListImage : Image)
		{
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
			_buttonList.addChild(button);
		}
		
		
	}
}