package com.robot.app.petbag.ui
{
   import com.robot.core.config.xml.*;
   import com.robot.core.info.pet.PetEffectInfo;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class PetEffectIcon extends Sprite
   {
      
      private var _bgMc:Sprite;
      
      private var _itemId:uint;
      
      private var _path:String = "resource/item/petItem/effectIcon/";
      
      private var _iconMc:MovieClip;
      
      private var _info:PetEffectInfo;
      
      private var _tipMC:MovieClip;
      
      private var _txt:String;
      
      public function PetEffectIcon()
      {
         super();
         this._bgMc = new Sprite();
         this._bgMc.graphics.lineStyle(1,0,1);
         this._bgMc.graphics.beginFill(0,1);
         this._bgMc.graphics.drawRect(0,0,45.5,26);
         this._bgMc.graphics.endFill();
         this._bgMc.alpha = 0;
         this.addChild(this._bgMc);
         this._tipMC = UIManager.getMovieClip("ui_SkillTipPanel");
      }
      
      public function show(_arg_1:PetEffectInfo) : void
      {
         if(this._itemId == 0)
         {
            return;
         }
         this._info = _arg_1;
         this._itemId = this._info.itemId;
         ResourceManager.getResource(this._path + this._itemId + ".swf",this.onLoadComHandler);
      }
      
      private function onLoadComHandler(_arg_1:DisplayObject) : void
      {
         var _local_2:String = null;
         var _local_3:String = null;
         var _local_4:String = null;
         if(Boolean(_arg_1))
         {
            this._iconMc = _arg_1 as MovieClip;
            this.addChild(this._iconMc);
            this._iconMc["txt"].text = this._info.leftCount.toString();
            _local_2 = ItemXMLInfo.getName(this._itemId);
            _local_3 = "剩余使用次数:" + this._info.leftCount.toString();
            _local_4 = PetEffectXMLInfo.getDes(this._itemId);
            this._txt = "<font color=\'#ffff00\' size=\'15\'>" + _local_2 + "</font>\r\r" + "<font color=\'#ff0000\'>" + _local_3 + "</font>\r\r" + "<font color=\'#ffffff\'>" + _local_4 + "</font>";
            this._tipMC["info_txt"].htmlText = this._txt;
            this.addEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
            this.addEventListener(MouseEvent.MOUSE_OUT,this.onOutHandler);
         }
      }
      
      private function onOverHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:Number = this.mouseX;
         var _local_3:Number = this.mouseY;
         var _local_4:Point = this.localToGlobal(new Point(_local_2,_local_3));
         LevelManager.appLevel.addChild(this._tipMC);
         this._tipMC.x = _local_4.x + 15;
         this._tipMC.y = _local_4.y + 15;
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMoveHandler);
      }
      
      private function onOutHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this._tipMC);
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMoveHandler);
      }
      
      public function destroy() : void
      {
         this.clear();
         if(this._itemId != 0)
         {
            ResourceManager.cancelURL(this._path + this._itemId + ".swf");
         }
         this.removeChild(this._bgMc);
         this._bgMc = null;
         this._tipMC = null;
      }
      
      private function onMoveHandler(_arg_1:MouseEvent) : void
      {
         this._tipMC.x = LevelManager.stage.mouseX + 15;
         this._tipMC.y = LevelManager.stage.mouseY + 15;
      }
      
      public function clear() : void
      {
         if(Boolean(this._iconMc))
         {
            this.removeChild(this._iconMc);
            this._iconMc = null;
         }
         this._info = null;
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.onOutHandler);
         if(Boolean(this._tipMC))
         {
            DisplayUtil.removeForParent(this._tipMC);
         }
      }
   }
}

