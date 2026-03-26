package com.robot.app.petCollectBounds
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.filters.*;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class PetCollectBoundsPanel2 extends Sprite
   {
      
      private var _mainUI:MovieClip;
      
      private var _closeBtn:SimpleButton;
      
      private var _awardBtn:SimpleButton;
      
      private var _petList:HashMap = new HashMap();
      
      private var _mainPetMc:PetMc;
      
      private var _petMcList:Array = [];
      
      private var _canGetBonus:Boolean = true;
      
      public function PetCollectBoundsPanel2()
      {
         super();
         this._petList.add(275,[51,83,89,145,178,198,249]);
      }
      
      public function show() : void
      {
         this._mainUI = UIManager.getMovieClip("DoodleMc");
         this._closeBtn = this._mainUI["closeBtn"];
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this._mainUI["preBtn"].visible = this._mainUI["nextBtn"].visible = false;
         this._awardBtn = UIManager.getMovieClip("instructorDialog")["awardBtn"];
         this._awardBtn.x = this._mainUI.width / 2 - 50;
         this._awardBtn.y = this._mainUI["preBtn"].y + this._mainUI["preBtn"].height / 2 - this._awardBtn.height / 2;
         this._awardBtn.addEventListener(MouseEvent.CLICK,this.getBonus);
         this._mainUI.addChild(this._awardBtn);
         addChild(this._mainUI);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(this);
         PetManager.addEventListener(PetEvent.STORAGE_LIST,this.setupPetMC);
         PetManager.getStorageList();
      }
      
      private function setupPetMC(_arg_1:PetEvent) : void
      {
         var _local_3:int = 0;
         var _local_4:PetMc = null;
         var _local_5:Array = null;
         var _local_6:ColorMatrixFilter = null;
         var _local_2:int = 0;
         PetManager.removeEventListener(PetEvent.STORAGE_LIST,this.setupPetMC);
         this._mainPetMc = new PetMc();
         this._mainPetMc.width = this._mainPetMc.height = 120;
         this._mainPetMc.x = 80;
         this._mainPetMc.y = this._mainUI.height / 2 - this._mainPetMc.height / 2;
         this._mainPetMc.setup(this._petList.getKeys()[0]);
         this._mainUI.addChild(this._mainPetMc);
         for each(_local_3 in this._petList.getValue(this._petList.getKeys()[0]))
         {
            _local_4 = new PetMc();
            _local_4.width = _local_4.height = _local_4.width * 1.2;
            _local_4.x = 260 + (_local_4.width + 20) * (_local_2 % 3);
            _local_4.y = 100 + (_local_4.height + 20) * (_local_2 / 3);
            _local_4.setup(_local_3);
            this._mainUI.addChild(_local_4);
            if(!this.checkPetId(_local_3))
            {
               _local_5 = [0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
               _local_6 = new ColorMatrixFilter(_local_5);
               _local_4.filters = [_local_6];
               this._canGetBonus = false;
            }
            this._petMcList.push(_local_4);
            _local_2++;
         }
      }
      
      public function checkPetId(_arg_1:int) : Boolean
      {
         var _local_3:Boolean = false;
         var _local_2:int = int(PetXMLInfo.getPetClass(_arg_1));
         while(PetXMLInfo.getPetClass(_arg_1) == _local_2)
         {
            if(PetManager.containsBagForID(_arg_1) || PetManager.containsStorageForID(_arg_1))
            {
               _local_3 = true;
               break;
            }
            _arg_1++;
         }
         return _local_3;
      }
      
      public function getBonus(_arg_1:MouseEvent) : void
      {
         if(!this._canGetBonus)
         {
            NpcTipDialog.show("\r<p align=\'center\'>你还未完成本期精灵收集计划哟~</p>",null,NpcTipDialog.NONO);
         }
         else
         {
            SocketConnection.addCmdListener(CommandID.PET_COLLECT,this.onHandler);
            SocketConnection.send(CommandID.PET_COLLECT,2,275);
         }
      }
      
      private function onHandler(e:SocketEvent) : void
      {
         var by:ByteArray = null;
         var catchTime:uint = 0;
         var id:uint = 0;
         id = 0;
         SocketConnection.removeCmdListener(CommandID.PET_COLLECT,this.onHandler);
         by = e.data as ByteArray;
         id = by.readUnsignedInt();
         catchTime = by.readUnsignedInt();
         if(PetManager.length >= 6)
         {
            PetInStorageAlert.show(id,"你获得了" + TextFormatUtil.getRedTxt(PetXMLInfo.getName(id)) + "，你可以在你基地的精灵仓库中找到它。");
         }
         else
         {
            PetManager.addEventListener(PetEvent.ADDED,function(_arg_1:PetEvent):void
            {
               PetManager.removeEventListener(PetEvent.ADDED,arguments.callee);
               PetInBagAlert.show(id,TextFormatUtil.getRedTxt(PetXMLInfo.getName(id)) + "已经放入了你的精灵背包。");
            });
            PetManager.setIn(catchTime,1);
         }
      }
      
      public function destroy() : void
      {
      }
      
      private function showPage(_arg_1:int) : void
      {
      }
      
      private function nextPage(_arg_1:MouseEvent) : void
      {
      }
      
      private function prePage(_arg_1:MouseEvent) : void
      {
      }
      
      private function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
         LevelManager.openMouseEvent();
         this._awardBtn.removeEventListener(MouseEvent.CLICK,this.getBonus);
         this.destroy();
      }
   }
}

