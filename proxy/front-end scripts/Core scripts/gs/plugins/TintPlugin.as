package gs.plugins
{
   import flash.display.*;
   import flash.geom.*;
   import gs.*;
   import gs.utils.tween.*;
   
   public class TintPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.1;
      
      public static const API:Number = 1;
      
      protected static var _props:Array = ["redMultiplier","greenMultiplier","blueMultiplier","alphaMultiplier","redOffset","greenOffset","blueOffset","alphaOffset"];
      
      protected var _target:DisplayObject;
      
      protected var _ct:ColorTransform;
      
      protected var _ignoreAlpha:Boolean;
      
      public function TintPlugin()
      {
         super();
         this.propName = "tint";
         this.overwriteProps = ["tint"];
      }
      
      public function init(_arg_1:DisplayObject, _arg_2:ColorTransform) : void
      {
         var _local_3:int = 0;
         var _local_4:String = null;
         this._target = _arg_1;
         this._ct = this._target.transform.colorTransform;
         _local_3 = _props.length - 1;
         while(_local_3 > -1)
         {
            _local_4 = _props[_local_3];
            if(this._ct[_local_4] != _arg_2[_local_4])
            {
               _tweens[_tweens.length] = new TweenInfo(this._ct,_local_4,this._ct[_local_4],_arg_2[_local_4] - this._ct[_local_4],"tint",false);
            }
            _local_3--;
         }
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         if(!(_arg_1 is DisplayObject))
         {
            return false;
         }
         var _local_4:ColorTransform = new ColorTransform();
         if(_arg_2 != null && _arg_3.exposedVars.removeTint != true)
         {
            _local_4.color = uint(_arg_2);
         }
         this._ignoreAlpha = true;
         this.init(_arg_1 as DisplayObject,_local_4);
         return true;
      }
      
      override public function set changeFactor(_arg_1:Number) : void
      {
         var _local_2:ColorTransform = null;
         updateTweens(_arg_1);
         if(this._ignoreAlpha)
         {
            _local_2 = this._target.transform.colorTransform;
            this._ct.alphaMultiplier = _local_2.alphaMultiplier;
            this._ct.alphaOffset = _local_2.alphaOffset;
         }
         this._target.transform.colorTransform = this._ct;
      }
   }
}

