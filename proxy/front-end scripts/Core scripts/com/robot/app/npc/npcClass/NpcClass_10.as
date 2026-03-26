package com.robot.app.npc.npcClass
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.core.config.UpdateConfig;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.INpc;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.npc.NpcInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class NpcClass_10 implements INpc
   {
      
      private var _curNpcModel:NpcModel;
      
      private var greenArray:Array = [];
      
      private var green_index:uint = 0;
      
      public function NpcClass_10(_arg_1:NpcInfo, _arg_2:DisplayObject)
      {
         super();
         this.greenArray = UpdateConfig.greenArray.slice();
         this._curNpcModel = new NpcModel(_arg_1,_arg_2 as Sprite);
         (_arg_2 as Sprite).addEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      private function onClickHandler(event:MouseEvent = null) : void
      {
         NpcDialog.show(this.npc.npcInfo.npcId,["小赛尔快来救救我！我要被萨格罗斯欺负死了……"],["我来帮你！","装傻"],[function():void
         {
            FightInviteManager.fightWithBoss("萨格罗斯");
         },null]);
      }
      
      public function destroy() : void
      {
      }
      
      public function get npc() : NpcModel
      {
         return this._curNpcModel;
      }
   }
}

