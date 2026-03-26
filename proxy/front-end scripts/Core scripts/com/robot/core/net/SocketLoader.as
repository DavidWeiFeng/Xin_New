package com.robot.core.net
{
   import flash.events.EventDispatcher;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   
   [Event(name="complete",type="org.taomee.events.SocketEvent")]
   public class SocketLoader extends EventDispatcher
   {
      
      private static var _map:HashMap = new HashMap();
      
      public var extData:Object;
      
      private var _cmdID:uint;
      
      public function SocketLoader(_arg_1:uint)
      {
         var _local_2:Array = null;
         super();
         this._cmdID = _arg_1;
         if(Boolean(this._cmdID))
         {
            _local_2 = _map.getValue(this._cmdID);
            if(_local_2 == null)
            {
               _local_2 = [];
               _map.add(this._cmdID,_local_2);
            }
            _local_2.push(this);
         }
      }
      
      private static function onEvent(_arg_1:SocketEvent) : void
      {
         var _local_2:SocketLoader = null;
         var _local_3:Array = _map.getValue(_arg_1.headInfo.cmdID);
         if(Boolean(_local_3))
         {
            _local_2 = _local_3.shift() as SocketLoader;
            if(_local_3.length == 0)
            {
               _map.remove(_arg_1.headInfo.cmdID);
               SocketConnection.removeCmdListener(_arg_1.headInfo.cmdID,onEvent);
            }
            if(Boolean(_local_2))
            {
               _local_2.dispatchEvent(new SocketEvent(SocketEvent.COMPLETE,_arg_1.headInfo,_arg_1.data));
            }
         }
      }
      
      public function get cmdID() : uint
      {
         return this._cmdID;
      }
      
      public function load(... _args) : void
      {
         if(this._cmdID == 0)
         {
            throw new Error("命令ID不能为0");
         }
         SocketConnection.addCmdListener(this._cmdID,onEvent);
         SocketConnection.send_2(this._cmdID,_args);
      }
      
      public function canel() : void
      {
         var _local_1:Array = null;
         var _local_2:int = 0;
         if(Boolean(this._cmdID))
         {
            _local_1 = _map.getValue(this._cmdID);
            if(Boolean(_local_1))
            {
               _local_2 = _local_1.indexOf(this);
               if(_local_2 != -1)
               {
                  _local_1.splice(_local_2,1);
                  if(_local_1.length == 0)
                  {
                     _map.remove(this._cmdID);
                     SocketConnection.removeCmdListener(this._cmdID,onEvent);
                  }
               }
            }
         }
      }
      
      public function destroy() : void
      {
         this.canel();
         this.extData = null;
      }
   }
}

