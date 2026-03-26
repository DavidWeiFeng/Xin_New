package com.robot.core.utils
{
   import com.robot.core.manager.LevelManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class RectangleMask
   {
      
      private static var _sprite:Sprite;
      
      private static var _lineCon:Sprite;
      
      private static var _txt:TextField;
      
      private static var _artUrl:String;
      
      private static var _viewMc:MovieClip;
      
      private static var _instance:EventDispatcher;
      
      public static var GOTO_NEXT:String = "gotoNext";
      
      public static var CLICK_NEXT:String = "CLICK_NEXT";
      
      public static var GUIDE_NEXT:String = "GUIDE_NEXT";
      
      public function RectangleMask()
      {
         super();
      }
      
      public static function setup(param1:String) : void
      {
      }
      
      public static function mask(param1:Rectangle, param2:String = "", param3:int = 1, param4:String = "") : void
      {
         var rect:Rectangle = null;
         var artTips:int = 0;
         var format:TextFormat = null;
         rect = param1;
         var tips:String = param2;
         artTips = param3;
         var artUrl:String = param4;
         if(rect.x < 0 || rect.x + rect.width > 960 || rect.y < 0 || rect.y + rect.height > 560)
         {
            throw new Error("激活区域不能超出舞台");
         }
         if(_sprite == null)
         {
            _sprite = new Sprite();
         }
         _sprite.graphics.clear();
         _sprite.graphics.beginFill(0,0.6);
         _sprite.graphics.drawRect(0,0,rect.x,560);
         _sprite.graphics.drawRect(rect.x,0,rect.width,rect.y);
         _sprite.graphics.drawRect(rect.x + rect.width,0,960 - rect.x - rect.width,560);
         _sprite.graphics.drawRect(rect.x,rect.y + rect.height,rect.width,560 - rect.y - rect.height);
         _sprite.graphics.endFill();
         if(_lineCon == null)
         {
            _lineCon = new Sprite();
         }
         _lineCon.graphics.clear();
         _lineCon.graphics.lineStyle(2,52479);
         _lineCon.graphics.moveTo(rect.x,rect.y);
         _lineCon.graphics.lineTo(rect.x + rect.width,rect.y);
         _lineCon.graphics.lineTo(rect.x + rect.width,rect.y + rect.height);
         _lineCon.graphics.lineTo(rect.x,rect.y + rect.height);
         _lineCon.graphics.lineTo(rect.x,rect.y);
         _lineCon.filters = [new GlowFilter(6750207,1,10,10)];
         _sprite.addChild(_lineCon);
         if(tips != "")
         {
            if(_txt == null)
            {
               format = new TextFormat();
               format.size = 16;
               format.leading = 2;
               format.color = 16711680;
               _txt = new TextField();
               _txt.defaultTextFormat = format;
               _txt.wordWrap = true;
               _txt.autoSize = "left";
               _txt.selectable = false;
               _txt.filters = [new DropShadowFilter(0,0,16777215,1,1.5,1.5,10)];
               _sprite.addChild(_txt);
            }
            _txt.text = tips;
            if(rect.x < 960 - _txt.width)
            {
               _txt.x = rect.x;
            }
            else
            {
               _txt.x = 960 - _txt.width;
            }
            if(rect.y < 560 - rect.height - _txt.height - 10)
            {
               _txt.y = rect.y + rect.height + 10;
            }
            else
            {
               _txt.y = rect.y - _txt.height - 10;
            }
         }
         if(artUrl != "")
         {
            _artUrl = artUrl;
            if(_viewMc == null)
            {
               ResourceManager.getResource(_artUrl,function(param1:DisplayObject):void
               {
                  _viewMc = param1 as MovieClip;
                  showView(rect,artTips);
               });
            }
            else
            {
               showView(rect,artTips);
            }
         }
         LevelManager.stage.addChild(_sprite);
      }
      
      private static function showView(param1:Rectangle, param2:int) : void
      {
         _viewMc.gotoAndStop(param2);
         _sprite.addChild(_viewMc);
         if(param1.x < 960 - _viewMc.width)
         {
            _viewMc.x = param1.x;
         }
         else
         {
            _viewMc.x = param1.x - _viewMc.width + param1.width;
         }
         if(param1.y < 560 - param1.height - _viewMc.height - 10)
         {
            _viewMc.y = param1.y + param1.height + 10;
         }
         else
         {
            _viewMc.y = param1.y - _viewMc.height - 10;
         }
      }
      
      public static function destroy() : void
      {
         ResourceManager.cancelURL(_artUrl);
         DisplayUtil.removeForParent(_sprite);
         _sprite = null;
         _lineCon = null;
         _txt = null;
         _viewMc = null;
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(_instance == null)
         {
            _instance = new EventDispatcher();
         }
         return _instance;
      }
      
      public static function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         getInstance().addEventListener(param1,param2,param3,param4,param5);
      }
      
      public static function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         getInstance().removeEventListener(param1,param2,param3);
      }
      
      public static function dispatchEvent(param1:Event) : void
      {
         getInstance().dispatchEvent(param1);
      }
      
      public static function hasEventListener(param1:String) : Boolean
      {
         return getInstance().hasEventListener(param1);
      }
   }
}

