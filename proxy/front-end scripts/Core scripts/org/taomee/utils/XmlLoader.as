package org.taomee.utils
{
   import com.robot.core.config.*;
   import com.robot.core.manager.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.ui.loading.*;
   import com.robot.core.ui.loading.loadingstyle.ILoadingStyle;
   import flash.events.*;
   import flash.net.*;
   
   public class XmlLoader
   {
      
      public const XML_PATH:String = "resource/xml/";
      
      public var _loadingView:ILoadingStyle;
      
      public function XmlLoader()
      {
         super();
      }
      
      public function loadXML_Dll(url:String, ver:String, handle:Function) : void
      {
         var urlloader:URLLoader = null;
         var onComplete:Function = null;
         var errorHandler:Function = null;
         try
         {
            urlloader = new URLLoader();
            onComplete = null;
            errorHandler = null;
            onComplete = function(_arg_1:Event):void
            {
               urlloader.removeEventListener(Event.COMPLETE,onComplete);
               urlloader.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
               urlloader.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
               if(Boolean(_loadingView))
               {
                  _loadingView.destroy();
                  _loadingView = null;
               }
               var _local_2:XML = new XML(_arg_1.target.data);
               handle(_local_2);
            };
            errorHandler = function(_arg_1:IOErrorEvent):void
            {
               urlloader.removeEventListener(Event.COMPLETE,onComplete);
               urlloader.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
               urlloader.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
               if(Boolean(_loadingView))
               {
                  _loadingView.destroy();
                  _loadingView = null;
               }
               Alarm.show("xml加载" + XmlConfig.getXmlNameByPath(url) + "失败！");
               var _local_2:XML = new XML();
               handle(_local_2);
            };
            urlloader.addEventListener(Event.COMPLETE,onComplete);
            urlloader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
            urlloader.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
            if(Boolean(this._loadingView))
            {
               this._loadingView.destroy();
               this._loadingView = null;
            }
            this._loadingView = Loading.getLoadingStyle(1,MainManager.getStage(),"加载XML_" + XmlConfig.getXmlNameByPath(url) + "中");
            this._loadingView.setIsShowCloseBtn(false);
            urlloader.load(new URLRequest("dll/" + url + ".xml?" + ver));
         }
         catch(error:Error)
         {
            Alarm.show(error.message);
         }
      }
      
      public function loadXML(url:String, ver:String, handle:Function) : void
      {
         var urlloader:URLLoader = null;
         var onComplete:Function = null;
         var errorHandler:Function = null;
         try
         {
            urlloader = new URLLoader();
            onComplete = null;
            errorHandler = null;
            onComplete = function(_arg_1:Event):void
            {
               urlloader.removeEventListener(Event.COMPLETE,onComplete);
               urlloader.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
               urlloader.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
               if(Boolean(_loadingView))
               {
                  _loadingView.destroy();
                  _loadingView = null;
               }
               var _local_2:XML = new XML(_arg_1.target.data);
               handle(_local_2);
            };
            errorHandler = function(_arg_1:IOErrorEvent):void
            {
               urlloader.removeEventListener(Event.COMPLETE,onComplete);
               urlloader.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
               urlloader.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
               if(Boolean(_loadingView))
               {
                  _loadingView.destroy();
                  _loadingView = null;
               }
               Alarm.show("xml加载" + XmlConfig.getXmlNameByPath(url) + "失败！");
               var _local_2:XML = new XML();
               handle(_local_2);
            };
            urlloader.addEventListener(Event.COMPLETE,onComplete);
            urlloader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
            urlloader.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
            if(Boolean(this._loadingView))
            {
               this._loadingView.destroy();
               this._loadingView = null;
            }
            this._loadingView = Loading.getLoadingStyle(1,MainManager.getStage(),"加载XML_" + XmlConfig.getXmlNameByPath(url) + "中");
            this._loadingView.setIsShowCloseBtn(false);
            urlloader.load(new URLRequest(this.XML_PATH + url + ".xml?" + ver));
         }
         catch(error:Error)
         {
            Alarm.show(error.message);
         }
      }
      
      private function progressHandler(_arg_1:ProgressEvent) : void
      {
         var _local_2:Number = _arg_1.bytesTotal;
         var _local_3:Number = _arg_1.bytesLoaded;
         this._loadingView.changePercent(_local_2,_local_3);
      }
   }
}

