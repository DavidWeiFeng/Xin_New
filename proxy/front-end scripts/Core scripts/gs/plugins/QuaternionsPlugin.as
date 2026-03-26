package gs.plugins
{
   import gs.*;
   
   public class QuaternionsPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
      
      protected static const _RAD2DEG:Number = 180 / Math.PI;
      
      protected var _target:Object;
      
      protected var _quaternions:Array = [];
      
      public function QuaternionsPlugin()
      {
         super();
         this.propName = "quaternions";
         this.overwriteProps = [];
      }
      
      override public function killProps(_arg_1:Object) : void
      {
         var _local_2:int = this._quaternions.length - 1;
         while(_local_2 > -1)
         {
            if(_arg_1[this._quaternions[_local_2][1]] != undefined)
            {
               this._quaternions.splice(_local_2,1);
            }
            _local_2--;
         }
         super.killProps(_arg_1);
      }
      
      override public function set changeFactor(_arg_1:Number) : void
      {
         var _local_2:int = 0;
         var _local_3:Array = null;
         var _local_4:Number = NaN;
         var _local_5:Number = NaN;
         _local_2 = this._quaternions.length - 1;
         while(_local_2 > -1)
         {
            _local_3 = this._quaternions[_local_2];
            if(_local_3[10] + 1 > 0.000001)
            {
               if(1 - _local_3[10] >= 0.000001)
               {
                  _local_4 = Math.sin(_local_3[11] * (1 - _arg_1)) * _local_3[12];
                  _local_5 = Math.sin(_local_3[11] * _arg_1) * _local_3[12];
               }
               else
               {
                  _local_4 = 1 - _arg_1;
                  _local_5 = _arg_1;
               }
            }
            else
            {
               _local_4 = Math.sin(Math.PI * (0.5 - _arg_1));
               _local_5 = Math.sin(Math.PI * _arg_1);
            }
            _local_3[0].x = _local_4 * _local_3[2] + _local_5 * _local_3[3];
            _local_3[0].y = _local_4 * _local_3[4] + _local_5 * _local_3[5];
            _local_3[0].z = _local_4 * _local_3[6] + _local_5 * _local_3[7];
            _local_3[0].w = _local_4 * _local_3[8] + _local_5 * _local_3[9];
            _local_2--;
         }
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         var _local_4:String = null;
         if(_arg_2 == null)
         {
            return false;
         }
         for(_local_4 in _arg_2)
         {
            this.initQuaternion(_arg_1[_local_4],_arg_2[_local_4],_local_4);
         }
         return true;
      }
      
      public function initQuaternion(_arg_1:Object, _arg_2:Object, _arg_3:String) : void
      {
         var _local_5:Object = null;
         var _local_6:Object = null;
         var _local_4:Number = NaN;
         var _local_7:Number = NaN;
         var _local_8:Number = NaN;
         var _local_9:Number = NaN;
         var _local_10:Number = NaN;
         var _local_11:Number = NaN;
         var _local_12:Number = NaN;
         var _local_13:Number = NaN;
         var _local_14:Number = NaN;
         var _local_15:Number = NaN;
         _local_5 = _arg_1;
         _local_6 = _arg_2;
         _local_7 = Number(_local_5.x);
         _local_8 = Number(_local_6.x);
         _local_9 = Number(_local_5.y);
         _local_10 = Number(_local_6.y);
         _local_11 = Number(_local_5.z);
         _local_12 = Number(_local_6.z);
         _local_13 = Number(_local_5.w);
         _local_14 = Number(_local_6.w);
         _local_4 = _local_7 * _local_8 + _local_9 * _local_10 + _local_11 * _local_12 + _local_13 * _local_14;
         if(_local_4 < 0)
         {
            _local_7 *= -1;
            _local_9 *= -1;
            _local_11 *= -1;
            _local_13 *= -1;
            _local_4 *= -1;
         }
         if(_local_4 + 1 < 0.000001)
         {
            _local_10 = -_local_9;
            _local_8 = _local_7;
            _local_14 = -_local_13;
            _local_12 = _local_11;
         }
         _local_15 = Math.acos(_local_4);
         this._quaternions[this._quaternions.length] = [_local_5,_arg_3,_local_7,_local_8,_local_9,_local_10,_local_11,_local_12,_local_13,_local_14,_local_4,_local_15,1 / Math.sin(_local_15)];
         this.overwriteProps[this.overwriteProps.length] = _arg_3;
      }
   }
}

