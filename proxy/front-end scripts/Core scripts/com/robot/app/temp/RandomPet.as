package com.robot.app.temp
{
   import com.robot.core.mode.ActionSpriteModel;
   import flash.display.*;
   import flash.geom.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class RandomPet extends ActionSpriteModel
   {
      
      private static var oldStr:String;
      
      public static const RED:String = "red";
      
      public static const WHITE:String = "white";
      
      private var colors:Array = [RED,WHITE];
      
      private var mc:MovieClip;
      
      private var array:Array = ["down","leftdown","left","leftup","up","rightup","right","rightdown"];
      
      private var posArray:Array = [];
      
      public var type:String;
      
      public function RandomPet()
      {
         super();
         this.type = this.colors[Math.floor(Math.random() * this.colors.length)];
         this.loadUI();
         this.x = int(Math.random() * 524) + 235;
         this.y = int(Math.random() * 234) + 155;
      }
      
      public function get color() : String
      {
         return this.type;
      }
      
      private function loadUI() : void
      {
         ResourceManager.getResource("resource/pet/swf/npc.swf",function(_arg_1:DisplayObject):void
         {
            var _local_2:ColorTransform = null;
            var _local_3:MovieClip = _arg_1 as MovieClip;
            if(type == RED)
            {
               _local_2 = new ColorTransform();
               _local_2.color = 16711680;
               _local_3.transform.colorTransform = _local_2;
            }
            addChild(_local_3);
            _local_3.gotoAndStop(array[Math.floor(Math.random() * array.length)]);
         },"pet");
      }
      
      override public function destroy() : void
      {
         super.destroy();
         DisplayUtil.removeForParent(this);
         this.mc = null;
      }
   }
}

