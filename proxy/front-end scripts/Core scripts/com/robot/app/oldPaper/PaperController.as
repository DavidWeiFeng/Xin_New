package com.robot.app.oldPaper
{
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.*;
   
   public class PaperController
   {
      
      private static var mc:MovieClip;
      
      private static var posArray:Array = [new Point(70,26),new Point(480,287),new Point(480,287),new Point(480,287),new Point(567,294),new Point(567,294),new Point(567,294),new Point(567,294)];
      
      public function PaperController()
      {
         super();
      }
      
      public static function setup(_arg_1:ApplicationDomain, _arg_2:uint) : void
      {
         mc = new (_arg_1.getDefinition("timeNews") as Class)() as MovieClip;
         mc.stop();
         (mc["bookMC"] as MovieClip).stop();
         show(_arg_2);
      }
      
      private static function show(_arg_1:uint) : void
      {
         var _local_2:Point = posArray[_arg_1];
         if(!_local_2)
         {
            _local_2 = new Point(567,294);
         }
         mc.x = _local_2.x;
         mc.y = _local_2.y;
         LevelManager.closeMouseEvent();
         LevelManager.topLevel.addChild(mc);
         var _local_3:SimpleButton = mc["exitBtn"];
         _local_3.addEventListener(MouseEvent.CLICK,closeHandler);
      }
      
      private static function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(mc);
         LevelManager.openMouseEvent();
      }
   }
}

