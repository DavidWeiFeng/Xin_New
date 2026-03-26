package org.taomee.component.bgFill
{
   import flash.display.Sprite;
   import org.taomee.component.UIComponent;
   
   public class SoildFillStyle implements IBgFillStyle
   {
      
      private var fillColor:uint = 16777215;
      
      private var elipseWidth:Number;
      
      private var bgAlpha:Number;
      
      private var bgMC:Sprite;
      
      private var elipseHeight:Number;
      
      public function SoildFillStyle(_arg_1:uint = 16777215, _arg_2:Number = 1, _arg_3:Number = 0, _arg_4:Number = 0)
      {
         super();
         this.fillColor = _arg_1;
         this.bgAlpha = _arg_2;
         this.elipseHeight = _arg_4;
         this.elipseWidth = _arg_3;
      }
      
      public function draw(_arg_1:Sprite) : void
      {
         var _local_2:Number = NaN;
         var _local_3:Number = NaN;
         this.bgMC = _arg_1;
         this.bgMC.graphics.beginFill(this.fillColor,this.bgAlpha);
         _local_2 = UIComponent(this.bgMC.parent).width;
         _local_3 = UIComponent(this.bgMC.parent).height;
         this.bgMC.graphics.drawRoundRect(0,0,_local_2,_local_3,this.elipseWidth,this.elipseHeight);
         this.bgMC.graphics.endFill();
      }
      
      public function clear() : void
      {
         this.bgMC.graphics.clear();
         this.bgMC = null;
      }
      
      public function reDraw() : void
      {
         if(Boolean(this.bgMC))
         {
            this.bgMC.graphics.clear();
         }
         this.draw(this.bgMC);
      }
   }
}

