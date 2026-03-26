package com.robot.app.npc.npcClass
{
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.INpc;
   import com.robot.core.npc.NpcInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class NpcClass_8 implements INpc
   {
      
      private var _curNpcModel:NpcModel;
      
      public function NpcClass_8(_arg_1:NpcInfo, _arg_2:DisplayObject)
      {
         super();
         this._curNpcModel = new NpcModel(_arg_1,_arg_2 as Sprite);
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

