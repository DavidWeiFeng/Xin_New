package com.robot.core.aimat
{
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.utils.*;
   import flash.display.MovieClip;
   import flash.geom.*;
   import gs.*;
   import gs.easing.*;
   import org.taomee.utils.*;
   
   public class ThrowController
   {
      
      private var array:Array;
      
      private var mc:MovieClip;
      
      public function ThrowController(_arg_1:uint, _arg_2:uint, _arg_3:ISprite, _arg_4:Point)
      {
         var _local_5:int = 0;
         var _local_6:int = 0;
         _local_5 = 0;
         this.array = [65280,1046943,39167,16776960,6632191,16777215];
         super();
         this.mc = UIManager.getMovieClip("ui_Beacon");
         this.mc.gotoAndStop(1);
         var _local_7:Point = _arg_3.pos.clone();
         _local_7.y -= 40;
         _arg_3.direction = Direction.angleToStr(GeomUtil.pointAngle(_local_7,_arg_4));
         var _local_8:BasePeoleModel = _arg_3 as BasePeoleModel;
         if(_local_8.direction == Direction.RIGHT_UP || _local_8.direction == Direction.LEFT_UP)
         {
            _local_5 = int(_arg_4.y - Math.abs(_arg_4.x - _local_7.y) / 2);
         }
         else
         {
            _local_5 = int(_local_7.y - Math.abs(_arg_4.x - _local_7.y) / 2);
         }
         _local_6 = int(_local_7.x + (_arg_4.x - _local_7.x) / 2);
         this.mc.x = _local_7.x;
         this.mc.y = _local_7.y;
         LevelManager.mapLevel.addChild(this.mc);
         TweenMax.to(this.mc,1.5,{
            "bezier":[{
               "x":_local_6,
               "y":_local_5
            },{
               "x":_arg_4.x,
               "y":_arg_4.y
            }],
            "onComplete":this.onComp,
            "orientToBezier":true,
            "ease":Quad.easeOut
         });
      }
      
      private function onComp() : void
      {
         this.mc.rotation = 0;
         TweenLite.to(this.mc,2,{
            "scaleX":2,
            "scaleY":2
         });
         this.mc.gotoAndPlay(2);
         var _local_1:ColorTransform = new ColorTransform();
         _local_1.color = this.array[Math.floor(Math.random() * this.array.length)];
         this.mc.transform.colorTransform = _local_1;
      }
   }
}

