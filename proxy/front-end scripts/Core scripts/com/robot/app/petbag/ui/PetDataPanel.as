package com.robot.app.petbag.ui
{
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.pet.PetGenderIconManager;
   import com.robot.core.ui.skillBtn.*;
   import flash.display.*;
   import flash.filters.*;
   import flash.geom.Point;
   import flash.text.TextField;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class PetDataPanel
   {
      
      private static const MAX:int = 4;
      
      private var skillBtnArray:Array;
      
      private var _mainUI:Sprite;
      
      private var _numTxt:TextField;
      
      private var _nameTxt:TextField;
      
      private var _levelTxt:TextField;
      
      private var _upExpTxt:TextField;
      
      private var _dvTxt:TextField;
      
      private var _charaTxt:TextField;
      
      private var _effectTxt:TextField;
      
      private var _getTimeTxt:TextField;
      
      private var _shinylevelTxt:TextField;
      
      private var _showMc:MovieClip;
      
      private var _generIcon:MovieClip;
      
      private var _generlevel:TextField;
      
      private var _attackTxt:TextField;
      
      private var _defenceTxt:TextField;
      
      private var _saTxt:TextField;
      
      private var _sdTxt:TextField;
      
      private var _speedTxt:TextField;
      
      private var _hpTxt:TextField;
      
      private var ev_attackTxt:TextField;
      
      private var ev_defenceTxt:TextField;
      
      private var ev_saTxt:TextField;
      
      private var ev_sdTxt:TextField;
      
      private var ev_speedTxt:TextField;
      
      private var ev_hpTxt:TextField;
      
      private var _id:uint;
      
      private var _petInfo:PetInfo;
      
      private var attMc:SimpleButton;
      
      private var des1:String = "<font color=\'#ffff00\'>";
      
      private var des2:String = "</font>";
      
      private var des3:String = "<font color=\'#ffffff\' size=\'14\'>";
      
      private var des4:String = "<font color=\'#ffff00\' size=\'13.9\'>";
      
      protected var filte:GlowFilter;
      
      public var eff:Object;
      
      public function PetDataPanel(_arg_1:Sprite)
      {
         var _local_2:uint = 0;
         this.skillBtnArray = [];
         this.filte = new GlowFilter(3355443,0.9,3,3,3.1);
         super();
         this._mainUI = _arg_1;
         this._numTxt = this._mainUI["numTxt"];
         this._nameTxt = this._mainUI["nameTxt"];
         this._levelTxt = this._mainUI["levelTxt"];
         this._upExpTxt = this._mainUI["upExpTxt"];
         this._charaTxt = this._mainUI["charaTxt"];
         this._effectTxt = this._mainUI["effectTxt"];
         this._shinylevelTxt = this._mainUI["shinylevelTxt"];
         this._getTimeTxt = this._mainUI["getTimeTxt"];
         this._attackTxt = this._mainUI["attackTxt"];
         this._defenceTxt = this._mainUI["defenceTxt"];
         this._saTxt = this._mainUI["saTxt"];
         this._sdTxt = this._mainUI["sdTxt"];
         this._speedTxt = this._mainUI["speedTxt"];
         this._hpTxt = this._mainUI["hpTxt"];
         this.ev_attackTxt = this._mainUI["ev_attackTxt"];
         this._dvTxt = this._mainUI["dvTxt"];
         this.ev_defenceTxt = this._mainUI["ev_defenceTxt"];
         this.ev_saTxt = this._mainUI["ev_saTxt"];
         this.ev_sdTxt = this._mainUI["ev_sdTxt"];
         this.ev_speedTxt = this._mainUI["ev_speedTxt"];
         this.ev_hpTxt = this._mainUI["ev_hpTxt"];
         this._generIcon = this._mainUI["gener_icon"];
         this._generlevel = this._generIcon["generlevel"];
         this._generIcon.visible = false;
         this.addEffectBg();
         SocketConnection.addCmdListener(CommandID.EAT_SPECIAL_MEDICINE,this.onEatSplItem);
      }
      
      public function clearInfo() : void
      {
         this._dvTxt.text = "";
         this._numTxt.text = "";
         this._nameTxt.text = "";
         this._levelTxt.text = "";
         this._upExpTxt.text = "";
         this._charaTxt.text = "";
         this._getTimeTxt.text = "";
         this._attackTxt.text = "";
         this._defenceTxt.text = "";
         this._saTxt.text = "";
         this._sdTxt.text = "";
         this._speedTxt.text = "";
         this._hpTxt.text = "";
         this._shinylevelTxt.text = " ";
         ToolTipManager.remove(this._charaTxt);
         this._effectTxt.text = "";
         ToolTipManager.remove(this._effectTxt);
         if(this._id != 0)
         {
            ResourceManager.cancel(ClientConfig.getPetSwfPath(this._petInfo.skinID != 0 ? this._petInfo.skinID : this._id),this.onShowComplete);
         }
         if(Boolean(this._showMc))
         {
            DisplayUtil.removeForParent(this._showMc);
            this._showMc = null;
         }
         if(Boolean(this.skillBtnArray))
         {
            this.clearOldBtn();
         }
      }
      
      public function show(_arg_1:PetInfo) : void
      {
         var ability:PetEffectInfo = null;
         var normal:PetEffectInfo = null;
         var j:uint = 0;
         var _local_2:NormalSkillBtn = null;
         var eff:PetEffectInfo = null;
         var _local_4:int = 0;
         var level:String = null;
         var starLv:int = 0;
         var desc:String = null;
         var intro:String = null;
         this._petInfo = _arg_1;
         this._numTxt.htmlText = "序号:" + this.des1 + StringUtil.renewZero(_arg_1.id.toString(),3) + this.des2;
         this._nameTxt.htmlText = "名字:" + this.des1 + PetXMLInfo.getName(_arg_1.id) + this.des2;
         this._levelTxt.htmlText = "等级:" + this.des1 + _arg_1.level.toString() + this.des2;
         this._dvTxt.htmlText = "个体:" + this.des1 + _arg_1.dv.toString() + this.des2;
         this._upExpTxt.htmlText = "升级所需经验值:" + this.des1 + (_arg_1.nextLvExp - _arg_1.exp).toString() + this.des2;
         this._charaTxt.htmlText = "性格:" + this.des1 + NatureXMLInfo.getName(_arg_1.nature) + this.des2;
         ToolTipManager.remove(this._charaTxt);
         ToolTipManager.add(this._charaTxt,NatureXMLInfo.getDesc(_arg_1.nature));
         ToolTipManager.remove(this._effectTxt);
         var s:Array = ["<font color=\'#9ED900\' size=\'18\'>","<font color=\'#F3D3E7\' size=\'18\'>","<font color=\'#F2BE45\' size=\'18\'>"];
         if(this._petInfo.isshiny != 0)
         {
            level = "";
            for(j = 0; j < 3; j++)
            {
               if(this._petInfo.shiny.level + 1 > j)
               {
                  level += s[j] + "◆" + this.des2;
               }
               else
               {
                  level += "<font color=\'#00ff00\' size=\'18\'>" + "◇" + this.des2;
               }
            }
            this._shinylevelTxt.htmlText = "炫彩:" + level;
         }
         else
         {
            this._shinylevelTxt.htmlText = " ";
         }
         if(this._petInfo.generation != 0)
         {
            this._generIcon.visible = true;
            this._generlevel.visible = true;
            this._generlevel.text = String(this._petInfo.generation);
         }
         else
         {
            this._generlevel.visible = false;
            this._generIcon.visible = false;
         }
         j = 0;
         while(j < this._petInfo.effectList.length)
         {
            eff = this._petInfo.effectList[j] as PetEffectInfo;
            if(eff.effectID != 177)
            {
               if(eff.status == 1 || eff.status == 4)
               {
                  if(eff.effectID > 400 && eff.effectID <= 420)
                  {
                     ability = eff;
                  }
                  else
                  {
                     normal = eff;
                  }
               }
            }
            j++;
         }
         this._effectTxt.htmlText = "";
         if(Boolean(ability))
         {
            this._effectTxt.htmlText = "特质:" + this.des1 + PetEffectXMLInfo.getEffect(ability.effectID,ability.args) + this.des2;
            ToolTipManager.add(this._effectTxt,PetEffectXMLInfo.getEffectDes(ability.effectID,ability.args));
         }
         if(Boolean(normal))
         {
            level = "";
            starLv = int(PetEffectXMLInfo.getStarLevel(normal.effectID,normal.args));
            if(starLv > 0)
            {
               for(j = 0; j < starLv; j++)
               {
                  level += "<font color=\'#FFDE59\'>" + "◆" + "</font>";
               }
            }
            desc = String(PetEffectXMLInfo.getEffect(normal.effectID,normal.args));
            intro = String(PetEffectXMLInfo.getIntros(desc).getValue(starLv));
            this._effectTxt.htmlText = "特性:" + this.des1 + desc + this.des2;
            ToolTipManager.add(this._effectTxt,level + "\n" + intro);
         }
         this._getTimeTxt.htmlText = "获得时间:" + this.des1 + StringUtil.timeFormat(_arg_1.catchTime) + this.des2;
         this.showIcon(_arg_1.effectList);
         if(Boolean(this.attMc))
         {
            DisplayUtil.removeForParent(this.attMc);
            this.attMc = null;
         }
         this.attMc = UIManager.getButton("Icon_PetType_" + PetXMLInfo.getType(_arg_1.id));
         if(Boolean(this.attMc))
         {
            this.attMc.x = this._nameTxt.x + this._nameTxt.textWidth + 10;
            this.attMc.y = this._nameTxt.y;
            this._mainUI.addChild(this.attMc);
            PetGenderIconManager.addIcon(this._mainUI,new Point(this.attMc.x + 20,this.attMc.y),this._petInfo.gender);
         }
         else
         {
            PetGenderIconManager.hideIcon(this._mainUI);
         }
         if(this._id != 0)
         {
            ResourceManager.cancel(ClientConfig.getPetSwfPath(this._petInfo.skinID != 0 ? this._petInfo.skinID : this._id),this.onShowComplete);
         }
         if(Boolean(this._showMc))
         {
            DisplayUtil.removeForParent(this._showMc);
            this._showMc = null;
         }
         this._id = _arg_1.id;
         ResourceManager.getResource(ClientConfig.getPetSwfPath(this._petInfo.skinID != 0 ? this._petInfo.skinID : this._id),this.onShowComplete,"pet");
         this._attackTxt.htmlText = "攻击:" + this.des1 + _arg_1.attack.toString() + this.des2;
         this._defenceTxt.htmlText = "防御:" + this.des1 + _arg_1.defence.toString() + this.des2;
         this._saTxt.htmlText = "特攻:" + this.des1 + _arg_1.s_a.toString() + this.des2;
         this._sdTxt.htmlText = "特防:" + this.des1 + _arg_1.s_d.toString() + this.des2;
         this._speedTxt.htmlText = "速度:" + this.des1 + _arg_1.speed.toString() + this.des2;
         this._hpTxt.htmlText = "体力:" + this.des1 + _arg_1.hp.toString() + this.des2;
         this.ev_attackTxt.htmlText = this.des1 + _arg_1.ev_attack.toString() + this.des2;
         this.ev_defenceTxt.htmlText = this.des1 + _arg_1.ev_defence.toString() + this.des2;
         this.ev_saTxt.htmlText = this.des1 + _arg_1.ev_sa.toString() + this.des2;
         this.ev_sdTxt.htmlText = this.des1 + _arg_1.ev_sd.toString() + this.des2;
         this.ev_speedTxt.htmlText = this.des1 + _arg_1.ev_sp.toString() + this.des2;
         this.ev_hpTxt.htmlText = this.des1 + _arg_1.ev_hp.toString() + this.des2;
         this.clearOldBtn();
         while(_local_4 < MAX)
         {
            if(_local_4 < _arg_1.skillNum)
            {
               _local_2 = new NormalSkillBtn(_arg_1.skillArray[_local_4].id,_arg_1.skillArray[_local_4].pp);
            }
            else
            {
               _local_2 = new NormalSkillBtn();
            }
            _local_2.x = 18 + (_local_2.width + 10) * (_local_4 % 2);
            _local_2.y = 218 + (_local_2.height + 8) * Math.floor(_local_4 / 2);
            this.skillBtnArray.push(_local_2);
            this._mainUI.addChild(_local_2);
            _local_4++;
         }
         this._mainUI.visible = true;
      }
      
      private function addEffectBg() : void
      {
         var _local_1:PetEffectIcon = null;
         var _local_2:int = 0;
         while(_local_2 < 5)
         {
            _local_1 = new PetEffectIcon();
            _local_1.name = "icon" + _local_2;
            this._mainUI.addChild(_local_1);
            _local_1.x = 147 + (_local_1.width + 3) * _local_2;
            _local_1.y = 5;
            _local_2++;
         }
      }
      
      private function showIcon(_arg_1:Array) : void
      {
         var _local_2:PetEffectIcon = null;
         var _local_3:int = 0;
         while(_local_3 < 5)
         {
            _local_2 = this._mainUI.getChildByName("icon" + _local_3) as PetEffectIcon;
            _local_2.clear();
            if(_local_3 < _arg_1.length)
            {
               _local_2.show(_arg_1[_local_3] as PetEffectInfo);
            }
            _local_3++;
         }
      }
      
      private function clearOldBtn() : void
      {
         var _local_1:NormalSkillBtn = null;
         for each(_local_1 in this.skillBtnArray)
         {
            _local_1.destroy();
            _local_1 = null;
         }
         this.skillBtnArray = [];
      }
      
      public function hide() : void
      {
         this._mainUI.visible = false;
      }
      
      private function onShowComplete(_arg_1:DisplayObject) : void
      {
         var _local_2:Number = NaN;
         var _local_3:ColorMatrixFilter = null;
         var _local_4:Array = null;
         var _local_5:GlowFilter = null;
         var _local_6:Array = null;
         var _local_21:MovieClip = null;
         this._showMc = _arg_1 as MovieClip;
         if(Boolean(this._showMc))
         {
            _local_2 = this._showMc.width >= 75 ? 1.5 : 2;
            this._showMc.scaleX = _local_2;
            this._showMc.scaleY = _local_2;
            this._showMc.x = 70;
            this._showMc.y = 110;
            DisplayUtil.stopAllMovieClip(this._showMc);
            if(this._petInfo.isshiny != 0)
            {
               this._showMc.filters = [this.filte,this._petInfo.shiny.GetGlowFilter,this._petInfo.shiny.GetColorMatrixFilter];
               _local_21 = CoreAssetsManager.getMovieClip("pk_flash_mc");
               _local_21.play();
               this._showMc.addChildAt(_local_21,0);
            }
            this._mainUI.addChild(this._showMc);
         }
      }
      
      private function onEatSplItem(evt:SocketEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_PET_INFO,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,arguments.callee);
            PetManager.upDate();
         });
         SocketConnection.send(CommandID.GET_PET_INFO,this._petInfo.catchTime);
      }
   }
}

