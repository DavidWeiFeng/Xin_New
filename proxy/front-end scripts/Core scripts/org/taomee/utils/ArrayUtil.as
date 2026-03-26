package org.taomee.utils
{
   public class ArrayUtil
   {
      
      public function ArrayUtil()
      {
         super();
      }
      
      public static function removeValueFromArray(_arg_1:Array, _arg_2:Object) : void
      {
         var _local_3:int = int(_arg_1.indexOf(_arg_2));
         if(_local_3 != -1)
         {
            _arg_1.splice(_local_3,1);
         }
      }
      
      public static function copyArray(_arg_1:Array) : Array
      {
         return _arg_1.slice();
      }
      
      public static function arrayContainsValue(_arg_1:Array, _arg_2:Object) : Boolean
      {
         return _arg_1.indexOf(_arg_2) != -1;
      }
      
      public static function arraysAreEqual(arr1:Array, arr2:Array) : Boolean
      {
         var isd:Boolean = false;
         if(arr1.length != arr2.length)
         {
            return false;
         }
         isd = Boolean(arr1.every(function(_arg_1:Object, _arg_2:int, _arg_3:Array):Boolean
         {
            if(arr2.indexOf(_arg_1) == -1)
            {
               return false;
            }
            return true;
         }));
         if(!isd)
         {
            return false;
         }
         isd = Boolean(arr2.every(function(_arg_1:Object, _arg_2:int, _arg_3:Array):Boolean
         {
            if(arr1.indexOf(_arg_1) == -1)
            {
               return false;
            }
            return true;
         }));
         return isd;
      }
      
      public static function embody(arr1:Array, arr2:Array) : Boolean
      {
         var isd:Boolean = Boolean(arr2.every(function(_arg_1:Object, _arg_2:int, _arg_3:Array):Boolean
         {
            if(arr1.indexOf(_arg_1) == -1)
            {
               return false;
            }
            return true;
         }));
         return isd;
      }
      
      public static function createUniqueCopy(a:Array) : Array
      {
         var uniqueArr:Array = null;
         uniqueArr = null;
         uniqueArr = [];
         a.forEach(function(_arg_1:Object, _arg_2:int, _arg_3:Array):void
         {
            if(uniqueArr.indexOf(_arg_1) == -1)
            {
               uniqueArr.push(_arg_1);
            }
         });
         return uniqueArr;
      }
   }
}

