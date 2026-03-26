package com.robot.core.ui.loading.loadingstyle
{
   import com.robot.core.config.*;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class TitlePercentLoading extends TitleOnlyLoading implements ILoadingStyle
   {
      
      private static const KEY:String = "titlePercentLoading";
      
      protected var percentText:TextField;
      
      protected var percentBar:MovieClip;
      
      private var barWidth:Number;
      
      private var showCloseBtn:Boolean = true;
      
      private var tipTxt:TextField;
      
      private var timer:Timer;
      
      public function TitlePercentLoading(_arg_1:DisplayObjectContainer, _arg_2:String = "Loading...", _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_2,this.showCloseBtn);
         this.percentText = loadingMC["perNum"];
         this.percentText.text = "0%";
         this.tipTxt = loadingMC["tip_txt"];
         this.percentBar = loadingMC["loadingBar"];
         this.barWidth = 200;
         var _local_4:Array = UpdateConfig.loadingArray.slice();
         var _local_5:uint = Math.floor(Math.random() * _local_4.length);
         this.tipTxt.text = _local_4[_local_5];
         this.timer = new Timer(2000);
         this.timer.addEventListener(TimerEvent.TIMER,this.changeTip);
         this.timer.start();
      }
      
      private function changeTip(_arg_1:TimerEvent) : void
      {
         var _local_2:Array = UpdateConfig.loadingArray.slice();
         var _local_3:uint = Math.floor(Math.random() * _local_2.length);
         this.tipTxt.text = _local_2[_local_3];
      }
      
      override public function changePercent(_arg_1:Number, _arg_2:Number) : void
      {
         super.changePercent(_arg_1,_arg_2);
         this.percentText.text = percent + "%";
         this.percentBar.gotoAndStop(percent);
      }
      
      override public function setTitle(_arg_1:String) : void
      {
         super.setTitle(_arg_1);
      }
      
      override public function destroy() : void
      {
         this.percentText = null;
         this.percentBar = null;
         this.tipTxt = null;
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.changeTip);
         this.timer = null;
         super.destroy();
      }
      
      override protected function getKey() : String
      {
         return KEY;
      }
   }
}

