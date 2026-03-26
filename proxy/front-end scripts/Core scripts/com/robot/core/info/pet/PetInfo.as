package com.robot.core.info.pet
{
   import flash.utils.*;
   
   public class PetInfo
   {
      
      public var id:uint;
      
      public var name:String;
      
      public var isDefault:Boolean = false;
      
      public var dv:uint;
      
      public var nature:uint;
      
      public var level:uint;
      
      public var exp:uint;
      
      public var lvExp:uint;
      
      public var nextLvExp:uint;
      
      public var hp:uint;
      
      public var maxHp:uint;
      
      public var attack:uint;
      
      public var defence:uint;
      
      public var s_a:uint;
      
      public var s_d:uint;
      
      public var speed:uint;
      
      public var ev_hp:uint;
      
      public var ev_attack:uint;
      
      public var ev_defence:uint;
      
      public var ev_sa:uint;
      
      public var ev_sd:uint;
      
      public var ev_sp:uint;
      
      public var skillNum:uint;
      
      public var skillArray:Array;
      
      public var catchTime:uint;
      
      public var catchMap:uint;
      
      public var catchRect:uint;
      
      public var catchLevel:uint;
      
      private var dict:Dictionary;
      
      public var effectCount:uint;
      
      public var effectList:Array;
      
      public var skinID:uint;
      
      public var isshiny:uint;
      
      public var shiny:PetGlowFilter;
      
      public var generation:uint;
      
      public var gender:uint;
      
      public function PetInfo(_arg_1:IDataInput, _arg_2:Boolean = true)
      {
         var _local_5:uint = 0;
         var _local_3:PetSkillInfo = null;
         var _local_4:int = 0;
         this.skillArray = [];
         this.dict = new Dictionary();
         this.effectList = [];
         super();
         this.id = _arg_1.readUnsignedInt();
         if(_arg_2)
         {
            this.name = _arg_1.readUTFBytes(16);
            this.gender = _arg_1.readUnsignedShort();
            this.generation = _arg_1.readUnsignedShort();
            this.dv = _arg_1.readUnsignedInt();
            this.nature = _arg_1.readUnsignedInt();
            this.level = _arg_1.readUnsignedInt();
            this.exp = _arg_1.readUnsignedInt();
            this.lvExp = _arg_1.readUnsignedInt();
            this.nextLvExp = _arg_1.readUnsignedInt();
            this.hp = _arg_1.readUnsignedInt();
            this.maxHp = _arg_1.readUnsignedInt();
            this.attack = _arg_1.readUnsignedInt();
            this.defence = _arg_1.readUnsignedInt();
            this.s_a = _arg_1.readUnsignedInt();
            this.s_d = _arg_1.readUnsignedInt();
            this.speed = _arg_1.readUnsignedInt();
            this.ev_hp = _arg_1.readUnsignedInt();
            this.ev_attack = _arg_1.readUnsignedInt();
            this.ev_defence = _arg_1.readUnsignedInt();
            this.ev_sa = _arg_1.readUnsignedInt();
            this.ev_sd = _arg_1.readUnsignedInt();
            this.ev_sp = _arg_1.readUnsignedInt();
         }
         else
         {
            this.level = _arg_1.readUnsignedInt();
            this.hp = _arg_1.readUnsignedInt();
            this.maxHp = _arg_1.readUnsignedInt();
         }
         this.skillNum = _arg_1.readUnsignedInt();
         while(_local_4 < this.skillNum)
         {
            _local_3 = new PetSkillInfo(_arg_1);
            if(_local_3.id != 0)
            {
               this.skillArray.push(_local_3);
               this.dict[_local_3.id] = _local_3;
            }
            _local_4++;
         }
         this.skillArray = this.skillArray.slice(0,this.skillNum);
         this.catchTime = _arg_1.readUnsignedInt();
         this.catchMap = _arg_1.readUnsignedInt();
         this.catchRect = _arg_1.readUnsignedInt();
         this.catchLevel = _arg_1.readUnsignedInt();
         if(_arg_2)
         {
            this.effectCount = _arg_1.readUnsignedShort();
            _local_5 = 0;
            while(_local_5 < this.effectCount)
            {
               this.effectList.push(new PetEffectInfo(_arg_1));
               _local_5++;
            }
         }
         this.skinID = _arg_1.readUnsignedInt();
         this.isshiny = _arg_1.readUnsignedInt();
         if(this.isshiny != 0)
         {
            this.shiny = new PetGlowFilter(_arg_1);
         }
      }
      
      public function getSkillInfo(_arg_1:uint) : PetSkillInfo
      {
         return this.dict[_arg_1];
      }
      
      public function get allPP() : uint
      {
         var _local_1:PetSkillInfo = null;
         var _local_2:uint = 0;
         for each(_local_1 in this.skillArray)
         {
            _local_2 += _local_1.pp;
         }
         return _local_2;
      }
   }
}

