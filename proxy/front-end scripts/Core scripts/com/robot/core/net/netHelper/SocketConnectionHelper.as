package com.robot.core.net.netHelper
{
   import com.robot.core.net.SocketConnection;
   import flash.utils.Dictionary;
   import mx.collections.ArrayList;
   import org.taomee.ds.HashSet;
   import org.taomee.events.SocketErrorEvent;
   import org.taomee.events.SocketEvent;
   
   public class SocketConnectionHelper
   {
      
      private static var _sendCmdList:Dictionary = new Dictionary();
      
      private static var _currentProcessCommandIDs:HashSet = new HashSet();
      
      public function SocketConnectionHelper()
      {
         super();
      }
      
      public static function sendCommandByQueue(param1:SendQueueItemVo) : void
      {
         var _loc2_:ArrayList = _sendCmdList[param1.cmdID];
         if(null == _loc2_)
         {
            _loc2_ = new ArrayList();
            _sendCmdList[param1.cmdID] = _loc2_;
         }
         _loc2_.addItem(param1);
         checkWaitCmids();
      }
      
      private static function checkWaitCmids() : void
      {
         var _loc1_:Object = null;
         var _loc2_:ArrayList = null;
         for(_loc1_ in _sendCmdList)
         {
            if(!_currentProcessCommandIDs.contains(_loc1_))
            {
               _loc2_ = _sendCmdList[_loc1_];
               if(_loc2_.length > 0)
               {
                  processSendItemVo(_loc2_.getItemAt(0) as SendQueueItemVo);
               }
            }
         }
      }
      
      private static function processSendItemVo(param1:SendQueueItemVo) : void
      {
         var backFun:Function = null;
         var errorFun:Function = null;
         var sendItemVo:SendQueueItemVo = null;
         var timeOutFun:Function = null;
         sendItemVo = param1;
         if(_currentProcessCommandIDs.contains(sendItemVo.cmdID))
         {
            return;
         }
         backFun = function(param1:SocketEvent):void
         {
            prodessEnd(sendItemVo);
            if(null != sendItemVo.callBackFun)
            {
               sendItemVo.callBackFun(param1);
            }
         };
         errorFun = function(param1:SocketErrorEvent):void
         {
            prodessEnd(sendItemVo);
            if(null != sendItemVo.errorHandleFun)
            {
               sendItemVo.errorHandleFun(param1);
            }
         };
         _currentProcessCommandIDs.add(sendItemVo.cmdID);
         SocketConnection.sendWithCallback2(sendItemVo.cmdID,backFun,sendItemVo.args,errorFun);
         timeOutFun = function():void
         {
            prodessEnd(sendItemVo);
            if(null != sendItemVo.errorHandleFun)
            {
               sendItemVo.errorHandleFun(null);
            }
         };
      }
      
      private static function prodessEnd(param1:SendQueueItemVo) : void
      {
         _currentProcessCommandIDs.remove(param1.cmdID);
         var _loc2_:ArrayList = _sendCmdList[param1.cmdID];
         _loc2_.removeItem(param1);
         checkWaitCmids();
      }
   }
}

