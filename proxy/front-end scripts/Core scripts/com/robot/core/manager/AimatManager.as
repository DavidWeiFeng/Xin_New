package com.robot.core.manager
{
   import com.robot.core.aimat.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import flash.display.DisplayObject;
   
   public class AimatManager
   {
      
      public function AimatManager()
      {
         super();
      }
      
      public static function useHeadShoot(headItemID:uint, func:Function = null, isHit:Boolean = false, disArr:Array = null, hitFun:Function = null, noHitFun:Function = null) : void
      {
         AimatController.addEventListener(AimatEvent.PLAY_END,function(_arg_1:AimatEvent):void
         {
            var _local_3:DisplayObject = null;
            AimatController.removeEventListener(AimatEvent.PLAY_END,arguments.callee);
            var _local_4:AimatInfo = _arg_1.info;
            if(_local_4.userID != MainManager.actorID)
            {
               return;
            }
            if(isHit)
            {
               if(Boolean(disArr))
               {
                  for each(_local_3 in disArr)
                  {
                     if(Boolean(_local_3))
                     {
                        if(_local_3.hitTestPoint(_local_4.endPos.x,_local_4.endPos.y))
                        {
                           if(hitFun != null)
                           {
                              hitFun();
                              return;
                           }
                        }
                     }
                  }
                  if(noHitFun != null)
                  {
                     noHitFun();
                  }
               }
            }
            else if(func != null)
            {
               func();
            }
         });
      }
   }
}

