package com.robot.core.manager
{
   import com.robot.core.event.RobotEvent;
   import com.robot.core.event.ScrollMapEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.geom.Point;
   import gs.TweenLite;
   import org.taomee.ds.HashMap;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.DisplayUtil;
   
   public class LevelManager
   {
      
      private static var _root:Sprite;
      
      private static var _gameLevel:Sprite;
      
      private static var _topLevel:Sprite;
      
      private static var _appLevel:Sprite;
      
      private static var _toolsLevel:Sprite;
      
      private static var _mapLevel:Sprite;
      
      private static var _iconLevel:Sprite;
      
      private static var _fightLevel:Sprite;
      
      private static var _tipLevel:Sprite;
      
      private static var bgSprite:Sprite;
      
      public static var hasMask:Boolean;
      
      private static var openModuleHash:HashMap;
      
      public static var isRecordMapPos:Boolean = false;
      
      private static var isTween:Boolean = false;
      
      private static const CHECK:uint = 150;
      
      private static const DIS:uint = 700;
      
      public function LevelManager()
      {
         super();
      }
      
      public static function setup(param1:Sprite) : void
      {
         _root = param1;
         _mapLevel = new Sprite();
         _mapLevel.name = "mapLevel";
         _root.addChild(_mapLevel);
         _toolsLevel = new Sprite();
         _toolsLevel.name = "toolsLevel";
         _root.addChild(_toolsLevel);
         _iconLevel = new Sprite();
         _iconLevel.name = "iconLevel";
         _root.addChild(_iconLevel);
         _appLevel = new Sprite();
         _appLevel.name = "appLevel";
         _root.addChild(_appLevel);
         _topLevel = new Sprite();
         _topLevel.name = "topLevel";
         _root.addChild(_topLevel);
         _tipLevel = new Sprite();
         _tipLevel.name = "tipLevel";
         _root.addChild(_tipLevel);
         _gameLevel = new Sprite();
         _gameLevel.name = "gameLevel";
         _root.addChild(_gameLevel);
         _fightLevel = new Sprite();
         _fightLevel.name = "fightLevel";
         _root.addChild(_fightLevel);
         openModuleHash = new HashMap();
      }
      
      public static function get root() : Sprite
      {
         return _root;
      }
      
      public static function get stage() : Stage
      {
         return _root.stage;
      }
      
      public static function get mapLevel() : Sprite
      {
         return _mapLevel;
      }
      
      public static function get toolsLevel() : Sprite
      {
         return _toolsLevel;
      }
      
      public static function get appLevel() : Sprite
      {
         return _appLevel;
      }
      
      public static function get topLevel() : Sprite
      {
         return _topLevel;
      }
      
      public static function get gameLevel() : Sprite
      {
         return _gameLevel;
      }
      
      public static function get iconLevel() : Sprite
      {
         return _iconLevel;
      }
      
      public static function get tipLevel() : Sprite
      {
         return _tipLevel;
      }
      
      public static function get fightLevel() : Sprite
      {
         return _fightLevel;
      }
      
      public static function openMouseEvent() : void
      {
         _mapLevel.mouseEnabled = true;
         _mapLevel.mouseChildren = true;
         _toolsLevel.mouseEnabled = true;
         _toolsLevel.mouseChildren = true;
         _appLevel.mouseEnabled = true;
         _appLevel.mouseChildren = true;
         _iconLevel.mouseEnabled = true;
         _iconLevel.mouseChildren = true;
      }
      
      public static function closeMouseEvent() : void
      {
         _mapLevel.mouseEnabled = false;
         _mapLevel.mouseChildren = false;
         _toolsLevel.mouseEnabled = false;
         _toolsLevel.mouseChildren = false;
         _iconLevel.mouseEnabled = false;
         _iconLevel.mouseChildren = false;
      }
      
      public static function closeAllMouseEvent() : void
      {
         _mapLevel.mouseEnabled = false;
         _mapLevel.mouseChildren = false;
         _toolsLevel.mouseEnabled = false;
         _toolsLevel.mouseChildren = false;
         _appLevel.mouseEnabled = false;
         _appLevel.mouseChildren = false;
         _iconLevel.mouseEnabled = false;
         _iconLevel.mouseChildren = false;
      }
      
      public static function showMapLevel() : void
      {
         _mapLevel.y = 0;
      }
      
      public static function hideMapLevel() : void
      {
         _mapLevel.y = 600;
      }
      
      public static function addLevel() : void
      {
         _root.addChild(_mapLevel);
         _root.addChild(_toolsLevel);
         _root.addChild(_iconLevel);
         _root.addChild(_appLevel);
         _root.addChild(_topLevel);
         _root.addChild(_tipLevel);
         _root.addChild(_gameLevel);
         _root.addChild(_fightLevel);
      }
      
      public static function removeContentLevel() : void
      {
         DisplayUtil.removeForParent(_mapLevel,false);
         DisplayUtil.removeForParent(_toolsLevel,false);
         DisplayUtil.removeForParent(_iconLevel,false);
         DisplayUtil.removeForParent(_appLevel,false);
         DisplayUtil.removeForParent(_topLevel,false);
         DisplayUtil.removeForParent(_tipLevel,false);
      }
      
      public static function hideAll(... rest) : void
      {
         var _loc2_:Sprite = null;
         for each(_loc2_ in rest)
         {
            _loc2_.y = 600;
         }
      }
      
      public static function showAll(... rest) : void
      {
         var _loc2_:Sprite = null;
         for each(_loc2_ in rest)
         {
            _loc2_.y = 0;
         }
      }
      
      public static function set mapScroll(param1:Boolean) : void
      {
         if(param1)
         {
            open();
         }
         else
         {
            close();
         }
      }
      
      private static function open() : void
      {
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,onWalk);
      }
      
      private static function close() : void
      {
         if(isRecordMapPos)
         {
            isRecordMapPos = false;
         }
         else
         {
            LevelManager.mapLevel.x = 0;
         }
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,onWalk);
      }
      
      private static function onWalk(param1:RobotEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(MapManager.currentMap.id == 460)
         {
            return;
         }
         if(MapManager.currentMap.id == 461)
         {
            return;
         }
         if(MapManager.currentMap.id == 792)
         {
            return;
         }
         if(MapManager.currentMap.id >= 550 && MapManager.currentMap.id <= 560)
         {
            return;
         }
         if(MapManager.currentMap.id >= 10829 && MapManager.currentMap.id <= 10832)
         {
            return;
         }
         if(MapManager.currentMap.id >= 11471 && MapManager.currentMap.id <= 11473)
         {
            return;
         }
         if(MapManager.currentMap.id >= 11292 && MapManager.currentMap.id <= 11294)
         {
            return;
         }
         if(MapManager.currentMap.id == 11303)
         {
            return;
         }
         if(MapManager.currentMap.id == 11310)
         {
            return;
         }
         if(MapManager.currentMap.id == 1301)
         {
            return;
         }
         if(isTween)
         {
            return;
         }
         var _loc4_:Point = MainManager.actorModel.localToGlobal(new Point());
         if(_loc4_.x > MainManager.getStageWidth() - CHECK)
         {
            _loc2_ = LevelManager.mapLevel.x;
            _loc3_ = MainManager.getStageWidth() - LevelManager.mapLevel.x + DIS;
            if(_loc3_ > MapManager.currentMap.width)
            {
               isTween = true;
               TweenLite.to(LevelManager.mapLevel,1,{
                  "x":MainManager.getStageWidth() - MapManager.currentMap.width,
                  "onComplete":onComp
               });
            }
            else
            {
               isTween = true;
               TweenLite.to(LevelManager.mapLevel,1,{
                  "x":_loc2_ - DIS,
                  "onComplete":onComp
               });
            }
         }
         else if(_loc4_.x < CHECK)
         {
            _loc2_ = LevelManager.mapLevel.x;
            _loc3_ = LevelManager.mapLevel.x + DIS;
            if(_loc3_ > 0)
            {
               isTween = true;
               TweenLite.to(LevelManager.mapLevel,1,{
                  "x":0,
                  "onComplete":onComp
               });
            }
            else
            {
               isTween = true;
               TweenLite.to(LevelManager.mapLevel,1,{
                  "x":_loc2_ + DIS,
                  "onComplete":onComp
               });
            }
         }
      }
      
      private static function onComp() : void
      {
         isTween = false;
         EventManager.dispatchEvent(new ScrollMapEvent(ScrollMapEvent.SCROLL_COMPLETE));
      }
      
      public static function moveToRight() : void
      {
         LevelManager.mapLevel.x = MainManager.getStageWidth() - MapManager.currentMap.width;
      }
      
      public static function moveToLeft() : void
      {
         LevelManager.mapLevel.x = 0;
      }
      
      public static function showOrRemoveMapLevelandToolslevel(param1:Boolean, param2:Boolean = false, param3:String = "") : void
      {
         var _loc4_:Shape = null;
         var _loc5_:BitmapData = null;
         var _loc6_:Bitmap = null;
         var _loc7_:int = 0;
         var _loc8_:Bitmap = null;
         if(!param1)
         {
            if(!DisplayUtil.hasParent(_mapLevel))
            {
               return;
            }
            if(param2 && !hasMask)
            {
               hasMask = true;
               if(bgSprite == null)
               {
                  bgSprite = new Sprite();
               }
               else
               {
                  DisplayUtil.removeAllChild(bgSprite);
               }
               _loc4_ = new Shape();
               _loc4_.graphics.beginFill(0,0.7);
               _loc4_.graphics.drawRect(0,0,MainManager.getStageWidth(),MainManager.getStageHeight());
               _loc4_.graphics.endFill();
               _loc5_ = new BitmapData(MainManager.getStageWidth(),MainManager.getStageHeight());
               _loc5_.draw(_root);
               _loc6_ = new Bitmap(_loc5_);
               bgSprite.addChild(_loc6_);
               bgSprite.addChild(_loc4_);
               _appLevel.addChildAt(bgSprite,0);
               if(param3 != "")
               {
                  openModuleHash.add(param3,true);
               }
            }
            DisplayUtil.removeForParent(_mapLevel,false);
            DisplayUtil.removeForParent(_toolsLevel,false);
            DisplayUtil.removeForParent(_iconLevel,false);
         }
         else
         {
            if(param3 != "" && Boolean(openModuleHash.containsKey(param3)))
            {
               openModuleHash.remove(param3);
            }
            if(bgSprite != null && openModuleHash.length == 0)
            {
               _loc7_ = 0;
               while(_loc7_ < bgSprite.numChildren)
               {
                  if(bgSprite.getChildAt(_loc7_) is Bitmap)
                  {
                     _loc8_ = bgSprite.getChildAt(_loc7_) as Bitmap;
                     _loc8_.bitmapData.dispose();
                     DisplayUtil.removeForParent(_loc8_,true);
                     _loc8_ = null;
                  }
                  else
                  {
                     DisplayUtil.removeForParent(bgSprite.getChildAt(_loc7_),true);
                  }
                  _loc7_++;
               }
               DisplayUtil.removeForParent(bgSprite,true);
               bgSprite = null;
            }
            if(openModuleHash.length == 0)
            {
               _root.addChildAt(_mapLevel,1);
               _root.addChildAt(_toolsLevel,2);
               _root.addChildAt(_iconLevel,3);
            }
            hasMask = false;
         }
      }
   }
}

