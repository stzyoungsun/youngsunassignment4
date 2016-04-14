package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	
	public class LoaderClass
	{
		/**
		 * 이미지와 xml 2가지를  분리하여 Dictionary에 저장
		 * 기존에 구현 했던 Loaderclass 수정
		 * 
		 */		
		public static var sCurrentCount : int = 0;
		public static var sImageMaxCount :int;
		
		private var _spriteSheetDictionary : Dictionary = new Dictionary();
		private var _componentDictionary : Dictionary = new Dictionary();
		private var _xmlDictionary : Dictionary = new Dictionary;
		
		private var _spriteName : Vector.<String> = new Vector.<String>;
		
		private var _urlArray:Array = new Array();					//파일명이 담긴 배열
		private var _fileDataArray:Array = new Array();			   //파일이 담김 배열
		private var _loaderXML:URLLoader;
		private var _completeFunction:Function;
		public function LoaderClass(completeFunction : Function)
		{
			_completeFunction = completeFunction;
			resourceLoader();
		}
		
		public function resourceLoader() : void
		{
			var array:Array = new Array();
			getResource("resource/Component");
			getResource("resource/SpriteSheet");
			buildLoader();
			buildXMLLoader();
		}
		
		/**
		 * 
		 * @return 
		 * 불러올 폴더명 지정
		 */		
		private function getResource(filePath : String):void
		{
			var directory:File = File.applicationDirectory.resolvePath(filePath);
			var array:Array = directory.getDirectoryListing();			
			
			for(var i:int = 0; i<array.length; ++i)
			{				
				
				var url:String = decodeURIComponent(array[i].url); 
				
				var extension:String = url.substr(url.lastIndexOf(".") + 1, url.length);
				
				if(extension == "png" || extension == "jpg" || extension == "PNG" || extension == "JPG")
				{
					url = url.substring(5, url.length);	
					
					_urlArray.push(decodeURIComponent(url));					
				}
				//XML Loader
				else if(extension == "XML" || extension == "xml")
				{
					url = url.substring(5, url.length);	
					_spriteName.push(url);
				}
			}
		}
		
		
		private function buildXMLLoader():void
		{
			
			_loaderXML = new URLLoader(new URLRequest(_spriteName[0]));
			_loaderXML.addEventListener(Event.COMPLETE, onLoadXMLComplete);
		}
		
		private function buildLoader():void
		{
			sImageMaxCount =_urlArray.length; 
			sImageMaxCount+=_spriteName.length;
			
			for(var i:int = 0; i<_urlArray.length; ++i)
			{
				var loader:Loader = new Loader();
				
				loader.load(new URLRequest(_urlArray[i]));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);					
			}			
		}
		
		/**
		 * 
		 * @param e
		 * Note @유영선 한 이미지가 완료 후 다른 이미지 로딩 진행
		 */		
		private function onLoadComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(e.target);
			
			var filename:String = decodeURIComponent(loaderInfo.url);
			var extension:Array = filename.split('/');
			
			switch(extension[2])
			{
				case "SpriteSheet":
					_spriteSheetDictionary[extension[3]] =e.target.content as Bitmap;
					break;
				case "Component":
					_componentDictionary[extension[3]] =e.target.content as Bitmap;
					break;
			}
			
			chedckedImage();
		}
		
		/**
		 * 
		 * @param e
		 * Note @유영선 XML 로딩 진행
		 */		
		private function onLoadXMLComplete(e:Event):void
		{

			_loaderXML.removeEventListener(Event.COMPLETE, onLoadXMLComplete);
			var extension:Array = _spriteName[0].split('/');
			_xmlDictionary[extension[2]] = XML(e.currentTarget.data);
			_spriteName.removeAt(0);
			//_xmlVector.push(XML(e.currentTarget.data));
			chedckedImage();
			
			if(_spriteName.length != 0)
			{
				_loaderXML = new URLLoader(new URLRequest(_spriteName[0]));
				_loaderXML.addEventListener(Event.COMPLETE, onLoadXMLComplete)
			}	
		}
		
		/**
		 * 
		 * Note @유영선 이미지가 모두 로딩 된 후에 Mainclass에 완료 함수 호출
		 */		
		private function chedckedImage() : void
		{
			
			trace(sCurrentCount);
			if(sCurrentCount == sImageMaxCount-1) 
			{
				_completeFunction();
				return;
			}
			else
			{
				sCurrentCount++;
			}
		}
		
		public function getSpriteSheetDictionary() : Dictionary
		{
			return _spriteSheetDictionary;
		}
		
		public function getComponentDictionary() : Dictionary
		{
			return _componentDictionary;
		}
		
		public function getxmlDictionary() :  Dictionary
		{
			return _xmlDictionary;
		}
	}
}