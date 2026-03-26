package com.robot.app.protectSys
{
   import com.robot.core.config.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.component.control.*;
   import org.taomee.manager.*;
   
   public class SinglePetBox extends MLoadPane
   {
      
      public static const UP:uint = 0;
      
      public static const DOWN:uint = 1;
      
      public static const LEFT:uint = 2;
      
      private var mc:MovieClip;
      
      private var type:uint;
      
      public function SinglePetBox(_arg_1:uint, _arg_2:uint = 0)
      {
         super(null,MLoadPane.FIT_HEIGHT);
         this.isMask = false;
         setSizeWH(90,80);
         this.type = _arg_2;
         ResourceManager.getResource(ClientConfig.getPetSwfPath(_arg_1),this.onLoad,"pet");
      }
      
      public function get dirType() : uint
      {
         return this.type;
      }
      
      private function onLoad(o:DisplayObject) : void
      {
         this.mc = o as MovieClip;
         if(Boolean(this.mc))
         {
            this.setIcon(this.mc);
            this.mc.addEventListener(Event.ENTER_FRAME,function(_arg_1:Event):void
            {
               var _local_3:MovieClip = mc.getChildAt(0) as MovieClip;
               if(Boolean(_local_3))
               {
                  mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  _local_3.gotoAndStop(1);
               }
            });
            if(this.type == UP)
            {
               this.mc.gotoAndStop(Direction.UP);
            }
            else if(this.type == DOWN)
            {
               this.mc.gotoAndStop(Direction.DOWN);
            }
            else if(this.type == LEFT)
            {
               this.mc.gotoAndStop(Direction.LEFT);
            }
         }
      }
   }
}

