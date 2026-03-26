package com.robot.core.ui.skillBtn
{
   import com.robot.core.config.xml.*;
   import com.robot.core.info.skillEffectInfo.*;
   import com.robot.core.manager.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import org.taomee.utils.*;
   
   public class SkillInfoTip
   {
      
      private static var tipMC:MovieClip;
      
      private static var timer:Timer;
      
      setup();
      
      public function SkillInfoTip()
      {
         super();
      }
      
      private static function setup() : void
      {
         timer = new Timer(5000,1);
         timer.addEventListener(TimerEvent.TIMER,timerHandler);
      }
      
      public static function show(_arg_1:uint) : void
      {
         var _local_2:String = null;
         var _local_3:String = null;
         var _local_4:TextField = null;
         var _local_5:uint = 0;
         var _local_6:uint = 0;
         var _local_7:String = null;
         var _local_13:uint = 0;
         if(!tipMC)
         {
            tipMC = UIManager.getMovieClip("ui_SkillTipPanel");
            tipMC.mouseChildren = false;
            tipMC.mouseEnabled = false;
         }
         timer.stop();
         timer.reset();
         var _local_8:String = SkillXMLInfo.getName(_arg_1);
         var _local_9:uint = uint(SkillXMLInfo.getCategory(_arg_1));
         var _local_10:Array = SkillXMLInfo.getSideEffects(_arg_1);
         var _local_11:Array = SkillXMLInfo.getSideEffectArgs(_arg_1);
         if(_local_9 == 1)
         {
            _local_2 = "#FF0000";
         }
         else if(_local_9 == 2)
         {
            _local_2 = "#FF99FF";
         }
         else
         {
            _local_2 = "#99ff00";
         }
         var _local_12:String = "<font color=\'#ffff00\'>" + _local_8 + "</font>  " + "<font color=\'" + _local_2 + "\'>(" + SkillXMLInfo.getCategoryName(_arg_1) + ")</font>\r";
         _local_12 += "\r";
         var _local_14:Number = SkillXMLInfo.getDamage(_arg_1);
         if(_local_9 == 1 || _local_9 == 2)
         {
            _local_12 += "威力：" + _local_14 + "\r";
         }
         var _local_15:int = SkillXMLInfo.getCritRate(_arg_1);
         if(_local_15 > 0)
         {
            _local_12 += "会心率：" + Number(_local_15 / 16 * 100) + "%\r";
         }
         var _local_16:int = SkillXMLInfo.getPriority(_arg_1);
         if(_local_16 != 0)
         {
            if(_local_16 > 0)
            {
               _local_12 += "先制+" + _local_16 + "\r";
            }
            else
            {
               _local_12 += "先制" + _local_16 + "\r";
            }
         }
         var _local_17:Number = SkillXMLInfo.hitP(_arg_1);
         var _local_18:Number = SkillXMLInfo.getMustHit(_arg_1);
         if(_local_18 == 1)
         {
            _local_12 += "必中";
         }
         else
         {
            _local_12 += "命中率：" + _local_17 + "%";
         }
         _local_12 += "\r";
         try
         {
            for each(_local_3 in _local_10)
            {
               if(_local_3 != "")
               {
                  _local_5 = uint(1000000 + uint(_local_3));
                  _local_6 = EffectInfoManager.getArgsNum(uint(_local_3));
                  _local_7 = EffectInfoManager.getInfo(uint(_local_3),_local_11.slice(_local_13,_local_13 + _local_6));
                  _local_13 += _local_6;
                  _local_12 += "\r" + _local_7;
               }
            }
         }
         catch(e:Error)
         {
         }
         _local_4 = tipMC["info_txt"];
         _local_4.autoSize = TextFieldAutoSize.LEFT;
         _local_4.wordWrap = true;
         _local_4.htmlText = _local_12;
         tipMC["bgMC"].height = _local_4.height + 20;
         tipMC["bgMC"].width = _local_4.width + 20;
         MainManager.getStage().addChild(tipMC);
         tipMC.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
         timer.start();
      }
      
      private static function timerHandler(_arg_1:TimerEvent) : void
      {
         hide();
      }
      
      public static function hide() : void
      {
         if(Boolean(tipMC))
         {
            tipMC.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
            DisplayUtil.removeForParent(tipMC);
         }
      }
      
      private static function enterFrameHandler(_arg_1:Event) : void
      {
         if(MainManager.getStage().mouseX + tipMC.width + 20 >= MainManager.getStageWidth())
         {
            tipMC.x = MainManager.getStageWidth() - tipMC.width - 10;
         }
         else
         {
            tipMC.x = MainManager.getStage().mouseX + 10;
         }
         if(MainManager.getStage().mouseY + tipMC.height + 20 >= MainManager.getStageHeight())
         {
            tipMC.y = MainManager.getStageHeight() - tipMC.height - 10;
         }
         else
         {
            tipMC.y = MainManager.getStage().mouseY + 20;
         }
      }
   }
}

