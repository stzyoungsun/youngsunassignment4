package
{
	import flash.geom.Rectangle;
	
	import Component.RadioButtonClass;
	
	import Window.AnimationWindow;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 
	 * @author user
	 * Note @유영선 중심이 되는 Class
	 */	
	public class MainClass extends Sprite
	{
		private var _cLoader : LoaderClass;
		private var _cAnimation : AnimationWindow;
		private var _componentAtlas : Atlastexture; 
		
		private var _radioButton : Vector.<RadioButtonClass> = new Vector.<RadioButtonClass>;    //라디오 버튼은  Animation/Image Window를 조절 하는 버튼 이므로 Main에 삽입
		public function MainClass()
		{
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize() : void
		{
			_cLoader = new LoaderClass(completeLoadImage);
		}
		/**
		 *Note @유영선 이미지 로딩 완료 후 AnimationWindow 창 로드  
		 * 
		 */		
		private function completeLoadImage() : void
		{
			_componentAtlas = new Atlastexture(Texture.fromBitmap(_cLoader.getSpriteSheetDictionary()["Component_Sheet0.png"]),_cLoader.getxmlDictionary()["Component_Sheet0.xml"]);
			_cAnimation = new AnimationWindow(0,30,stage.stageWidth,stage.stageHeight,_componentAtlas.getsubSpriteSheet());
			addChild(_cAnimation);
			
			drawRadioButton();
		}
		/**
		 * Note @유영선 두개의 라디오 버튼을 생성  
		 * 
		 */		
		private function drawRadioButton() : void
		{
			var RadioOFFImageA:Image = new Image(_componentAtlas.getsubSpriteSheet()["RadioOFF.png"]);
			var RadioONImageA:Image = new Image(_componentAtlas.getsubSpriteSheet()["RadioON.png"]);
			
			var RadioOFFImageI:Image = new Image(_componentAtlas.getsubSpriteSheet()["RadioOFF.png"]);
			var RadioONImageI:Image = new Image(_componentAtlas.getsubSpriteSheet()["RadioON.png"]);
			
			_radioButton[0] = new RadioButtonClass(new Rectangle(280, 410, 200, 150), RadioONImageA,RadioOFFImageA,"Animation Mode");
			_radioButton[1] = new RadioButtonClass(new Rectangle(280, 460,200, 150), RadioONImageI,RadioOFFImageI,"Image Mode");	
			_radioButton[1].swtichClicked(false);
			
			addChild(_radioButton[0].getRadioButton());
			addChild(_radioButton[1].getRadioButton());
			
			_radioButton[0].getRadioButton().addEventListener(TouchEvent.TOUCH,onRadioClick);
			_radioButton[1].getRadioButton().addEventListener(TouchEvent.TOUCH,onRadioClick);
		}
		
		private function onRadioClick(e:TouchEvent): void
		{
			var touch:Touch = e.getTouch(stage,TouchPhase.BEGAN);
			
			if(touch)
			{
				if(e.currentTarget == _radioButton[0].getRadioButton())
				{
					trace("0번 라디오 찍힘");
					_radioButton[0].swtichClicked(true);
					_radioButton[1].swtichClicked(false);
					_cAnimation.visible = true;
				}
				else if(e.currentTarget == _radioButton[1].getRadioButton())
				{
					trace("1번 라디오 찍힘");
					_radioButton[0].swtichClicked(false);
					_radioButton[1].swtichClicked(true);
					_cAnimation.visible = false;
				}
				else
					return;
			}
		}
	}
}