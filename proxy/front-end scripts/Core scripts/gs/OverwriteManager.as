package gs
{
   import flash.errors.*;
   import flash.utils.*;
   import gs.utils.tween.*;
   
   public class OverwriteManager
   {
      
      public static var mode:int;
      
      public static var enabled:Boolean;
      
      public static const version:Number = 3.12;
      
      public static const NONE:int = 0;
      
      public static const ALL:int = 1;
      
      public static const AUTO:int = 2;
      
      public static const CONCURRENT:int = 3;
      
      public function OverwriteManager()
      {
         super();
      }
      
      public static function killVars(_arg_1:Object, _arg_2:Object, _arg_3:Array) : void
      {
         var _local_4:int = 0;
         var _local_5:String = null;
         var _local_6:TweenInfo = null;
         _local_4 = _arg_3.length - 1;
         while(_local_4 > -1)
         {
            _local_6 = _arg_3[_local_4];
            if(_local_6.name in _arg_1)
            {
               _arg_3.splice(_local_4,1);
            }
            else if(_local_6.isPlugin && _local_6.name == "_MULTIPLE_")
            {
               _local_6.target.killProps(_arg_1);
               if(_local_6.target.overwriteProps.length == 0)
               {
                  _arg_3.splice(_local_4,1);
               }
            }
            _local_4--;
         }
         for(_local_5 in _arg_1)
         {
            delete _arg_2[_local_5];
         }
      }
      
      public static function manageOverwrites(_arg_1:TweenLite, _arg_2:Array) : void
      {
         var _local_3:int = 0;
         var _local_4:TweenLite = null;
         var _local_5:Array = null;
         var _local_6:Object = null;
         var _local_7:int = 0;
         var _local_8:TweenInfo = null;
         var _local_9:Array = null;
         var _local_10:Object = _arg_1.vars;
         var _local_11:int = _local_10.overwrite == undefined ? mode : int(_local_10.overwrite);
         if(_local_11 < 2 || _arg_2 == null)
         {
            return;
         }
         var _local_12:Number = _arg_1.startTime;
         var _local_13:Array = [];
         var _local_14:int = -1;
         _local_3 = _arg_2.length - 1;
         while(_local_3 > -1)
         {
            _local_4 = _arg_2[_local_3];
            if(_local_4 == _arg_1)
            {
               _local_14 = _local_3;
            }
            else if(_local_3 < _local_14 && _local_4.startTime <= _local_12 && _local_4.startTime + _local_4.duration * 1000 / _local_4.combinedTimeScale > _local_12)
            {
               _local_13[_local_13.length] = _local_4;
            }
            _local_3--;
         }
         if(_local_13.length == 0 || _arg_1.tweens.length == 0)
         {
            return;
         }
         if(_local_11 == AUTO)
         {
            _local_5 = _arg_1.tweens;
            _local_6 = {};
            _local_3 = _local_5.length - 1;
            while(_local_3 > -1)
            {
               _local_8 = _local_5[_local_3];
               if(_local_8.isPlugin)
               {
                  if(_local_8.name == "_MULTIPLE_")
                  {
                     _local_9 = _local_8.target.overwriteProps;
                     _local_7 = _local_9.length - 1;
                     while(_local_7 > -1)
                     {
                        _local_6[_local_9[_local_7]] = true;
                        _local_7--;
                     }
                  }
                  else
                  {
                     _local_6[_local_8.name] = true;
                  }
                  _local_6[_local_8.target.propName] = true;
               }
               else
               {
                  _local_6[_local_8.name] = true;
               }
               _local_3--;
            }
            _local_3 = _local_13.length - 1;
            while(_local_3 > -1)
            {
               killVars(_local_6,_local_13[_local_3].exposedVars,_local_13[_local_3].tweens);
               _local_3--;
            }
         }
         else
         {
            _local_3 = _local_13.length - 1;
            while(_local_3 > -1)
            {
               _local_13[_local_3].enabled = false;
               _local_3--;
            }
         }
      }
      
      public static function init(_arg_1:int = 2) : int
      {
         if(TweenLite.version < 10.09)
         {
         }
         TweenLite.overwriteManager = OverwriteManager;
         mode = _arg_1;
         enabled = true;
         return mode;
      }
   }
}

