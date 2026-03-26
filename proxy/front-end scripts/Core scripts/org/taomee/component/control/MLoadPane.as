package org.taomee.component.control
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import org.taomee.component.UIComponent;
   import org.taomee.component.event.LoadPaneEvent;
   import org.taomee.utils.DisplayUtil;
   
   [Event(name="onLoadContent",type="org.taomee.component.event.LoadPaneEvent")]
   public class MLoadPane extends UIComponent
   {
      
      public static const FIT_NONE:int = 0;
      
      public static const FIT_WIDTH:int = 1;
      
      public static const FIT_HEIGHT:int = 2;
      
      public static const FIT_ALL:int = 3;
      
      public static const CENTER:int = 0;
      
      public static const LEFT:int = 1;
      
      public static const RIGHT:int = 2;
      
      public static const MIDDLE:int = 0;
      
      public static const TOP:int = 1;
      
      public static const BOTTOM:int = 2;
      
      private var icon:*;
      
      private var oldH:Number;
      
      private var oldW:Number;
      
      private var loader:Loader;
      
      private var image:DisplayObject;
      
      private var _valign:int;
      
      private var _fitType:int;
      
      private var _halign:int;
      
      private var _offsetRect:Boolean = true;
      
      public function MLoadPane(_arg_1:* = null, _arg_2:int = 0, _arg_3:int = 0, _arg_4:int = 0)
      {
         super();
         this._fitType = _arg_2;
         this._halign = _arg_3;
         this._valign = _arg_4;
         this.icon = _arg_1;
         this.childMouseEnabled = false;
         this.getImageInstance(_arg_1);
      }
      
      public function get content() : DisplayObject
      {
         return this.image;
      }
      
      override protected function revalidate() : void
      {
         super.revalidate();
         if(!this.image)
         {
            return;
         }
         this.adjustImageSize();
      }
      
      private function onLoadTitleIcon(_arg_1:Event) : void
      {
         this.image = LoaderInfo(_arg_1.target).content;
         containSprite.addChild(this.image);
         this.oldW = this.image.width;
         this.oldH = this.image.height;
         updateView();
         dispatchEvent(new LoadPaneEvent(LoadPaneEvent.ON_LOAD_CONTENT,this.image));
      }
      
      public function get valign() : uint
      {
         return this._valign;
      }
      
      public function set halign(_arg_1:uint) : void
      {
         if(_arg_1 != this.halign)
         {
            this._halign = _arg_1;
            updateView();
         }
      }
      
      public function setContentScale(_arg_1:Number = 1, _arg_2:Number = 1) : void
      {
         this.image.scaleX = _arg_1;
         this.image.scaleY = _arg_2;
         if(this.image.scaleX != _arg_1 || this.image.scaleY != _arg_2)
         {
            updateView();
         }
      }
      
      private function loadImage(_arg_1:String) : void
      {
         try
         {
            this.loader.close();
         }
         catch(e:Error)
         {
         }
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadTitleIcon);
         this.loader.load(new URLRequest(_arg_1));
      }
      
      public function set fitType(_arg_1:uint) : void
      {
         if(_arg_1 != this.fitType)
         {
            this._fitType = _arg_1;
            updateView();
         }
      }
      
      public function get halign() : uint
      {
         return this._halign;
      }
      
      public function set valign(_arg_1:uint) : void
      {
         if(_arg_1 != this.valign)
         {
            this._valign = _arg_1;
            updateView();
         }
      }
      
      private function getImageInstance(_arg_1:*) : void
      {
         DisplayUtil.removeAllChild(containSprite);
         if(_arg_1 == null)
         {
            return;
         }
         if(_arg_1 is String)
         {
            this.loadImage(_arg_1);
         }
         else if(_arg_1 is DisplayObject)
         {
            this.image = _arg_1;
            this.oldW = this.image.width;
            this.oldH = this.image.height;
            containSprite.addChild(this.image);
            updateView();
            dispatchEvent(new LoadPaneEvent(LoadPaneEvent.ON_LOAD_CONTENT,this.image));
         }
      }
      
      public function get fitType() : uint
      {
         return this._fitType;
      }
      
      private function adjustImageSize() : void
      {
         var _local_3:Rectangle = null;
         var _local_1:Number = NaN;
         var _local_2:Number = NaN;
         switch(this.fitType)
         {
            case MLoadPane.FIT_HEIGHT:
               _local_1 = _local_2 = this.height / this.oldH;
               this.image.width = this.oldW * (this.height / this.oldH);
               this.image.height = this.height;
               break;
            case MLoadPane.FIT_WIDTH:
               _local_1 = _local_2 = this.width / this.oldW;
               this.image.height = this.oldH * (this.width / this.oldW);
               this.image.width = this.width;
               break;
            case MLoadPane.FIT_ALL:
               _local_1 = this.width / this.oldW;
               _local_2 = this.width / this.oldH;
               this.image.height = this.height;
               this.image.width = this.width;
               break;
            case MLoadPane.FIT_NONE:
            default:
               _local_1 = _local_2 = 1;
               this.image.height = this.oldH;
               this.image.width = this.oldW;
         }
         if(this._offsetRect)
         {
            _local_3 = this.image.getRect(this.image);
         }
         else
         {
            _local_3 = new Rectangle();
         }
         switch(this.halign)
         {
            case MLoadPane.LEFT:
               this.image.x = 0 - _local_3.x * _local_1;
               break;
            case MLoadPane.RIGHT:
               this.image.x = this.width - this.image.width - _local_3.x * _local_1;
               break;
            case MLoadPane.CENTER:
            default:
               this.image.x = (this.width - this.image.width) / 2 - _local_3.x * _local_1;
         }
         switch(this.valign)
         {
            case MLoadPane.TOP:
               this.image.y = 0 - _local_3.y * _local_2;
               return;
            case MLoadPane.BOTTOM:
               this.image.y = this.height - this.image.height - _local_3.y * _local_2;
               return;
            case MLoadPane.MIDDLE:
         }
         this.image.y = (this.height - this.image.height) / 2 - _local_3.y * _local_2;
      }
      
      public function set childMouseEnabled(_arg_1:Boolean) : void
      {
         containSprite.mouseChildren = _arg_1;
      }
      
      public function set offsetRect(_arg_1:Boolean) : void
      {
         this._offsetRect = _arg_1;
      }
      
      public function reLoad() : void
      {
         DisplayUtil.removeForParent(this.image);
         this.getImageInstance(this.icon + "?" + Math.random());
      }
      
      override public function destroy() : void
      {
         this.image = null;
         super.destroy();
      }
      
      public function setIcon(_arg_1:*) : void
      {
         this.getImageInstance(_arg_1);
      }
      
      public function unload() : void
      {
         DisplayUtil.removeForParent(this.image);
      }
   }
}

