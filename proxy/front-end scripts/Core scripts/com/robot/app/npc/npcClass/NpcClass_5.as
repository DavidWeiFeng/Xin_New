package com.robot.app.npc.npcClass
{
   import com.robot.core.event.NpcEvent;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.INpc;
   import com.robot.core.npc.NpcInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class NpcClass_5 implements INpc
   {
      
      private var _curNpcModel:NpcModel;
      
      public function NpcClass_5(_arg_1:NpcInfo, _arg_2:DisplayObject)
      {
         super();
         this._curNpcModel = new NpcModel(_arg_1,_arg_2 as Sprite);
         this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onNpcClick);
      }
      
      private function onNpcClick(_arg_1:NpcEvent) : void
      {
      }
      
      public function destroy() : void
      {
         if(Boolean(this._curNpcModel))
         {
            this._curNpcModel.destroy();
            this._curNpcModel = null;
         }
      }
      
      public function get npc() : NpcModel
      {
         return this._curNpcModel;
      }
   }
}

