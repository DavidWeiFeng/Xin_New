package com.robot.app.mapProcess
{
   import com.robot.app.darkPortal.*;
   import com.robot.app.toolBar.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MapProcess_503 extends BaseMapProcess
   {
      
      private var _petMc:MovieClip;
      
      private var _point:Point = new Point(480,295);
      
      private var _scaleNum:Number = 1.8;
      
      public function MapProcess_503()
      {
         super();
      }
      
      override protected function init() : void
      {
         DarkPortalModel.showPetEnrichBlood();
         ToolBarController.panel.hide();
         LevelManager.iconLevel.visible = false;
         ToolTipManager.add(conLevel["door_0"],"暗黑武斗场");
         ResourceManager.getResource(ClientConfig.getPetSwfPath(DarkPortalModel.curBossId),this.comHandler,"pet");
      }
      
      private function comHandler(_arg_1:DisplayObject) : void
      {
         if(Boolean(_arg_1))
         {
            this._petMc = _arg_1 as MovieClip;
            this.depthLevel.addChild(this._petMc);
            this._petMc.x = this._point.x;
            this._petMc.y = this._point.y;
            this._petMc.scaleX = this._scaleNum;
            this._petMc.scaleY = this._scaleNum;
            this._petMc.buttonMode = true;
            ToolTipManager.add(this._petMc,PetXMLInfo.getName(DarkPortalModel.curBossId));
            this._petMc.addEventListener(MouseEvent.CLICK,this.onPetClickHandler);
         }
      }
      
      private function onPetClickHandler(e:MouseEvent) : void
      {
         this._petMc.removeEventListener(MouseEvent.CLICK,this.onPetClickHandler);
         setTimeout(function():void
         {
            if(Boolean(_petMc))
            {
               _petMc.addEventListener(MouseEvent.CLICK,onPetClickHandler);
            }
         },1000);
         DarkPortalModel.fightDarkProtal(function():void
         {
         });
      }
      
      override public function destroy() : void
      {
         DarkPortalModel.des();
         ToolBarController.panel.show();
         LevelManager.iconLevel.visible = true;
         if(Boolean(this._petMc))
         {
            ToolTipManager.remove(this._petMc);
            this._petMc.removeEventListener(MouseEvent.CLICK,this.onPetClickHandler);
            DisplayUtil.removeForParent(this._petMc);
            this._petMc = null;
         }
         ToolTipManager.remove(conLevel["door_0"]);
      }
      
      public function onLeaveHandler() : void
      {
         DarkPortalModel.leaveDarkProtal();
      }
   }
}

