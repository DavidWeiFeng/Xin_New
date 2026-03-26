package com.robot.app.task.collectionExercise
{
   import com.robot.app.buyItem.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import org.taomee.manager.*;
   
   public class CollectionExercise
   {
      
      private static var icon:MovieClip;
      
      private static var panel:AppModel;
      
      public static const TASK_ID:uint = 17;
      
      public function CollectionExercise()
      {
         super();
      }
      
      public static function setup() : void
      {
         if(TasksManager.getTaskStatus(TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            showIcon();
            onAccept(true);
         }
      }
      
      public static function start() : void
      {
         if(TasksManager.getTaskStatus(TASK_ID) == TasksManager.UN_ACCEPT)
         {
            TasksManager.accept(TASK_ID,onAccept);
         }
         else if(TasksManager.getTaskStatus(TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            isGetRes();
         }
      }
      
      private static function isGetRes() : void
      {
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,getCollection);
         ItemManager.getCollection();
      }
      
      private static function getCollection(e:ItemEvent) : void
      {
         var j:int = 0;
         var str:String = null;
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,getCollection);
         if(Boolean(ItemManager.getCollectionInfo(400001)))
         {
            j = int(ItemManager.getCollectionInfo(400001).itemNum);
            if(j >= 10)
            {
               str = "那么快就采集完了吗？嗯，就是我要的矿石。干得好，感谢你为骄阳计划做出的贡献！";
               NpcTipDialog.show(str,function():void
               {
                  TasksManager.complete(TASK_ID,0);
               },NpcTipDialog.CICI);
            }
            else
            {
               str = "还没有采集到我要的矿石吗？细心些，找找看哪些星球上有黄晶矿石，记得要带上钻头啊！";
               NpcTipDialog.show(str,null,NpcTipDialog.CICI);
            }
         }
         else
         {
            str = "还没有采集到我要的矿石吗？细心些，找找看哪些星球上有黄晶矿石，记得要带上钻头啊！";
            NpcTipDialog.show(str,null,NpcTipDialog.CICI);
         }
      }
      
      private static function showIcon() : void
      {
         if(!icon)
         {
            icon = UIManager.getMovieClip("CollectionExercisICON");
            icon.light_mc.mouseChildren = false;
            icon.light_mc.mouseEnabled = false;
            ToolTipManager.add(icon,TasksXMLInfo.getName(TASK_ID));
         }
         TaskIconManager.addIcon(icon);
         icon.addEventListener(MouseEvent.CLICK,clickHandler);
         lightIcon();
      }
      
      public static function lightIcon() : void
      {
         icon.light_mc.gotoAndPlay(1);
         icon.light_mc.visible = true;
      }
      
      private static function noLightIcon() : void
      {
         icon.light_mc.gotoAndStop(1);
         icon.light_mc.visible = false;
      }
      
      private static function clickHandler(_arg_1:MouseEvent) : void
      {
         noLightIcon();
         if(panel == null)
         {
            panel = new AppModel(ClientConfig.getTaskModule("CollectionExercisPanel"),"正在打开任务信息");
            panel.setup();
         }
         panel.show();
      }
      
      public static function delIcon() : void
      {
         TaskIconManager.delIcon(icon);
         ToolTipManager.remove(icon);
      }
      
      public static function onAccept(_arg_1:Boolean) : void
      {
         var _local_2:String = null;
         var _local_3:String = null;
         getTool();
      }
      
      public static function getTool() : void
      {
         ItemManager.addEventListener(ItemEvent.CLOTH_LIST,onClothList);
         ItemManager.getCloth();
      }
      
      private static function onClothList(_arg_1:ItemEvent) : void
      {
         var _local_2:Boolean = false;
         var _local_3:Boolean = false;
         var _local_5:int = 0;
         ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,onClothList);
         var _local_4:Array = ItemManager.getClothIDs();
         while(_local_5 < _local_4.length)
         {
            if(_local_4[_local_5] == 100014)
            {
               _local_2 = true;
            }
            if(_local_4[_local_5] == 100015)
            {
               _local_3 = true;
            }
            _local_5++;
         }
         if(!_local_2)
         {
            ItemAction.buyItem(100014,false);
         }
         if(!_local_3)
         {
            ItemAction.buyItem(100015,false);
         }
      }
   }
}

