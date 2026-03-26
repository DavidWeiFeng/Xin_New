package com.robot.core.utils
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   import gs.TweenLite;
   
   public class PanelEffect
   {
      
      private static var _instance:PanelEffect;
      
      public static var Effect_Blinds:String = "Blinds";
      
      public static var Effect_Fade:String = "Fade";
      
      public static var Effect_Fly:String = "Fly";
      
      public static var Effect_Iris:String = "Iris";
      
      public static var Effect_Photo:String = "Photo";
      
      public static var Effect_Rotate:String = "Rotate";
      
      public static var Effect_Squeeze:String = "Squeeze";
      
      public static var Effect_Wipe:String = "Wipe";
      
      public static var Effect_PixelDissolve:String = "PixelDissolve";
      
      public static var Effect_Zoom:String = "Zoom";
      
      private var _maskMC:Shape;
      
      public function PanelEffect(param1:Foo)
      {
         super();
         if(param1 == null)
         {
            throw new Error("该类singleton Model，不可new");
         }
      }
      
      public static function getInstance() : PanelEffect
      {
         return _instance = _instance || new PanelEffect(new Foo());
      }
      
      public function play(param1:Sprite, param2:String, param3:uint = 0, param4:Number = 0.5, param5:Function = null, param6:Function = null) : void
      {
         var containerPanel:Sprite = null;
         var completeHandler:Function = null;
         var pos:Point = null;
         var len:Number = NaN;
         var row:Number = NaN;
         var scale:Number = NaN;
         containerPanel = param1;
         var effectType:String = param2;
         var playType:uint = param3;
         var durationValue:Number = param4;
         completeHandler = param5;
         var easeEffect:Function = param6;
         switch(effectType)
         {
            case Effect_Iris:
               this._maskMC = new Shape();
               this._maskMC.graphics.beginFill(16777215);
               containerPanel.mask = this._maskMC;
               containerPanel["parent"].addChild(this._maskMC);
               this._maskMC.x = containerPanel.x + containerPanel.width / 2;
               this._maskMC.y = containerPanel.y + containerPanel.height / 2;
               pos = new Point(containerPanel.width,containerPanel.height);
               len = pos.length;
               row = len / 2;
               if(playType == 0)
               {
                  this._maskMC.graphics.drawCircle(0,0,1);
                  scale = row;
               }
               else
               {
                  this._maskMC.graphics.drawCircle(0,0,row);
                  scale = 1 / row;
               }
               TweenLite.to(this._maskMC,durationValue,{
                  "scaleX":scale,
                  "scaleY":scale,
                  "ease":easeEffect,
                  "onComplete":function():void
                  {
                     containerPanel["parent"].removeChild(_maskMC);
                     _maskMC = null;
                     containerPanel.mask = null;
                     if(completeHandler != null)
                     {
                        completeHandler();
                     }
                  }
               });
         }
      }
   }
}

class Foo
{
   
   public function Foo()
   {
      super();
   }
}
