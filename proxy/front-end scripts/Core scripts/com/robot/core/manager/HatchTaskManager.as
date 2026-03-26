package com.robot.core.manager
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.HatchTask.*;
   import com.robot.core.manager.HatchTask.*;
   import com.robot.core.net.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   
   public class HatchTaskManager
   {
      
      private static var _instance:EventDispatcher;
      
      private static var _beadMap:HashMap = new HashMap();
      
      private static var _taskMap:HashMap = new HashMap();
      
      private static var b:Boolean = true;
      
      public function HatchTaskManager()
      {
         super();
      }
      
      public static function getTaskStatusList(func:Function) : void
      {
         var ts:Array = null;
         ts = null;
         getSoulBeadList(function(arr:Array):void
         {
            var upLoop:Function = function(i:int):void
            {
               var catchTime:uint = 0;
               if(i == ts.length)
               {
                  if(func != null)
                  {
                     func(_beadMap);
                  }
                  ts = null;
                  b = true;
                  return;
               }
               catchTime = uint(ts[i][0]);
               SocketConnection.addCmdListener(CommandID.GET_SOUL_BEAD_BUF,function(_arg_1:SocketEvent):void
               {
                  var _local_3:uint = 0;
                  var _local_4:Boolean = false;
                  var _local_11:uint = 0;
                  var _local_12:uint = 0;
                  SocketConnection.removeCmdListener(CommandID.GET_SOUL_BEAD_BUF,arguments.callee);
                  var _local_5:HatchTaskBufInfo = _arg_1.data as HatchTaskBufInfo;
                  var _local_6:uint = _local_5.obtainTm;
                  var _local_7:ByteArray = _local_5.buf;
                  var _local_8:Array = [];
                  while(_local_3 < 10)
                  {
                     _local_4 = Boolean(_local_7.readBoolean());
                     _local_8.push(_local_4);
                     _local_3++;
                  }
                  var _local_9:HatchTaskInfo = new HatchTaskInfo(_local_6,ts[i][1],_local_8,func);
                  var _local_10:uint = uint(HatchTaskXMLInfo.getTaskProCount(ts[i][1]));
                  while(_local_12 < _local_10)
                  {
                     if(_local_8[_local_12] == true)
                     {
                        _local_11++;
                     }
                     _local_12++;
                  }
                  if(_local_11 == _local_10)
                  {
                     _local_9.isComplete = true;
                  }
                  _beadMap.add(_local_6,_local_9);
                  ++i;
                  upLoop(i);
               });
               SocketConnection.send(CommandID.GET_SOUL_BEAD_BUF,catchTime);
            };
            if(!b)
            {
               return;
            }
            b = false;
            ts = arr;
            if(ts == null)
            {
               return;
            }
            upLoop(0);
         });
      }
      
      public static function getSoulBeadList(func:Function) : void
      {
         var arr:Array = null;
      }
      
      public static function complete(obtainTm:uint, id:uint, pro:uint, event:Function = null) : void
      {
         var arr:Array = null;
         var info:HatchTaskInfo = null;
         var proCnt:uint = 0;
         var i:uint = 0;
         arr = null;
         info = null;
         var hi:HatchTaskInfo = _beadMap.getValue(obtainTm);
         arr = hi.statusList;
         info = new HatchTaskInfo(obtainTm,id,arr,event);
         if(HatchTaskXMLInfo.isDir(id))
         {
            proCnt = uint(HatchTaskXMLInfo.getTaskProCount(id));
            i = 0;
            while(i < proCnt)
            {
               setTaskProStatus(obtainTm,proCnt,true,function(_arg_1:Boolean):void
               {
                  arr.push(_arg_1);
                  info.isComplete = true;
                  _beadMap.add(obtainTm,info);
                  event(info.isComplete);
               });
               i++;
            }
         }
         else
         {
            setTaskProStatus(obtainTm,pro,true,function(_arg_1:Boolean):void
            {
               var _local_4:uint = 0;
               arr[pro] = _arg_1;
               var _local_2:HatchTaskInfo = info;
               _beadMap.add(obtainTm,info);
               var _local_3:uint = uint(HatchTaskXMLInfo.getTaskProCount(id));
               while(_local_4 < _local_3)
               {
                  if(HatchTaskManager.getTaskList(obtainTm)[_local_4] != true)
                  {
                     event(info.isComplete);
                     return;
                  }
                  _local_4++;
               }
               info.isComplete = true;
               _beadMap.add(obtainTm,info);
               event(info.isComplete);
            });
         }
      }
      
      public static function getTaskProStatus(_arg_1:uint, _arg_2:uint) : Boolean
      {
         var _local_3:HatchTaskInfo = _beadMap.getValue(_arg_1);
         return _local_3.statusList[_arg_2];
      }
      
      public static function setTaskProStatus(obtainTime:uint, pro:uint, status:Boolean, func:Function = null) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_SOUL_BEAD_BUF,function(e:SocketEvent):void
         {
            var info:HatchTaskBufInfo = null;
            var obtainTime:uint = 0;
            var buf:ByteArray = null;
            var sts:Boolean = false;
            SocketConnection.removeCmdListener(CommandID.GET_SOUL_BEAD_BUF,arguments.callee);
            info = e.data as HatchTaskBufInfo;
            obtainTime = info.obtainTm;
            buf = info.buf;
            sts = buf.readBoolean();
            buf.position = pro;
            buf.writeBoolean(status);
            buf.length = 10;
            SocketConnection.addCmdListener(CommandID.SET_SOUL_BEAD_BUF,function(_arg_1:SocketEvent):void
            {
               SocketConnection.removeCmdListener(CommandID.SET_SOUL_BEAD_BUF,arguments.callee);
               if(func != null)
               {
                  func(status);
               }
            });
            SocketConnection.send(CommandID.SET_SOUL_BEAD_BUF,obtainTime,buf);
         });
         SocketConnection.send(CommandID.GET_SOUL_BEAD_BUF,obtainTime);
      }
      
      public static function getProStatus(obtainTime:uint, pro:uint, func:Function = null) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_SOUL_BEAD_BUF,function(_arg_1:SocketEvent):void
         {
            var _local_3:Boolean = false;
            SocketConnection.removeCmdListener(CommandID.GET_SOUL_BEAD_BUF,arguments.callee);
            var _local_4:HatchTaskBufInfo = _arg_1.data as HatchTaskBufInfo;
            var _local_5:uint = _local_4.obtainTm;
            var _local_6:ByteArray = _local_4.buf;
            _local_6.position = pro;
            _local_3 = _local_6.readBoolean();
            if(func != null)
            {
               func(_local_3);
            }
         });
         SocketConnection.send(CommandID.GET_SOUL_BEAD_BUF,obtainTime);
      }
      
      public static function get beadMap() : HashMap
      {
         return _beadMap;
      }
      
      public static function addHeadStatus(_arg_1:uint, _arg_2:HatchTaskInfo) : void
      {
         _beadMap.add(_arg_1,_arg_2);
         HatchTaskMapManager.getSoulBeadStatusMap(_beadMap);
      }
      
      public static function removeHeadStatus(_arg_1:uint) : void
      {
         _beadMap.remove(_arg_1);
         HatchTaskMapManager.getSoulBeadStatusMap(_beadMap);
      }
      
      public static function getTaskList(_arg_1:uint) : Array
      {
         var _local_2:HatchTaskInfo = _beadMap.getValue(_arg_1);
         return _local_2.statusList;
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(_instance == null)
         {
            _instance = new EventDispatcher();
         }
         return _instance;
      }
      
      public static function addListener(_arg_1:String, _arg_2:uint, _arg_3:uint, _arg_4:Function) : void
      {
         getInstance().addEventListener(_arg_1 + "_" + _arg_2.toString() + "_" + _arg_3.toString(),_arg_4);
      }
      
      public static function removeListener(_arg_1:String, _arg_2:uint, _arg_3:uint, _arg_4:Function) : void
      {
         getInstance().removeEventListener(_arg_1 + "_" + _arg_2.toString() + "_" + _arg_3.toString(),_arg_4);
      }
      
      public static function dispatchEvent(_arg_1:String, _arg_2:uint, _arg_3:uint, _arg_4:Array = null) : void
      {
      }
      
      public static function hasListener(_arg_1:String, _arg_2:uint, _arg_3:uint) : Boolean
      {
         return getInstance().hasEventListener(_arg_1 + "_" + _arg_2.toString() + "_" + _arg_3.toString());
      }
   }
}

