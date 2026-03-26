package gs.plugins
{
   import flash.display.*;
   import flash.geom.ColorTransform;
   import gs.*;
   
   public class ColorTransformPlugin extends TintPlugin
   {
      
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
      
      public function ColorTransformPlugin()
      {
         super();
         this.propName = "colorTransform";
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         var _local_4:String = null;
         var _local_5:Number = NaN;
         if(!(_arg_1 is DisplayObject))
         {
            return false;
         }
         var _local_6:ColorTransform = _arg_1.transform.colorTransform;
         if(_arg_2.isTV == true)
         {
            _arg_2 = _arg_2.exposedVars;
         }
         for(_local_4 in _arg_2)
         {
            if(_local_4 == "tint" || _local_4 == "color")
            {
               if(_arg_2[_local_4] != null)
               {
                  _local_6.color = int(_arg_2[_local_4]);
               }
            }
            else if(!(_local_4 == "tintAmount" || _local_4 == "exposure" || _local_4 == "brightness"))
            {
               _local_6[_local_4] = _arg_2[_local_4];
            }
         }
         if(!isNaN(_arg_2.tintAmount))
         {
            _local_5 = _arg_2.tintAmount / (1 - (_local_6.redMultiplier + _local_6.greenMultiplier + _local_6.blueMultiplier) / 3);
            _local_6.redOffset *= _local_5;
            _local_6.greenOffset *= _local_5;
            _local_6.blueOffset *= _local_5;
            _local_6.redMultiplier = _local_6.greenMultiplier = _local_6.blueMultiplier = 1 - _arg_2.tintAmount;
         }
         else if(!isNaN(_arg_2.exposure))
         {
            _local_6.redOffset = _local_6.greenOffset = _local_6.blueOffset = 255 * (_arg_2.exposure - 1);
            _local_6.redMultiplier = _local_6.greenMultiplier = _local_6.blueMultiplier = 1;
         }
         else if(!isNaN(_arg_2.brightness))
         {
            _local_6.redOffset = _local_6.greenOffset = _local_6.blueOffset = Math.max(0,(_arg_2.brightness - 1) * 255);
            _local_6.redMultiplier = _local_6.greenMultiplier = _local_6.blueMultiplier = 1 - Math.abs(_arg_2.brightness - 1);
         }
         if(_arg_3.exposedVars.alpha != undefined && _arg_2.alphaMultiplier == undefined)
         {
            _local_6.alphaMultiplier = _arg_3.exposedVars.alpha;
            _arg_3.killVars({"alpha":1});
         }
         init(_arg_1 as DisplayObject,_local_6);
         return true;
      }
   }
}

