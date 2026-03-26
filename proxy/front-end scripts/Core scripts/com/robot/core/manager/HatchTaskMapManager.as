package com.robot.core.manager
{
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.HatchTask.HatchTaskInfo;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.ds.*;
   
   public class HatchTaskMapManager
   {
      
      private static var mapItemHash:HashMap = new HashMap();
      
      private static var soulBeadStatusMap:HashMap = new HashMap();
      
      getMapItems();
      
      public function HatchTaskMapManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         setTimeout(function():void
         {
            HatchTaskManager.getTaskStatusList(function(_arg_1:HashMap):void
            {
               soulBeadStatusMap = _arg_1;
               cutIsTaskMap();
            });
         },1000);
      }
      
      public static function getSoulBeadStatusMap(_arg_1:HashMap) : void
      {
         soulBeadStatusMap = _arg_1;
      }
      
      public static function mapSoulBeadTaskDo(_arg_1:HatchTaskInfo, _arg_2:uint) : void
      {
         var _local_3:String = null;
         var _local_4:MovieClip = null;
         if(Boolean(_arg_1))
         {
            if(!_arg_1.statusList[_arg_2])
            {
               _local_3 = HatchTaskXMLInfo.getProMCName(_arg_1.itemID,_arg_2);
               _local_4 = MapManager.currentMap.controlLevel[_local_3] as MovieClip;
               if(Boolean(_local_4))
               {
                  _local_4.buttonMode = true;
                  _local_4.addEventListener(MouseEvent.CLICK,finishHatchTask(_arg_1.obtainTime,_arg_1.itemID,_arg_2));
               }
            }
         }
      }
      
      private static function getMapItems() : void
      {
         var _local_1:HatchTaskInfo = null;
         var _local_2:uint = 0;
         var _local_3:Array = null;
         var _local_4:Array = soulBeadStatusMap.getValues();
         for each(_local_1 in _local_4)
         {
            _local_2 = _local_1.itemID;
            _local_3 = HatchTaskXMLInfo.getTaskMapList(_local_2);
            mapItemHash.add(_local_2,_local_3);
         }
      }
      
      public static function cutIsTaskMap() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,function(_arg_1:MapEvent):void
         {
            var _local_2:uint = 0;
            var _local_3:HatchTaskInfo = null;
            var _local_4:Array = null;
            var _local_5:uint = 0;
            var _local_6:uint = _arg_1.mapModel.id;
            var _local_7:Array = HatchTaskXMLInfo.getMapSoulBeadList(_local_6);
            if(_local_7.length > 0)
            {
               for each(_local_2 in _local_7)
               {
                  for each(_local_3 in soulBeadStatusMap.getValues())
                  {
                     if(_local_3.itemID == _local_2)
                     {
                        _local_4 = HatchTaskXMLInfo.getMapPro(_local_3.itemID,_local_6);
                        for each(_local_5 in _local_4)
                        {
                           if(!HatchTaskManager.getTaskProStatus(_local_3.obtainTime,_local_5))
                           {
                              mapSoulBeadTaskDo(_local_3,_local_5);
                           }
                        }
                     }
                  }
               }
            }
         });
      }
      
      private static function finishHatchTask(obtainTime:uint, id:uint, pro:uint) : Function
      {
         var func:Function = function(evt:MouseEvent):void
         {
            var mc:MovieClip = null;
            var playMC:MovieClip = null;
            mc = null;
            playMC = null;
            mc = evt.currentTarget as MovieClip;
            playMC = mc["mc"];
            if(playMC == null)
            {
               mc.buttonMode = false;
               mc.mouseEnabled = false;
               mc.mouseChildren = false;
               mc.removeEventListener(MouseEvent.CLICK,finishHatchTask);
            }
            playMC.gotoAndPlay(2);
            playMC.addEventListener(Event.ENTER_FRAME,function(evt:Event):void
            {
               if(playMC.currentFrame == playMC.totalFrames)
               {
                  playMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  HatchTaskManager.complete(obtainTime,id,pro,function(_arg_1:Boolean):void
                  {
                     var _local_2:String = null;
                     if(_arg_1)
                     {
                        Alarm.show("元神珠已经吸收了足够的精华能量，现在可以放入元神转化仪中转化了。");
                     }
                     else
                     {
                        _local_2 = HatchTaskXMLInfo.getProDes(id,pro);
                        Alarm.show(_local_2);
                     }
                  });
                  playMC.gotoAndStop(1);
                  mc.buttonMode = false;
                  mc.mouseEnabled = false;
                  mc.mouseChildren = false;
                  mc.removeEventListener(MouseEvent.CLICK,finishHatchTask);
               }
            });
         };
         return func;
      }
   }
}

