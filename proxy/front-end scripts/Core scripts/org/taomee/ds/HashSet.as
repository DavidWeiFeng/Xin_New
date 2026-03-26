package org.taomee.ds
{
   import flash.utils.*;
   
   public class HashSet implements ICollection
   {
      
      private var _length:int;
      
      private var _weakKeys:Boolean;
      
      private var _content:Dictionary;
      
      public function HashSet(_arg_1:Boolean = false)
      {
         super();
         this._weakKeys = _arg_1;
         this._content = new Dictionary(_arg_1);
         this._length = 0;
      }
      
      public function addAll(_arg_1:Array) : void
      {
         var _local_2:* = undefined;
         for each(_local_2 in _arg_1)
         {
            this.add(_local_2);
         }
      }
      
      public function add(_arg_1:*) : void
      {
         switch(_arg_1)
         {
            case undefined:
               return;
            case undefined:
               ++this._length;
         }
         this._content[_arg_1] = _arg_1;
      }
      
      public function containsAll(_arg_1:Array) : Boolean
      {
         var _local_2:int = 0;
         var _local_3:int = int(_arg_1.length);
         _local_2 = 0;
         while(_local_2 < _local_3)
         {
            if(this._content[_arg_1[_local_2]] === undefined)
            {
               return false;
            }
            _local_2++;
         }
         return true;
      }
      
      public function isEmpty() : Boolean
      {
         return this._length == 0;
      }
      
      public function remove(_arg_1:*) : Boolean
      {
         if(this._content[_arg_1] !== undefined)
         {
            delete this._content[_arg_1];
            --this._length;
            return true;
         }
         return false;
      }
      
      public function get length() : int
      {
         return this._length;
      }
      
      public function clone() : HashSet
      {
         var _local_1:* = undefined;
         var _local_2:HashSet = new HashSet(this._weakKeys);
         for each(_local_1 in this._content)
         {
            _local_2.add(_local_1);
         }
         return _local_2;
      }
      
      public function each2(_arg_1:Function) : void
      {
         var _local_2:* = undefined;
         for each(_local_2 in this._content)
         {
            _arg_1(_local_2);
         }
      }
      
      public function clear() : void
      {
         this._content = new Dictionary(this._weakKeys);
         this._length = 0;
      }
      
      public function removeAll(_arg_1:Array) : void
      {
         var _local_2:* = undefined;
         for each(_local_2 in _arg_1)
         {
            this.remove(_local_2);
         }
      }
      
      public function toArray() : Array
      {
         var _local_3:int = 0;
         var _local_1:* = undefined;
         var _local_2:Array = new Array(this._length);
         for each(_local_1 in this._content)
         {
            _local_2[_local_3] = _local_1;
            _local_3++;
         }
         return _local_2;
      }
      
      public function contains(_arg_1:*) : Boolean
      {
         if(this._content[_arg_1] === undefined)
         {
            return false;
         }
         return true;
      }
   }
}

