package com.robot.core.manager.map
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.MapModel;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import gs.*;
   import gs.easing.*;
   import gs.events.*;
   import org.taomee.utils.*;
   
   public class MapTransEffect extends EventDispatcher
   {
      
      public static const NONE:int = 0;
      
      public static const TOP:int = 1;
      
      public static const LEFT:int = 2;
      
      public static const DOWN:int = 3;
      
      public static const RIGHT:int = 4;
      
      private var _mapModel:MapModel;
      
      private var _dir:int = 0;
      
      private var _sprite:Sprite;
      
      public function MapTransEffect(_arg_1:MapModel, _arg_2:int)
      {
         super();
         this._mapModel = _arg_1;
         this._dir = _arg_2;
      }
      
      public function star() : void
      {
         var _local_1:Point = null;
         var _local_2:BitmapData = null;
         var _local_3:Bitmap = null;
         var _local_4:BitmapData = null;
         var _local_5:Bitmap = null;
         _local_1 = null;
         if(this._dir == 0)
         {
            dispatchEvent(new MapEvent(MapEvent.MAP_EFFECT_COMPLETE));
         }
         else
         {
            _local_1 = this.getNewMapXY();
            this._sprite = new Sprite();
            _local_2 = new BitmapData(MainManager.getStageWidth(),MainManager.getStageHeight());
            _local_3 = new Bitmap(_local_2);
            _local_2.draw(LevelManager.mapLevel.getChildAt(0));
            this._sprite.addChild(_local_3);
            _local_4 = new BitmapData(MainManager.getStageWidth(),MainManager.getStageHeight());
            _local_5 = new Bitmap(_local_4);
            _local_5.x = _local_1.x;
            _local_5.y = _local_1.y;
            _local_4.draw(this._mapModel.root);
            this._sprite.addChild(_local_5);
            DisplayUtil.removeAllChild(LevelManager.mapLevel);
            LevelManager.mapLevel.addChild(this._sprite);
            this.moveMap(this._sprite,_local_1);
         }
      }
      
      private function moveMap(sprite:DisplayObject, p:Point) : void
      {
         var myTween:TweenMax = null;
         var finishx:Number = NaN;
         var finishy:Number = NaN;
         myTween = null;
         if(p.x == 0)
         {
            finishx = 0;
            finishy = -p.y;
         }
         else if(p.y == 0)
         {
            finishx = -p.x;
            finishy = 0;
         }
         myTween = new TweenMax(sprite,1,{
            "x":finishx,
            "y":finishy,
            "ease":Sine.easeOut
         });
         myTween.addEventListener(TweenEvent.COMPLETE,function(_arg_1:TweenEvent):void
         {
            myTween.removeEventListener(TweenEvent.COMPLETE,arguments.callee);
            _mapModel.root.addEventListener(Event.ADDED_TO_STAGE,onAddHandler);
            dispatchEvent(new MapEvent(MapEvent.MAP_EFFECT_COMPLETE));
         });
      }
      
      private function onAddHandler(_arg_1:Event) : void
      {
         this._mapModel.root.removeEventListener(Event.ADDED_TO_STAGE,this.onAddHandler);
         DisplayUtil.removeForParent(this._sprite);
         this._sprite = null;
         this._mapModel = null;
      }
      
      private function getNewMapXY() : Point
      {
         var _local_1:Point = null;
         switch(this._dir)
         {
            case TOP:
               _local_1 = new Point(0,-MainManager.getStageHeight());
               break;
            case LEFT:
               _local_1 = new Point(-MainManager.getStageWidth(),0);
               break;
            case DOWN:
               _local_1 = new Point(0,MainManager.getStageHeight());
               break;
            case RIGHT:
               _local_1 = new Point(MainManager.getStageWidth(),0);
               break;
            default:
               _local_1 = new Point(0,-MainManager.getStageHeight());
         }
         return _local_1;
      }
   }
}

