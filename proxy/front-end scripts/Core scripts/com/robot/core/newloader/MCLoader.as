package com.robot.core.newloader
{
   import com.robot.core.event.*;
   import com.robot.core.ui.loading.*;
   import com.robot.core.ui.loading.loadingstyle.ILoadingStyle;
   import flash.display.*;
   import flash.events.*;
   import flash.system.*;
   import flash.utils.*;
   
   [Event(name="success",type="com.robot.core.event.MCLoadEvent")]
   [Event(name="error",type="com.robot.core.event.MCLoadEvent")]
   [Event(name="close",type="com.robot.core.event.MCLoadEvent")]
   public class MCLoader extends EventDispatcher
   {
      
      private var _loadingView:ILoadingStyle;
      
      private var autoCloseLoading:Boolean;
      
      private var _parentContainer:DisplayObjectContainer;
      
      private var _url:String;
      
      private var _loader:Loader;
      
      private var _isCurrentApp:Boolean;
      
      private var _loadingStyle:int;
      
      private var _loadingTitle:String;
      
      public function MCLoader(_arg_1:String = "", _arg_2:DisplayObjectContainer = null, _arg_3:int = -1, _arg_4:String = "", _arg_5:Boolean = true, _arg_6:Boolean = false)
      {
         super();
         this._isCurrentApp = _arg_6;
         this._url = _arg_1;
         this._parentContainer = _arg_2;
         this.autoCloseLoading = _arg_5;
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.OPEN,this.openHandler);
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.initHandler);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         this._loadingStyle = _arg_3;
         this._loadingTitle = _arg_4;
         this._loadingView = Loading.getLoadingStyle(this._loadingStyle,_arg_2,this._loadingTitle);
         this._loadingView.addEventListener(RobotEvent.CLOSE_LOADING,this.loadingCloseHandler);
      }
      
      public function setIsShowClose(_arg_1:Boolean) : void
      {
         this._loadingView.setIsShowCloseBtn(_arg_1);
      }
      
      public function get sharedEvents() : EventDispatcher
      {
         return this._loader.contentLoaderInfo.sharedEvents;
      }
      
      public function set loadingView(_arg_1:ILoadingStyle) : void
      {
         this._loadingView.removeEventListener(RobotEvent.CLOSE_LOADING,this.loadingCloseHandler);
         this._loadingView.destroy();
         this._loadingView = _arg_1;
         this._loadingView.addEventListener(RobotEvent.CLOSE_LOADING,this.loadingCloseHandler);
      }
      
      public function doLoad(_arg_1:String = "") : void
      {
         var _local_2:LoaderContext = new LoaderContext();
         var _local_3:* = getDefinitionByName("com.taomee.utils.VLU");
         if(this._isCurrentApp)
         {
            _local_2.applicationDomain = ApplicationDomain.currentDomain;
         }
         if(_arg_1 == "")
         {
            if(this._url != "")
            {
               this._loader.load(_local_3.getURLRequest(this._url),_local_2);
            }
         }
         else
         {
            this._loader.contentLoaderInfo.addEventListener(Event.OPEN,this.openHandler);
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.initHandler);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
            this._loader.load(_local_3.getURLRequest(_arg_1),_local_2);
         }
      }
      
      private function openHandler(_arg_1:Event) : void
      {
         this._loadingView.show();
      }
      
      private function initHandler(_arg_1:Event) : void
      {
         this._loader.contentLoaderInfo.removeEventListener(Event.OPEN,this.openHandler);
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.initHandler);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         if(this.autoCloseLoading)
         {
            this._loadingView.close();
         }
         dispatchEvent(new MCLoadEvent(MCLoadEvent.SUCCESS,this));
      }
      
      private function errorHandler(_arg_1:IOErrorEvent) : void
      {
         this._loader.contentLoaderInfo.removeEventListener(Event.OPEN,this.openHandler);
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.initHandler);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         dispatchEvent(new MCLoadEvent(MCLoadEvent.ERROR,this));
      }
      
      private function progressHandler(_arg_1:ProgressEvent) : void
      {
         var _local_2:Number = _arg_1.bytesTotal;
         var _local_3:Number = _arg_1.bytesLoaded;
         this._loadingView.changePercent(_local_2,_local_3);
      }
      
      public function closeLoading() : void
      {
         if(Boolean(this._loadingView))
         {
            this._loadingView.close();
         }
      }
      
      private function loadingCloseHandler(_arg_1:RobotEvent) : void
      {
         dispatchEvent(new MCLoadEvent(MCLoadEvent.CLOSE,this));
         this.clear();
      }
      
      public function clear() : void
      {
         try
         {
            this._loader.close();
         }
         catch(e:Error)
         {
         }
         try
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.OPEN,this.openHandler);
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.initHandler);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
            this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         }
         catch(e:Error)
         {
         }
         if(Boolean(this._loadingView))
         {
            this._loadingView.destroy();
            this._loadingView.removeEventListener(RobotEvent.CLOSE_LOADING,this.loadingCloseHandler);
            this._loadingView = null;
         }
         this._parentContainer = null;
         this._loader = null;
      }
      
      public function getLoadingStyle() : ILoadingStyle
      {
         return this._loadingView;
      }
      
      public function get loader() : Loader
      {
         return this._loader;
      }
      
      public function set parentMC(_arg_1:DisplayObjectContainer) : void
      {
         this._parentContainer = _arg_1;
      }
      
      public function get parentMC() : DisplayObjectContainer
      {
         return this._parentContainer;
      }
   }
}

