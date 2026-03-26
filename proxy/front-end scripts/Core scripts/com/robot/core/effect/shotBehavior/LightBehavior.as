package com.robot.core.effect.shotBehavior
{
   import com.robot.core.effect.LightEffect;
   import com.robot.core.mode.PKArmModel;
   import com.robot.core.mode.SpriteModel;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class LightBehavior implements IShotBehavior
   {
      
      public function LightBehavior()
      {
         super();
      }
      
      public function shot(_arg_1:PKArmModel, _arg_2:SpriteModel) : void
      {
         var _local_3:LightEffect = new LightEffect();
         var _local_4:Rectangle = _arg_1.getRect(_arg_1);
         _local_3.show(new Point(_arg_1.pos.x,_arg_1.pos.y + _local_4.y + 15),_arg_2.pos);
      }
      
      public function destroy() : void
      {
      }
   }
}

