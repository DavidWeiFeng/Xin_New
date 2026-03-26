package com.robot.core.mode
{
   import com.robot.core.aticon.IWalk;
   import com.robot.core.aticon.WalkAction;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.utils.MathUtil;
   
   public class ActionSpriteModel extends SpriteModel implements IActionSprite
   {
      
      protected var _speed:Number = 1;
      
      protected var _actionType:String;
      
      protected var _walk:IWalk;
      
      protected var _autoRect:Rectangle = new Rectangle(0,0,MainManager.getStageWidth(),MainManager.getStageHeight() - 65);
      
      protected var _autoInvTime:uint;
      
      public function ActionSpriteModel()
      {
         super();
         this._walk = new WalkAction();
      }
      
      public function set actionType(_arg_1:String) : void
      {
         this._actionType = _arg_1;
      }
      
      public function get actionType() : String
      {
         return this._actionType;
      }
      
      public function set speed(_arg_1:Number) : void
      {
         this._speed = _arg_1;
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
      
      public function get autoRect() : Rectangle
      {
         return this._autoRect;
      }
      
      public function set autoRect(_arg_1:Rectangle) : void
      {
         this._autoRect = _arg_1;
      }
      
      public function get walk() : IWalk
      {
         return this._walk;
      }
      
      public function set walk(_arg_1:IWalk) : void
      {
         if(Boolean(this._walk))
         {
            this._walk.destroy();
         }
         this._walk = _arg_1;
      }
      
      public function play() : void
      {
      }
      
      public function stop() : void
      {
         this._walk.stop();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         clearInterval(this._autoInvTime);
         if(Boolean(this._walk))
         {
            this._walk.destroy();
         }
         this._walk = null;
         this._autoRect = null;
      }
      
      public function starAutoWalk(_arg_1:int) : void
      {
         clearInterval(this._autoInvTime);
         this._autoInvTime = setInterval(this.onAutoWalk,MathUtil.randomHalfAdd(_arg_1));
      }
      
      public function stopAutoWalk(_arg_1:Boolean = true) : void
      {
         clearInterval(this._autoInvTime);
         if(_arg_1)
         {
            this.stop();
         }
      }
      
      protected function onAutoWalk() : void
      {
         if(!MapManager.isInMap)
         {
            return;
         }
         if(Boolean(this._walk))
         {
            this._walk.execute(this,new Point(this._autoRect.x + this._autoRect.width * Math.random(),this._autoRect.y + this._autoRect.height * Math.random()),false);
         }
      }
   }
}

