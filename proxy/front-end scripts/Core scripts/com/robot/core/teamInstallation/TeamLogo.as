package com.robot.core.teamInstallation
{
   import com.robot.core.info.team.ITeamLogoInfo;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import org.taomee.utils.*;
   
   public class TeamLogo extends Sprite
   {
      
      private var sprite:Sprite;
      
      public var teamID:uint;
      
      private var _info:ITeamLogoInfo;
      
      public function TeamLogo()
      {
         super();
         this.sprite = new Sprite();
         this.sprite.mouseChildren = false;
         this.sprite.graphics.beginFill(0,0);
         this.sprite.graphics.drawRect(0,0,72,72);
         addChild(this.sprite);
      }
      
      public function set info(_arg_1:ITeamLogoInfo) : void
      {
         var _local_2:MovieClip = null;
         this.teamID = _arg_1.teamID;
         this._info = _arg_1;
         DisplayUtil.removeAllChild(this.sprite);
         var _local_3:String = _arg_1.logoWord;
         if(_arg_1.logoBg != 10000)
         {
            _local_2 = TaskIconManager.getIcon("icon_bg_" + _arg_1.logoBg) as MovieClip;
            this.alignIcon(_local_2);
            this.sprite.addChild(_local_2);
         }
         var _local_4:MovieClip = TaskIconManager.getIcon("icon_" + _arg_1.logoIcon) as MovieClip;
         var _local_5:MovieClip = _local_4["colorMC"];
         DisplayUtil.FillColor(_local_5,_arg_1.logoColor);
         var _local_6:MovieClip = CoreAssetsManager.getMovieClip("txtMC");
         var _local_7:TextField = _local_6["txt"];
         _local_7.textColor = _arg_1.txtColor;
         _local_7.text = _local_3;
         _local_7.selectable = false;
         _local_4.addChild(_local_6);
         DisplayUtil.align(_local_6,_local_5.getRect(_local_4),AlignType.MIDDLE_CENTER);
         if(Boolean(_local_2))
         {
            _local_2.addChild(_local_4);
         }
         else
         {
            this.alignIcon(_local_4);
            this.sprite.addChild(_local_4);
         }
      }
      
      private function alignIcon(_arg_1:DisplayObject) : void
      {
         var _local_2:Rectangle = null;
         _local_2 = _arg_1.getRect(_arg_1);
         _arg_1.x = (this.sprite.width - _arg_1.width) / 2 - _local_2.x;
         _arg_1.y = (this.sprite.height - _arg_1.height) / 2 - _local_2.y;
      }
      
      public function destroy() : void
      {
         this.sprite = null;
      }
      
      public function clone() : TeamLogo
      {
         var _local_1:TeamLogo = new TeamLogo();
         _local_1.info = this._info;
         return _local_1;
      }
   }
}

