package com.robot.core.aimat
{
   import com.robot.core.config.xml.AimatXMLInfo;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.mode.IAimatSprite;
   import org.taomee.ds.HashMap;
   import org.taomee.manager.TickManager;
   import org.taomee.utils.Utils;
   
   public class AimatStateManamer
   {
      
      private static const PATH:String = "com.robot.app.aimat.state.AimatState_";
      
      private var _list:HashMap = new HashMap();
      
      private var _obj:IAimatSprite;
      
      public function AimatStateManamer(_arg_1:IAimatSprite)
      {
         super();
         this._obj = _arg_1;
         TickManager.addListener(this.loop);
      }
      
      public function execute(_arg_1:AimatInfo) : void
      {
         var _local_2:Class = null;
         var _local_3:IAimatState = null;
         var _local_4:IAimatState = this._list.remove(_arg_1.id);
         if(Boolean(_local_4))
         {
            _local_4.destroy();
            _local_4 = null;
         }
         var _local_5:uint = AimatXMLInfo.getIsStage(_arg_1.id);
         if(_local_5 != 0)
         {
            _local_2 = Utils.getClass(PATH + _local_5);
         }
         else
         {
            _local_2 = Utils.getClass(PATH + _arg_1.id.toString());
         }
         if(Boolean(_local_2))
         {
            _local_3 = new _local_2();
            this._list.add(_arg_1.id,_local_3);
            _local_3.execute(this._obj,_arg_1);
         }
      }
      
      public function isType(_arg_1:uint) : Boolean
      {
         return this._list.containsKey(_arg_1);
      }
      
      public function clear() : void
      {
         this._list.eachValue(function(_arg_1:IAimatState):void
         {
            _arg_1.destroy();
            _arg_1 = null;
         });
         this._list.clear();
      }
      
      public function destroy() : void
      {
         TickManager.removeListener(this.loop);
         this.clear();
         this._list = null;
         this._obj = null;
      }
      
      private function loop() : void
      {
         if(this._list.isEmpty())
         {
            return;
         }
         this._list.each2(function(_arg_1:uint, _arg_2:IAimatState):void
         {
            if(_arg_2.isFinish)
            {
               _list.remove(_arg_1);
               _arg_2.destroy();
               _arg_2 = null;
            }
         });
      }
   }
}

