package com.robot.app.toolBar.pkTool
{
   import com.robot.core.CommandID;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.ShotBehaviorManager;
   import com.robot.core.net.SocketConnection;
   import flash.display.Bitmap;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.ui.Mouse;
   import org.taomee.effect.ColorFilter;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class ShieldMouseIcon extends BasePKMouseIcon implements IPKMouseIcon
   {
      
      private var bmp:Bitmap;
      
      private var isVip:Boolean;
      
      public function ShieldMouseIcon()
      {
         super();
         ToolTipManager.add(this,"超No护盾");
         this.isVip = Boolean(MainManager.actorInfo.vip);
         if(!this.isVip)
         {
            this.mouseChildren = false;
            this.filters = [ColorFilter.setGrayscale()];
         }
      }
      
      override protected function getIcon() : Sprite
      {
         var _local_1:Sprite = new Sprite();
         _local_1.addChild(ShotBehaviorManager.getMovieClip("pk_icon_bg"));
         var _local_2:SimpleButton = ShotBehaviorManager.getButton("pk_icon_nono");
         DisplayUtil.align(_local_2,_local_1.getRect(_local_1),AlignType.MIDDLE_CENTER);
         _local_1.addChild(_local_2);
         return _local_1;
      }
      
      override protected function getMouseIcon() : Sprite
      {
         return new Sprite();
      }
      
      override public function show() : void
      {
         if(!this.isVip)
         {
            this.mouseChildren = false;
            this.filters = [ColorFilter.setGrayscale()];
            return;
         }
         super.show();
         SocketConnection.send(CommandID.TEAM_PK_USE_SHIELD);
         Mouse.show();
      }
   }
}

