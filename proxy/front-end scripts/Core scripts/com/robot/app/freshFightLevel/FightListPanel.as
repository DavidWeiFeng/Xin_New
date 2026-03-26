package com.robot.app.freshFightLevel
{
   import com.robot.core.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.*;
   
   public class FightListPanel
   {
      
      private static var app:ApplicationDomain;
      
      private static var panel:Sprite;
      
      private static var infoA:Array;
      
      private static var addEventA:Array;
      
      private static var b1:Boolean = false;
      
      private static const defaultLength:uint = 3;
      
      private static const dedaultPoint:Point = new Point(84.5,24.6);
      
      private static const rec:Rectangle = new Rectangle(dedaultPoint.x,dedaultPoint.y,0,107);
      
      private static const move:uint = 3;
      
      public function FightListPanel()
      {
         super();
      }
      
      public static function show(_arg_1:DisplayObjectContainer, _arg_2:Point, _arg_3:ApplicationDomain, _arg_4:Array) : void
      {
         var _local_5:int = 0;
         if(!panel)
         {
            panel = new (_arg_3.getDefinition("UI_ListPanel") as Class)() as Sprite;
         }
         infoA = _arg_4;
         addEventA = new Array();
         addItem(_arg_3);
         while(_local_5 < defaultLength)
         {
            panel.getChildByName("item" + _local_5)["txt"].text = String(infoA[_local_5].itemId);
            if(infoA[_local_5].isOpen == true)
            {
               panel.getChildByName("item" + _local_5)["maskMc"].visible = false;
               (panel.getChildByName("item" + _local_5) as MovieClip).buttonMode = true;
               panel.getChildByName("item" + _local_5).addEventListener(MouseEvent.CLICK,onClickHandler);
               addEventA.push(_local_5);
            }
            _local_5++;
         }
         panel.alpha = 0;
         _arg_1.addChild(panel);
         panel.x = _arg_2.x;
         panel.y = _arg_2.y;
         panel.addEventListener(Event.ENTER_FRAME,onEnterHandler);
         b1 = true;
      }
      
      private static function addItem(_arg_1:ApplicationDomain) : void
      {
         var _local_2:Sprite = null;
         var _local_3:int = 0;
         while(_local_3 < defaultLength)
         {
            _local_2 = new (_arg_1.getDefinition("UI_Item") as Class)() as Sprite;
            _local_2.x = 25;
            _local_2.y = 17 + (_local_2.height + 13) * _local_3;
            _local_2.name = "item" + _local_3;
            panel.addChild(_local_2);
            _local_3++;
         }
      }
      
      private static function addDataToItem(_arg_1:Array) : void
      {
      }
      
      private static function onEnterHandler(_arg_1:Event) : void
      {
         if(panel.alpha < 1)
         {
            panel.alpha += 0.2;
         }
         else
         {
            panel.removeEventListener(Event.ENTER_FRAME,onEnterHandler);
            b1 = false;
         }
      }
      
      private static function onClickHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:String = (_arg_1.currentTarget as MovieClip)["txt"].text;
         var _local_3:uint = uint(_local_2.slice(0,1));
         if(_local_2.length == 1)
         {
            _local_3 = uint(_local_2);
         }
         else
         {
            _local_3 = uint(uint(_local_2.slice(0,1)) + 1);
         }
         choice(_local_3);
      }
      
      private static function choice(_arg_1:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.FRESH_CHOICE_FIGHT_LEVEL,onChoiceSuccessHandler);
         SocketConnection.send(CommandID.FRESH_CHOICE_FIGHT_LEVEL,_arg_1);
      }
      
      private static function onChoiceSuccessHandler(_arg_1:*) : void
      {
         SocketConnection.removeCmdListener(CommandID.FRESH_CHOICE_FIGHT_LEVEL,onChoiceSuccessHandler);
         var _local_2:FreshChoiceLevelRequestInfo = _arg_1.data as FreshChoiceLevelRequestInfo;
         FightLevelModel.setBossId = _local_2.getBossId;
         FightLevelModel.setCurLevel = _local_2.getLevel;
         MainManager.actorInfo.curFreshStage = _local_2.getLevel;
         FightChoiceController.hide();
         MapManager.changeMap(600);
      }
      
      public static function destroy() : void
      {
         var _local_1:int = 0;
         if(Boolean(addEventA))
         {
            if(addEventA.length > 0)
            {
               _local_1 = 0;
               while(_local_1 < addEventA.length)
               {
                  panel.getChildByName("item" + addEventA[_local_1]).removeEventListener(MouseEvent.CLICK,onClickHandler);
                  _local_1++;
               }
            }
         }
         if(b1)
         {
            panel.removeEventListener(Event.ENTER_FRAME,onEnterHandler);
         }
         DisplayUtil.removeForParent(panel);
         panel = null;
         infoA = null;
         app = null;
         addEventA = null;
      }
   }
}

