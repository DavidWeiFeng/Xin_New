package com.robot.core.mode
{
   import com.robot.core.mode.spriteModelAdditive.ISpriteModelAdditive;
   import com.robot.core.mode.spriteModelAdditive.PeopleBloodBar;
   import com.robot.core.mode.spriteModelAdditive.SpriteFreeze;
   import com.robot.core.utils.Direction;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   
   public class SpriteModel extends Sprite implements ISprite
   {
      
      protected var _direction:String = Direction.DOWN;
      
      protected var _pos:Point = new Point();
      
      protected var _centerPoint:Point = new Point();
      
      protected var _hitRect:Rectangle = new Rectangle();
      
      private var additiveList:Array = [];
      
      private var _bloodBar:PeopleBloodBar;
      
      public function SpriteModel()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function set pos(_arg_1:Point) : void
      {
         this._pos.x = _arg_1.x;
         this._pos.y = _arg_1.y;
         this.x = _arg_1.x;
         this.y = _arg_1.y;
      }
      
      public function get pos() : Point
      {
         this._pos.x = x;
         this._pos.y = y;
         return this._pos;
      }
      
      override public function set x(_arg_1:Number) : void
      {
         super.x = _arg_1;
         this._pos.x = _arg_1;
      }
      
      override public function set y(_arg_1:Number) : void
      {
         super.y = _arg_1;
         this._pos.y = _arg_1;
      }
      
      public function get sprite() : Sprite
      {
         return this;
      }
      
      public function set direction(_arg_1:String) : void
      {
         if(_arg_1 == null || _arg_1 == "")
         {
            return;
         }
         this._direction = _arg_1;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function get centerPoint() : Point
      {
         this._centerPoint.x = x;
         this._centerPoint.y = y;
         return this._centerPoint;
      }
      
      public function get hitRect() : Rectangle
      {
         this._hitRect.x = x;
         this._hitRect.y = y;
         this._hitRect.width = width;
         this._hitRect.height = height;
         return this._hitRect;
      }
      
      public function set additive(array:Array) : void
      {
         var i:ISpriteModelAdditive = null;
         this.removeAllAditive();
         this.additiveList = array.slice();
         try
         {
            for each(i in this.additiveList)
            {
               i.model = this;
               i.init();
               i.show();
            }
         }
         catch(e:TypeError)
         {
            throw new Error("可视对象附加功能必须实现ISpriteModelAdditive接口！");
         }
      }
      
      public function showAllAdditive() : void
      {
         var _local_1:ISpriteModelAdditive = null;
         for each(_local_1 in this.additiveList)
         {
            _local_1.show();
         }
      }
      
      public function hideAllAdditive() : void
      {
         var _local_1:ISpriteModelAdditive = null;
         for each(_local_1 in this.additiveList)
         {
            _local_1.hide();
         }
      }
      
      public function appendAdditive(_arg_1:ISpriteModelAdditive) : void
      {
         this.additiveList.push(_arg_1);
         _arg_1.init();
      }
      
      public function removeAdditive(_arg_1:ISpriteModelAdditive) : void
      {
         var _local_2:int = int(this.additiveList.indexOf(_arg_1));
         if(_local_2 != -1)
         {
            _arg_1.destroy();
            this.additiveList.splice(_local_2,1);
         }
      }
      
      public function removeAllAditive(_arg_1:Boolean = false) : void
      {
         var _local_2:ISpriteModelAdditive = null;
         for each(_local_2 in this.additiveList)
         {
            if(!_arg_1)
            {
               if(!(_local_2 is SpriteFreeze))
               {
                  _local_2.destroy();
               }
            }
            else
            {
               _local_2.destroy();
            }
         }
         this.additiveList = [];
      }
      
      public function addPos(_arg_1:Point) : void
      {
         this._pos = this._pos.add(_arg_1);
         this.x = this._pos.x;
         this.y = this._pos.y;
      }
      
      public function subtractPos(_arg_1:Point) : void
      {
         this._pos = this._pos.subtract(_arg_1);
         this.x = this._pos.x;
         this.y = this._pos.y;
      }
      
      public function destroy() : void
      {
         this.removeAllAditive();
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function removeBloodBar() : void
      {
         DisplayUtil.removeForParent(this._bloodBar);
         if(Boolean(this._bloodBar))
         {
            this._bloodBar.destroy();
         }
         this._bloodBar = null;
      }
      
      public function get bloodBar() : PeopleBloodBar
      {
         if(!this._bloodBar)
         {
            this._bloodBar = new PeopleBloodBar();
            this._bloodBar.model = this;
            this._bloodBar.y = 30;
            this.addChild(this._bloodBar);
         }
         return this._bloodBar;
      }
      
      private function onAddedToStage(_arg_1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         DepthManager.swapDepth(this,y);
      }
   }
}

