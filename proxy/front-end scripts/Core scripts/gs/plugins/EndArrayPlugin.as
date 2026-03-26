package gs.plugins
{
   import flash.display.*;
   import gs.*;
   import gs.utils.tween.*;
   
   public class EndArrayPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
      
      protected var _a:Array;
      
      protected var _info:Array = [];
      
      public function EndArrayPlugin()
      {
         super();
         this.propName = "endArray";
         this.overwriteProps = ["endArray"];
      }
      
      public function init(_arg_1:Array, _arg_2:Array) : void
      {
         this._a = _arg_1;
         var _local_3:int = _arg_2.length - 1;
         while(_local_3 > -1)
         {
            if(_arg_1[_local_3] != _arg_2[_local_3] && _arg_1[_local_3] != null)
            {
               this._info[this._info.length] = new ArrayTweenInfo(_local_3,this._a[_local_3],_arg_2[_local_3] - this._a[_local_3]);
            }
            _local_3--;
         }
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         if(!(_arg_1 is Array) || !(_arg_2 is Array))
         {
            return false;
         }
         this.init(_arg_1 as Array,_arg_2);
         return true;
      }
      
      override public function set changeFactor(_arg_1:Number) : void
      {
         var _local_2:int = 0;
         var _local_3:ArrayTweenInfo = null;
         var _local_5:int = 0;
         var _local_4:Number = NaN;
         if(this.round)
         {
            _local_2 = this._info.length - 1;
            while(_local_2 > -1)
            {
               _local_3 = this._info[_local_2];
               _local_4 = _local_3.start + _local_3.change * _arg_1;
               _local_5 = _local_4 < 0 ? -1 : 1;
               this._a[_local_3.index] = _local_4 % 1 * _local_5 > 0.5 ? int(_local_4) + _local_5 : int(_local_4);
               _local_2--;
            }
         }
         else
         {
            _local_2 = this._info.length - 1;
            while(_local_2 > -1)
            {
               _local_3 = this._info[_local_2];
               this._a[_local_3.index] = _local_3.start + _local_3.change * _arg_1;
               _local_2--;
            }
         }
      }
   }
}

