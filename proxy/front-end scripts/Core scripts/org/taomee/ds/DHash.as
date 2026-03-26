package org.taomee.ds
{
   import flash.utils.*;
   
   public class DHash implements ICollection
   {
      
      private var _contentKey:Dictionary;
      
      private var _length:int;
      
      private var _contentValue:Dictionary;
      
      private var _weakKeys:Boolean;
      
      public function DHash(_arg_1:Boolean = false)
      {
         super();
         this._weakKeys = _arg_1;
         this._length = 0;
         this._contentKey = new Dictionary(_arg_1);
         this._contentValue = new Dictionary(_arg_1);
      }
      
      public function containsKey(_arg_1:*) : Boolean
      {
         return this._contentKey[_arg_1] !== undefined;
      }
      
      public function isEmpty() : Boolean
      {
         return this._length == 0;
      }
      
      public function clear() : void
      {
         this._length = 0;
         this._contentKey = new Dictionary(this._weakKeys);
         this._contentValue = new Dictionary(this._weakKeys);
      }
      
      public function each2(_arg_1:Function) : void
      {
         var _local_2:* = undefined;
         for(_local_2 in this._contentKey)
         {
            _arg_1(_local_2,this._contentKey[_local_2]);
         }
      }
      
      public function containsValue(_arg_1:*) : Boolean
      {
         return this._contentValue[_arg_1] !== undefined;
      }
      
      public function removeForValue(_arg_1:*) : *
      {
         var _local_2:* = undefined;
         if(this._contentValue[_arg_1] !== undefined)
         {
            _local_2 = this._contentValue[_arg_1];
            delete this._contentValue[_arg_1];
            delete this._contentKey[_local_2];
            --this._length;
            return _local_2;
         }
         return null;
      }
      
      public function addForKey(_arg_1:*, _arg_2:*) : *
      {
         var _local_3:* = undefined;
         if(_arg_1 == null)
         {
            throw new ArgumentError("cannot put a value with undefined or null key!");
         }
         switch(_arg_2)
         {
            case undefined:
               return null;
            case undefined:
               ++this._length;
         }
         _local_3 = this.getValue(_arg_1);
         delete this._contentValue[_local_3];
         this._contentKey[_arg_1] = _arg_2;
         this._contentValue[_arg_2] = _arg_1;
         return _local_3;
      }
      
      public function getValues() : Array
      {
         var _local_3:int = 0;
         var _local_1:* = undefined;
         var _local_2:Array = new Array(this._length);
         for each(_local_1 in this._contentKey)
         {
            _local_2[_local_3] = _local_1;
            _local_3++;
         }
         return _local_2;
      }
      
      public function clone() : DHash
      {
         var _local_1:* = undefined;
         var _local_2:DHash = new DHash(this._weakKeys);
         for(_local_1 in this._contentKey)
         {
            _local_2.addForKey(_local_1,this._contentKey[_local_1]);
         }
         return _local_2;
      }
      
      public function contains(_arg_1:*) : Boolean
      {
         if(this._contentKey[_arg_1] !== undefined)
         {
            return true;
         }
         if(this._contentValue[_arg_1] !== undefined)
         {
            return true;
         }
         return false;
      }
      
      public function eachKey(_arg_1:Function) : void
      {
         var _local_2:* = undefined;
         for each(_local_2 in this._contentValue)
         {
            _arg_1(_local_2);
         }
      }
      
      public function addForValue(_arg_1:*, _arg_2:*) : *
      {
         var _local_3:* = undefined;
         if(_arg_1 == null)
         {
            throw new ArgumentError("cannot put a key with undefined or null value!");
         }
         switch(_arg_2)
         {
            case undefined:
               return null;
            case undefined:
               ++this._length;
         }
         _local_3 = this.getKey(_arg_1);
         delete this._contentKey[_local_3];
         this._contentValue[_arg_1] = _arg_2;
         this._contentKey[_arg_2] = _arg_1;
         return _local_3;
      }
      
      public function getKeys() : Array
      {
         var _local_3:int = 0;
         var _local_1:* = undefined;
         var _local_2:Array = new Array(this._length);
         for each(_local_1 in this._contentValue)
         {
            _local_2[_local_3] = _local_1;
            _local_3++;
         }
         return _local_2;
      }
      
      public function get length() : int
      {
         return this._length;
      }
      
      public function getKey(_arg_1:*) : *
      {
         var _local_2:* = this._contentValue[_arg_1];
         return _local_2 === undefined ? null : _local_2;
      }
      
      public function eachValue(_arg_1:Function) : void
      {
         var _local_2:* = undefined;
         for each(_local_2 in this._contentKey)
         {
            _arg_1(_local_2);
         }
      }
      
      public function removeForKey(_arg_1:*) : *
      {
         var _local_2:* = undefined;
         if(this._contentKey[_arg_1] !== undefined)
         {
            _local_2 = this._contentKey[_arg_1];
            delete this._contentKey[_arg_1];
            delete this._contentValue[_local_2];
            --this._length;
            return _local_2;
         }
         return null;
      }
      
      public function getValue(_arg_1:*) : *
      {
         var _local_2:* = this._contentKey[_arg_1];
         return _local_2 === undefined ? null : _local_2;
      }
   }
}

