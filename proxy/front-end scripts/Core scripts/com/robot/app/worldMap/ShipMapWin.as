package com.robot.app.worldMap
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class ShipMapWin extends Sprite
   {
      
      private var mapMC:MovieClip;
      
      private var idArray:Array = [4,5,9,7,6,1,8];
      
      public function ShipMapWin()
      {
         super();
      }
      
      public function show() : void
      {
         var _local_1:MCLoader = null;
         LevelManager.appLevel.addChild(this);
         if(!this.mapMC)
         {
            _local_1 = new MCLoader("resource/shipMap.swf",LevelManager.appLevel,1,"正在打开飞船地图");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,this.onLoad);
            _local_1.doLoad();
         }
         else
         {
            setTimeout(this.initMap,200);
         }
      }
      
      private function onLoad(_arg_1:MCLoadEvent) : void
      {
         this.mapMC = _arg_1.getContent() as MovieClip;
         setTimeout(this.initMap,200);
      }
      
      private function initMap() : void
      {
         var _local_1:SimpleButton = null;
         var _local_3:int = 0;
         addChild(this.mapMC);
         var _local_2:SimpleButton = this.mapMC["closeBtn"];
         _local_2.addEventListener(MouseEvent.CLICK,this.close);
         while(_local_3 < 7)
         {
            _local_1 = this.mapMC.getChildByName("btn_" + _local_3) as SimpleButton;
            _local_1.addEventListener(MouseEvent.CLICK,this.changeMap);
            _local_3++;
         }
      }
      
      private function changeMap(_arg_1:MouseEvent) : void
      {
         var _local_2:String = SimpleButton(_arg_1.currentTarget).name;
         var _local_3:uint = uint(_local_2.substr(-1,1));
         MapManager.changeMap(this.idArray[_local_3]);
         this.close(null);
      }
      
      private function close(_arg_1:MouseEvent) : void
      {
         this.parent.removeChild(this);
      }
   }
}

