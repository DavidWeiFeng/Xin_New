package com.robot.app.automaticFight
{
   import com.robot.app.fightNote.*;
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.fightInfo.*;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetSkillInfo;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.TextField;
   import flash.utils.*;
   import org.taomee.component.bgFill.*;
   import org.taomee.component.containers.*;
   import org.taomee.component.control.*;
   import org.taomee.component.layout.*;
   import org.taomee.effect.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class AutomaticFightManager
   {
      
      private static var times:uint;
      
      private static var icon:MovieClip;
      
      private static var tipMC:VBox;
      
      private static var txt:TextField;
      
      private static var fightTipMC:MovieClip;
      
      private static var stateLabel:MLabel;
      
      private static var redLabel:MLabel;
      
      public static const ON:uint = 1;
      
      public static const OFF:uint = 0;
      
      private static var _isClear:Boolean = true;
      
      private static var isCanOnOff:Boolean = true;
      
      private static var isStopBuf:Boolean = false;
      
      public function AutomaticFightManager()
      {
         super();
      }
      
      public static function showFightTips() : void
      {
         var _local_1:SimpleButton = null;
         if(!fightTipMC)
         {
            fightTipMC = CoreAssetsManager.getMovieClip("lib_fightTip_mc");
            _local_1 = fightTipMC["stopBtn"];
            _local_1.addEventListener(MouseEvent.CLICK,closeTipMC);
            DisplayUtil.align(fightTipMC,null,AlignType.MIDDLE_CENTER);
         }
         fightTipMC["txt"].text = MainManager.actorInfo.autoFightTimes.toString();
         MainManager.getStage().addChild(fightTipMC);
      }
      
      private static function closeTipMC(_arg_1:MouseEvent) : void
      {
         isStopBuf = true;
         DisplayUtil.removeForParent(fightTipMC);
      }
      
      public static function subTimes() : void
      {
         if(MainManager.actorInfo.autoFightTimes > 0)
         {
            --MainManager.actorInfo.autoFightTimes;
         }
         showFightTips();
      }
      
      public static function setup() : void
      {
         if(!icon)
         {
            getTipMC();
            icon = TaskIconManager.getIcon("autoFight_icon") as MovieClip;
            icon.gotoAndStop(1);
            icon.filters = [ColorFilter.setGrayscale(),new DropShadowFilter()];
            icon.buttonMode = true;
            icon.addEventListener(MouseEvent.CLICK,clickIocn);
            icon.addEventListener(MouseEvent.ROLL_OVER,overIcon);
            icon.addEventListener(MouseEvent.ROLL_OUT,outIcon);
            icon.mouseChildren = false;
            txt = icon["txt"];
         }
         checkIcon();
         if(isStart)
         {
            icon.gotoAndStop(2);
            icon.filters = [new DropShadowFilter()];
            EventManager.addEventListener(PetFightEvent.FIGHT_RESULT,onFightOver);
            PetManager.addEventListener(PetEvent.UPDATE_INFO,onUpdateInfo);
         }
         EventManager.addEventListener(RobotEvent.AUTO_FIGHT_CHANGE,onAutoFightChange);
      }
      
      private static function onAutoFightChange(_arg_1:RobotEvent) : void
      {
         txt.text = MainManager.actorInfo.autoFightTimes.toString();
         if(MainManager.actorInfo.autoFightTimes == 0)
         {
            hideIcon();
         }
      }
      
      public static function useItem(_arg_1:uint) : void
      {
         SocketConnection.removeCmdListener(CommandID.USE_AUTO_FIGHT_ITEM,onUseItem);
         SocketConnection.addCmdListener(CommandID.USE_AUTO_FIGHT_ITEM,onUseItem);
         SocketConnection.send(CommandID.USE_AUTO_FIGHT_ITEM,_arg_1);
      }
      
      private static function onUseItem(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         MainManager.actorInfo.autoFight = _local_2.readUnsignedInt();
         MainManager.actorInfo.autoFightTimes = _local_2.readUnsignedInt();
         checkIcon();
      }
      
      private static function showIcon() : void
      {
         txt.text = MainManager.actorInfo.autoFightTimes.toString();
         LeftToolBarManager.addIcon(icon);
      }
      
      public static function hideIcon() : void
      {
         LeftToolBarManager.delIcon(icon);
      }
      
      private static function setOnOff(_arg_1:uint) : void
      {
         isCanOnOff = false;
         SocketConnection.removeCmdListener(CommandID.ON_OFF_AUTO_FIGHT,onSetAutoFight);
         SocketConnection.addCmdListener(CommandID.ON_OFF_AUTO_FIGHT,onSetAutoFight);
         SocketConnection.send(CommandID.ON_OFF_AUTO_FIGHT,_arg_1);
      }
      
      private static function onSetAutoFight(_arg_1:SocketEvent) : void
      {
         if(isStopBuf)
         {
            isStopBuf = false;
            _isClear = true;
         }
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         MainManager.actorInfo.autoFight = _local_2.readUnsignedInt();
         MainManager.actorInfo.autoFightTimes = _local_2.readUnsignedInt();
         if(isStart)
         {
            icon.gotoAndStop(2);
            icon.filters = [new DropShadowFilter()];
            EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,onFightOver);
            PetManager.addEventListener(PetEvent.UPDATE_INFO,onUpdateInfo);
         }
         else
         {
            icon.gotoAndStop(1);
            icon.filters = [ColorFilter.setGrayscale(),new DropShadowFilter()];
            EventManager.removeEventListener(PetFightEvent.FIGHT_RESULT,onFightOver);
            PetManager.removeEventListener(PetEvent.UPDATE_INFO,onUpdateInfo);
         }
         isCanOnOff = true;
      }
      
      private static function checkIcon() : void
      {
         if(MainManager.actorInfo.autoFight > 0)
         {
            showIcon();
         }
         else
         {
            hideIcon();
         }
      }
      
      private static function clickIocn(_arg_1:MouseEvent) : void
      {
         if(!isCanOnOff)
         {
            return;
         }
         if(MainManager.actorInfo.autoFight == 3)
         {
            setOnOff(0);
         }
         else
         {
            setOnOff(1);
         }
      }
      
      private static function overIcon(_arg_1:MouseEvent) : void
      {
         var _local_2:Point = icon.localToGlobal(new Point());
         tipMC.x = _local_2.x + 35;
         tipMC.y = _local_2.y + 45;
         if(MainManager.actorInfo.autoFight != 3)
         {
            stateLabel.textColor = 13421772;
            stateLabel.text = "未开启状态";
            redLabel.text = "点击可开启该装置";
         }
         else
         {
            stateLabel.textColor = 52224;
            stateLabel.text = "开启状态";
            redLabel.text = "点击可开关闭装置";
         }
         LevelManager.iconLevel.addChild(tipMC);
      }
      
      private static function outIcon(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(tipMC);
      }
      
      public static function get isStart() : Boolean
      {
         if(isStopBuf)
         {
            return false;
         }
         return MainManager.actorInfo.autoFightTimes > 0 && MainManager.actorInfo.autoFight == 3;
      }
      
      public static function get isClear() : Boolean
      {
         return _isClear;
      }
      
      public static function beginFight(_arg_1:uint, _arg_2:uint) : void
      {
         var _local_3:PetInfo = null;
         var _local_4:uint = 0;
         var _local_5:PetSkillInfo = null;
         if(!isStart || !isClear)
         {
            return;
         }
         if(PetManager.length == 0)
         {
            Alarm.show("你的背包里还没有一只赛尔精灵哦！");
            return;
         }
         var _local_6:Array = PetManager.infos;
         for each(_local_3 in _local_6)
         {
            _local_4 = 0;
            for each(_local_5 in _local_3.skillArray)
            {
               _local_4 += _local_5.pp;
            }
            if(_local_3.hp > 0 && _local_4 > 0)
            {
               MainManager.actorModel.stop();
               LevelManager.closeMouseEvent();
               PetFightModel.defaultNpcID = _arg_2;
               FightInviteManager.fightWithNpc(_arg_1);
               return;
            }
         }
         Alarm.show("你的赛尔精灵没有体力或不能使用技能了，不能出战哦！");
      }
      
      public static function fightOver(_arg_1:Bitmap) : void
      {
         DisplayUtil.removeForParent(_arg_1);
         PetManager.upDate();
      }
      
      private static function onFightOver(_arg_1:PetFightEvent) : void
      {
         if(isStopBuf)
         {
            setOnOff(0);
         }
         _isClear = false;
         DisplayUtil.removeForParent(fightTipMC);
      }
      
      private static function onUpdateInfo(_arg_1:PetEvent) : void
      {
         var _local_2:Array = null;
         var _local_3:PetInfo = null;
         _isClear = true;
         if(isStart)
         {
            _local_2 = PetManager.infos;
            _local_2.sortOn("isDefault",Array.DESCENDING);
            _local_3 = _local_2[0];
            if(_local_3.hp <= _local_3.maxHp / 2)
            {
               PetManager.cureAll(false);
            }
         }
      }
      
      private static function getTipMC() : void
      {
         tipMC = new VBox(-2);
         tipMC.setSizeWH(140,70);
         tipMC.halign = FlowLayout.CENTER;
         tipMC.valign = FlowLayout.MIDLLE;
         tipMC.bgFillStyle = new SoildFillStyle(0,0.8,20,20);
         var _local_1:MLabel = new MLabel("自动战斗器S型");
         _local_1.width = 120;
         _local_1.textColor = 52224;
         _local_1.blod = true;
         stateLabel = new MLabel();
         stateLabel.textColor = 52224;
         redLabel = new MLabel();
         redLabel.textColor = 16776960;
         stateLabel.fontSize = redLabel.fontSize = 12;
         stateLabel.width = redLabel.width = 120;
         tipMC.appendAll(_local_1,stateLabel,redLabel);
      }
   }
}

