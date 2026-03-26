package com.robot.app.cmd
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class GameOverCmdListener extends BaseBeanController
   {
      
      private var arrayItem:Array;
      
      private var index:uint = 0;
      
      public function GameOverCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.GAME_OVER,this.gameOverHander);
         finish();
      }
      
      private function gameOverHander(e:SocketEvent) : void
      {
         var itemKind:uint = 0;
         var i:int = 0;
         var power:uint = 0;
         var id:uint = 0;
         var count:uint = 0;
         power = 0;
         var by:ByteArray = e.data as ByteArray;
         var socre:uint = by.readUnsignedInt();
         var iq:uint = by.readUnsignedInt();
         power = by.readUnsignedInt();
         var mate:uint = by.readUnsignedInt();
         NonoManager.info.iq += iq;
         NonoManager.info.power += power;
         NonoManager.info.mate += mate;
         itemKind = by.readUnsignedInt();
         this.arrayItem = new Array();
         i = 0;
         while(i < itemKind)
         {
            id = by.readUnsignedInt();
            count = by.readUnsignedInt();
            this.arrayItem.push([id,count]);
            i += 1;
         }
         if(iq > 0)
         {
            NpcTipDialog.show("你聪明所以我聪明！嘿嘿，你有没有觉得我又聪明一点了呢？ 你的NoNo获得了" + iq + "点智慧值。",function():void
            {
               if(power > 0)
               {
                  NpcTipDialog.show("你的NoNo 获得了" + power + "点能量值。",function():void
                  {
                     if(arrayItem.length > 0)
                     {
                        getItem(arrayItem[index]);
                     }
                  },NpcTipDialog.NONO);
               }
               else if(arrayItem.length > 0)
               {
                  getItem(arrayItem[index]);
               }
            },NpcTipDialog.NONO);
         }
         if(iq == 0 && power > 0)
         {
            NpcTipDialog.show("你的NoNo 获得了" + power + "点能量值。",function():void
            {
               if(arrayItem.length > 0)
               {
                  getItem(arrayItem[index]);
               }
            },NpcTipDialog.NONO);
         }
         if(iq == 0 && power == 0 && this.arrayItem.length > 0)
         {
            this.getItem(this.arrayItem[this.index]);
         }
      }
      
      private function getItem(arr:Array) : void
      {
         var id:uint = 0;
         var count:uint = 0;
         var name:String = null;
         if(arr == null)
         {
            return;
         }
         id = uint(arr[0]);
         count = uint(arr[1]);
         name = ItemXMLInfo.getName(id);
         if(id == 1)
         {
            MainManager.actorInfo.coins += count;
            Alarm.show("在本次游戏中，你获得了" + count + "个骄阳豆",function():void
            {
               ++index;
               if(index < arrayItem.length)
               {
                  getItem(arrayItem[index]);
               }
               if(index == arrayItem.length)
               {
                  index = 0;
               }
            });
         }
         else if(id == 3)
         {
            Alarm.show("在本次游戏中，你获得了" + count + "点" + TextFormatUtil.getRedTxt("积累经验"),function():void
            {
               ++index;
               if(index < arrayItem.length)
               {
                  getItem(arrayItem[index]);
               }
               if(index == arrayItem.length)
               {
                  index = 0;
               }
            });
         }
         else
         {
            Alarm.show("在本次游戏中，你获得了" + count + "个<font color=\'#FF0000\'>" + name + "</font>",function():void
            {
               ++index;
               if(index < arrayItem.length)
               {
                  getItem(arrayItem[index]);
               }
               if(index == arrayItem.length)
               {
                  index = 0;
               }
            });
         }
      }
   }
}

