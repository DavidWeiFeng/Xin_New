package com.robot.app.mapProcess
{
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.events.*;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.utils.*;
   
   public class MapProcess_326 extends BaseMapProcess
   {
      
      private var my_timedProcess:Number;
      
      private var my_timedProcess2:Number;
      
      private var stoneChannel:SoundChannel;
      
      public function MapProcess_326()
      {
         super();
      }
      
      override protected function init() : void
      {
         conLevel["npcMC"].visible = false;
         conLevel["weisikeMC"].visible = false;
         conLevel["haidaoMC"].visible = false;
         this.initForAll();
      }
      
      private function initForAll() : void
      {
         conLevel["icon" + 0].buttonMode = true;
         conLevel["icon" + 0].addEventListener(MouseEvent.MOUSE_DOWN,this.startDr);
         conLevel["icon" + 0].addEventListener(MouseEvent.MOUSE_UP,this.stopDr);
         var _local_1:uint = 1;
         while(_local_1 < 3)
         {
            conLevel["icon" + _local_1]["mc"].gotoAndStop(1);
            _local_1++;
         }
         animatorLevel["anmain"]["mc"].gotoAndStop(1);
         var _local_2:uint = 1;
         while(_local_2 < 7)
         {
            conLevel["soundPlay" + _local_2].gotoAndStop(1);
            conLevel["soundPlay" + _local_2].buttonMode = true;
            conLevel["soundPlay" + _local_2].addEventListener(MouseEvent.CLICK,this.soudPlay);
            _local_2++;
         }
      }
      
      private function startDr(_arg_1:MouseEvent) : void
      {
         _arg_1.currentTarget.startDrag();
      }
      
      private function stopDr(_arg_1:MouseEvent) : void
      {
         var _local_2:Sound = null;
         var _local_3:Sound = null;
         var _local_5:uint = 0;
         _arg_1.currentTarget.stopDrag();
         var _local_4:String = _arg_1.currentTarget.name;
         _local_4 = _local_4.substr(4,_local_4.length);
         while(_local_5 < 3)
         {
            if(Boolean(conLevel["icon" + _local_4].hitTestObject(conLevel["Nicon" + _local_5])))
            {
               if(uint(_local_4) == _local_5)
               {
                  _local_2 = MapLibManager.getSound("downStone");
                  this.stoneChannel = _local_2.play();
                  this.stoneChannel.addEventListener(Event.SOUND_COMPLETE,this.otherSound);
                  _arg_1.currentTarget["mc"].gotoAndPlay(2);
                  if(_local_5 == 0)
                  {
                     _arg_1.currentTarget.x = 383;
                     _arg_1.currentTarget.y = 425;
                     conLevel["icon" + 0].mouseEnabled = false;
                     conLevel["icon" + 0].mouseChildren = false;
                     conLevel["icon" + 0].removeEventListener(MouseEvent.MOUSE_DOWN,this.startDr);
                     conLevel["icon" + 0].removeEventListener(MouseEvent.MOUSE_UP,this.stopDr);
                     conLevel["icon" + 1].buttonMode = true;
                     conLevel["icon" + 1]["mc"].gotoAndStop(1);
                     conLevel["icon" + 1].addEventListener(MouseEvent.MOUSE_DOWN,this.startDr);
                     conLevel["icon" + 1].addEventListener(MouseEvent.MOUSE_UP,this.stopDr);
                     return;
                  }
                  if(_local_5 == 1)
                  {
                     _arg_1.currentTarget.x = 577;
                     _arg_1.currentTarget.y = 465;
                     conLevel["icon" + 1].mouseEnabled = false;
                     conLevel["icon" + 1].mouseChildren = false;
                     conLevel["icon" + 1].removeEventListener(MouseEvent.MOUSE_DOWN,this.startDr);
                     conLevel["icon" + 1].removeEventListener(MouseEvent.MOUSE_UP,this.stopDr);
                     conLevel["icon" + 2].buttonMode = true;
                     conLevel["icon" + 2]["mc"].gotoAndStop(1);
                     conLevel["icon" + 2].addEventListener(MouseEvent.MOUSE_DOWN,this.startDr);
                     conLevel["icon" + 2].addEventListener(MouseEvent.MOUSE_UP,this.stopDr);
                     return;
                  }
                  this.stoneChannel.removeEventListener(Event.SOUND_COMPLETE,this.otherSound);
                  _arg_1.currentTarget.x = 748;
                  _arg_1.currentTarget.y = 326;
                  _local_3 = MapLibManager.getSound("openStone");
                  _local_3.play();
                  conLevel["icon" + 2].mouseEnabled = false;
                  conLevel["icon" + 2].mouseChildren = false;
                  conLevel["icon" + 2].removeEventListener(MouseEvent.MOUSE_DOWN,this.startDr);
                  conLevel["icon" + 2].removeEventListener(MouseEvent.MOUSE_UP,this.stopDr);
                  LevelManager.closeMouseEvent();
                  this.my_timedProcess = setTimeout(this.setTime1,2000);
                  return;
               }
            }
            _local_5++;
         }
      }
      
      private function otherSound(_arg_1:Event) : void
      {
         this.stoneChannel.removeEventListener(Event.SOUND_COMPLETE,this.otherSound);
         var _local_2:Sound = MapLibManager.getSound("lightSound");
         _local_2.play();
      }
      
      private function setTime1() : void
      {
         clearTimeout(this.my_timedProcess);
         animatorLevel["anmain"]["mc"].gotoAndPlay(1);
         animatorLevel["anmain"].gotoAndPlay(2);
         this.my_timedProcess2 = setTimeout(this.setTime2,5000);
      }
      
      private function setTime2() : void
      {
         LevelManager.openMouseEvent();
         clearTimeout(this.my_timedProcess2);
         MapManager.changeMap(327);
      }
      
      private function soudPlay(_arg_1:MouseEvent) : void
      {
         var _local_2:String = _arg_1.currentTarget.name;
         _local_2 = _local_2.substr(9,_local_2.length);
         var _local_3:uint = uint(_local_2);
         conLevel["soundPlay" + _local_3].gotoAndPlay(1);
         var _local_4:Sound = MapLibManager.getSound("oneSound" + _local_3);
         _local_4.play();
      }
      
      private function destroyForAll() : void
      {
         var _local_1:uint = 1;
         while(_local_1 < 7)
         {
            conLevel["soundPlay" + _local_1].removeEventListener(MouseEvent.CLICK,this.soudPlay);
            _local_1++;
         }
         if(Boolean(this.stoneChannel))
         {
            this.stoneChannel.removeEventListener(Event.SOUND_COMPLETE,this.otherSound);
            this.stoneChannel.stop();
            this.stoneChannel = null;
         }
         if(this.my_timedProcess > 0)
         {
            clearTimeout(this.my_timedProcess);
            this.my_timedProcess = 0;
         }
         if(this.my_timedProcess2 > 0)
         {
            clearTimeout(this.my_timedProcess2);
            this.my_timedProcess2 = 0;
         }
      }
      
      override public function destroy() : void
      {
         this.destroyForAll();
      }
   }
}

