package com.robot.core.cmd
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.*;
   import flash.display.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class EnergyXishouCmdListener extends BaseBeanController
   {
      
      private static var icon:MovieClip;
      
      public function EnergyXishouCmdListener()
      {
         super();
      }
      
      public static function showIcon() : void
      {
         icon["txt"].text = MainManager.actorInfo.energyTimes.toString();
         LeftToolBarManager.addIcon(icon);
         ToolTipManager.add(icon,"能量吸收器");
      }
      
      public static function delIcon() : void
      {
         ToolTipManager.remove(icon);
         LeftToolBarManager.delIcon(icon);
      }
      
      override public function start() : void
      {
         EventManager.addEventListener(RobotEvent.ENERGY_TIMES_CHANGE,this.onChange);
         icon = TaskIconManager.getIcon("EnergyClean_ui") as MovieClip;
         SocketConnection.addCmdListener(CommandID.USE_ENERGY_XISHOU,this.onUseEnergyXishou);
         if(MainManager.actorInfo.energyTimes > 0)
         {
            showIcon();
         }
         finish();
      }
      
      private function onUseEnergyXishou(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         MainManager.actorInfo.energyTimes = _local_2.readUnsignedInt();
         if(MainManager.actorInfo.energyTimes > 0)
         {
            showIcon();
         }
         else
         {
            delIcon();
         }
      }
      
      private function onChange(_arg_1:RobotEvent) : void
      {
         if(MainManager.actorInfo.energyTimes > 0)
         {
            showIcon();
         }
         else
         {
            delIcon();
         }
      }
   }
}

