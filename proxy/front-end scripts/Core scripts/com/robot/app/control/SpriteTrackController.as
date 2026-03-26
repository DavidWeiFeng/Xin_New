package com.robot.app.control
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.AppModel;
   import flash.net.SharedObject;
   import org.taomee.manager.*;
   
   public class SpriteTrackController
   {
      
      private static var panel:AppModel;
      
      private static var so:SharedObject = SOManager.getUserSO(SOManager.LOCAL_CONFIG);
      
      public function SpriteTrackController()
      {
         super();
      }
      
      public static function show() : void
      {
         if(TaomeeManager.nonoSpriteTrack == 0)
         {
            TaomeeManager.nonoSpriteTrack = 1;
         }
         else
         {
            TaomeeManager.nonoSpriteTrack = 0;
         }
         if(TaomeeManager.nonoSpriteTrack == 1)
         {
            NpcTipDialog.show("嘿嘿，已为你打开了精灵追踪功能~",null,NpcTipDialog.NONO);
         }
         else
         {
            NpcTipDialog.show("嘿嘿，已为你关闭了精灵追踪功能~",null,NpcTipDialog.NONO);
         }
         so.data["nonoSpriteTrack"] = String(TaomeeManager.nonoSpriteTrack);
         SOManager.flush(so);
      }
   }
}

