package com.robot.core.mode
{
   import com.robot.core.info.NonoInfo;
   import com.robot.core.manager.*;
   import com.robot.core.ui.nono.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class NonoFlyModel extends BobyModel implements INonoModel
   {
      
      private const _url:String = "resource/nono/nonoFlyingMachine1.swf";
      
      private var _people:ActionSpriteModel;
      
      private var _flyMachineMc:MovieClip;
      
      private var _info:NonoInfo;
      
      public function NonoFlyModel(_arg_1:NonoInfo, _arg_2:ActionSpriteModel = null)
      {
         super();
         this._info = _arg_1;
         this._people = _arg_2;
         if(Boolean(_arg_2))
         {
            this._people.sprite.addChildAt(this,0);
            ResourceManager.getResource(this._url,this.onLoadMachineComHandler);
         }
      }
      
      public function set people(_arg_1:ActionSpriteModel) : void
      {
         this._people = _arg_1;
      }
      
      public function get people() : ActionSpriteModel
      {
         return this._people;
      }
      
      public function get info() : NonoInfo
      {
         return this._info;
      }
      
      override public function set direction(_arg_1:String) : void
      {
         if(Boolean(this._flyMachineMc))
         {
            this._flyMachineMc["dirMc"].gotoAndStop(_arg_1);
            this._flyMachineMc["colorMc"].gotoAndStop(_arg_1);
            this._flyMachineMc["fireMc"].gotoAndStop(_arg_1);
         }
      }
      
      public function startPlay() : void
      {
         if(Boolean(this._flyMachineMc))
         {
            setTimeout(function():void
            {
               _flyMachineMc["dirMc"]["mc"].play();
               _flyMachineMc["colorMc"]["mc"].play();
               _flyMachineMc["bgMc"]["mc"].play();
               _flyMachineMc["fireMc"]["mc"].play();
               _flyMachineMc["fireMc"].visible = true;
            },200);
         }
      }
      
      public function stopPlay() : void
      {
         if(Boolean(this._flyMachineMc))
         {
            setTimeout(function():void
            {
               _flyMachineMc["dirMc"]["mc"].stop();
               _flyMachineMc["colorMc"]["mc"].stop();
               _flyMachineMc["bgMc"]["mc"].stop();
               _flyMachineMc["fireMc"]["mc"].stop();
               _flyMachineMc["fireMc"].visible = false;
            },200);
         }
      }
      
      override public function get centerPoint() : Point
      {
         return new Point();
      }
      
      override public function get hitRect() : Rectangle
      {
         return new Rectangle(0,0,0,0);
      }
      
      override public function set visible(_arg_1:Boolean) : void
      {
      }
      
      private function onLoadMachineComHandler(_arg_1:DisplayObject) : void
      {
         if(Boolean(_arg_1))
         {
            this._flyMachineMc = _arg_1 as MovieClip;
            addChild(this._flyMachineMc);
            this.direction = this._people.direction;
            this.stopPlay();
            this.buttonMode = true;
            if(this._info.userID == MainManager.actorID)
            {
               this.addEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
            }
            this.addEventListener(MouseEvent.CLICK,this.onClickHandler);
            DisplayUtil.FillColor(this._flyMachineMc["colorMc"],this._info.color);
         }
      }
      
      private function onClickHandler(_arg_1:MouseEvent) : void
      {
         NonoInfoPanelController.show(this._info);
      }
      
      private function onOverHandler(_arg_1:MouseEvent) : void
      {
         if(this._people.walk.isPlaying)
         {
            return;
         }
         var _local_2:Point = localToGlobal(new Point(0,0));
         NonoShortcut.show(_local_2,this._info,true);
      }
      
      override public function destroy() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
         this.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         if(Boolean(this._flyMachineMc))
         {
            DisplayUtil.removeForParent(this._flyMachineMc);
            this._flyMachineMc = null;
         }
         this._info = null;
         this._people = null;
      }
   }
}

