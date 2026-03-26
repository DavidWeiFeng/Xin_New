package com.robot.app.equipStrengthen
{
   public class EquipStrengthenInfo
   {
      
      private var _itemId:uint;
      
      private var _itemLev:uint;
      
      private var _levelId:uint;
      
      private var _needCatalystId:uint;
      
      private var _needMatterA:Array;
      
      private var _ownNeedA:Array;
      
      private var _needMatterNumA:Array;
      
      private var _des:String;
      
      private var _prob:String;
      
      private var _needCatalystNum:uint;
      
      private var _ownCatalystNum:uint;
      
      private var _sendId:uint;
      
      public function EquipStrengthenInfo()
      {
         super();
      }
      
      public function set sendId(_arg_1:uint) : void
      {
         this._sendId = _arg_1;
      }
      
      public function get sendId() : uint
      {
         return this._sendId;
      }
      
      public function set ownCatalystNum(_arg_1:uint) : void
      {
         this._ownCatalystNum = _arg_1;
      }
      
      public function get ownCatalystNum() : uint
      {
         return this._ownCatalystNum;
      }
      
      public function set needCatalystNum(_arg_1:uint) : void
      {
         this._needCatalystNum = _arg_1;
      }
      
      public function get needCatalystNum() : uint
      {
         return this._needCatalystNum;
      }
      
      public function set ownNeedA(_arg_1:Array) : void
      {
         this._ownNeedA = _arg_1;
      }
      
      public function get ownNeedA() : Array
      {
         return this._ownNeedA;
      }
      
      public function get itemId() : uint
      {
         return this._itemId;
      }
      
      public function set itemId(_arg_1:uint) : void
      {
         this._itemId = _arg_1;
      }
      
      public function get levelId() : uint
      {
         return this._levelId;
      }
      
      public function set levelId(_arg_1:uint) : void
      {
         this._levelId = _arg_1;
      }
      
      public function get needCatalystId() : uint
      {
         return this._needCatalystId;
      }
      
      public function set needCatalystId(_arg_1:uint) : void
      {
         this._needCatalystId = _arg_1;
      }
      
      public function get needMatterA() : Array
      {
         return this._needMatterA;
      }
      
      public function set needMatterA(_arg_1:Array) : void
      {
         this._needMatterA = _arg_1;
      }
      
      public function get needMatterNumA() : Array
      {
         return this._needMatterNumA;
      }
      
      public function set needMatterNumA(_arg_1:Array) : void
      {
         this._needMatterNumA = _arg_1;
      }
      
      public function get prob() : String
      {
         return this._prob;
      }
      
      public function set prob(_arg_1:String) : void
      {
         this._prob = _arg_1;
      }
      
      public function get des() : String
      {
         return this._des;
      }
      
      public function set des(_arg_1:String) : void
      {
         this._des = _arg_1;
      }
   }
}

