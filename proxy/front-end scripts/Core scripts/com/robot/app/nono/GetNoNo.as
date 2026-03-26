package com.robot.app.nono
{
   import com.robot.app.mapProcess.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class GetNoNo
   {
      
      private static var _nonoMc:MovieClip;
      
      public function GetNoNo()
      {
         super();
      }
      
      public static function startGet(_arg_1:MovieClip) : void
      {
         _nonoMc = _arg_1;
         ToolTipManager.add(_nonoMc as MovieClip,"NoNo领取处");
         _nonoMc.addEventListener(MouseEvent.CLICK,onClickHandler);
      }
      
      private static function onClickHandler(_arg_1:MouseEvent) : void
      {
         NpcTipDialog.show("点击右下角召唤超NO。",null,NpcTipDialog.NONO);
      }
      
      private static function onOkHandler() : void
      {
         if(TasksManager.getTaskStatus(461) == TasksManager.UN_ACCEPT)
         {
            TasksManager.accept(461,function(_arg_1:Boolean):void
            {
               if(_arg_1)
               {
                  showPanel();
               }
            });
            return;
         }
         if(TasksManager.getTaskStatus(461) == TasksManager.ALR_ACCEPT)
         {
            showPanel();
         }
      }
      
      private static function showPanel() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_OPEN,onGetSucHandler);
         SocketConnection.send(CommandID.NONO_OPEN,1);
      }
      
      private static function onGetSucHandler(e:SocketEvent) : void
      {
         var by:ByteArray = null;
         var _endNum:uint = 0;
         SocketConnection.removeCmdListener(CommandID.NONO_OPEN,onGetSucHandler);
         TasksManager.setTaskStatus(461,TasksManager.COMPLETE);
         by = e.data as ByteArray;
         _endNum = by.readUnsignedInt();
         if(_endNum == 0)
         {
            NpcTipDialog.show("呀～你已经有一只NoNo咯，好好照顾它吧。",null,NpcTipDialog.NONO);
         }
         else
         {
            MainManager.actorInfo.hasNono = true;
            NpcTipDialog.show("恭喜，你已经获得了属于自己的NoNo，在基地中可以找到，要好好待它哟。",function():void
            {
               if(TasksManager.getTaskStatus(96) == TasksManager.ALR_ACCEPT)
               {
                  TasksManager.getProStatusList(96,function(_arg_1:Array):void
                  {
                     var _local_2:MapProcess_107 = null;
                     if(Boolean(_arg_1[0]) && !_arg_1[1])
                     {
                        _local_2 = new MapProcess_107();
                        TasksManager.complete(96,1,null,true);
                        _local_2.hereNono.visible = false;
                     }
                  });
               }
            },NpcTipDialog.NONO);
         }
      }
      
      public static function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.NONO_OPEN,onGetSucHandler);
         ToolTipManager.remove(_nonoMc as SimpleButton);
         _nonoMc.removeEventListener(MouseEvent.CLICK,onClickHandler);
         _nonoMc = null;
      }
   }
}

