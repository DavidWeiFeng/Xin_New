package com.robot.app.petCollectBounds
{
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class PetMc extends Sprite
   {
      
      private var _bg:Sprite;
      
      private var _txt:TextField;
      
      private var _petId:int = 0;
      
      public function PetMc()
      {
         super();
         this._bg = UIManager.getSprite("Storage_ToolBar_Itembg");
         addChild(this._bg);
         this._txt = new TextField();
         this._txt.textColor = 16777215;
         this._txt.autoSize = TextFieldAutoSize.RIGHT;
         this._txt.mouseEnabled = false;
         this._txt.filters = [new GlowFilter(16750848,1,3.5,3.5,10)];
      }
      
      public function setup(petID:int) : void
      {
         var onLoadIcon:Function;
         this.removeTip();
         this._petId = petID;
         onLoadIcon = function(o:DisplayObject):void
         {
            var _showMc:MovieClip = null;
            _showMc = null;
            _showMc = o as MovieClip;
            if(Boolean(_showMc))
            {
               _showMc.gotoAndStop("rightdown");
               _showMc.addEventListener(Event.ENTER_FRAME,function():void
               {
                  var _local_2:MovieClip = _showMc.getChildAt(0) as MovieClip;
                  if(Boolean(_local_2))
                  {
                     _local_2.gotoAndStop(1);
                     _showMc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  }
               });
               DisplayUtil.align(_showMc,new Rectangle(0,0,_bg.width,_bg.height),AlignType.MIDDLE_CENTER);
               addChild(_showMc);
               _txt.text = PetXMLInfo.getName(petID);
               DisplayUtil.align(_txt,new Rectangle(_bg.width,0,_bg.width,_bg.height),AlignType.BOTTOM_RIGHT);
               addChild(_txt);
            }
         };
         ResourceManager.getResource(ClientConfig.getPetSwfPath(petID),onLoadIcon,"pet");
      }
      
      public function get mainMc() : Sprite
      {
         return this._bg;
      }
      
      public function removeTip() : void
      {
         if(this._petId != 0)
         {
            ToolTipManager.remove(this);
         }
      }
   }
}

