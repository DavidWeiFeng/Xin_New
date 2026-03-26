package com.robot.core.info
{
   import com.robot.core.info.pet.PetEffectInfo;
   import com.robot.core.info.pet.PetSkillInfo;
   import flash.utils.IDataInput;
   
   public class RoomPetInfo
   {
      
      public var ownerId:uint;
      
      public var catchTime:uint;
      
      public var id:uint;
      
      public var nature:uint;
      
      public var lv:uint;
      
      public var hp:uint;
      
      public var atk:uint;
      
      public var def:uint;
      
      public var spatk:uint;
      
      public var spdef:uint;
      
      public var speed:uint;
      
      public var skillNum:uint;
      
      public var skillInfoArr:Array;
      
      public var len:int;
      
      public var evValueA:Array;
      
      public var effNum:uint;
      
      public var effA:Array;
      
      public function RoomPetInfo(_arg_1:IDataInput = null)
      {
         var _local_2:int = 0;
         var _local_3:int = 0;
         var _local_4:int = 0;
         var _local_5:PetSkillInfo = null;
         this.skillInfoArr = [];
         super();
         if(Boolean(_arg_1))
         {
            this.ownerId = _arg_1.readUnsignedInt();
            this.catchTime = _arg_1.readUnsignedInt();
            this.id = _arg_1.readUnsignedInt();
            this.nature = _arg_1.readUnsignedInt();
            this.lv = _arg_1.readUnsignedInt();
            this.hp = _arg_1.readUnsignedInt();
            this.atk = _arg_1.readUnsignedInt();
            this.def = _arg_1.readUnsignedInt();
            this.spatk = _arg_1.readUnsignedInt();
            this.spdef = _arg_1.readUnsignedInt();
            this.speed = _arg_1.readUnsignedInt();
            this.skillNum = _arg_1.readUnsignedInt();
            this.skillInfoArr = new Array();
            this.len = Math.min(this.skillNum,4);
            _local_2 = 0;
            while(_local_2 < this.len)
            {
               _local_5 = new PetSkillInfo(_arg_1);
               if(_local_5.id != 0)
               {
                  this.skillInfoArr.push(_local_5);
               }
               _local_2++;
            }
            this.evValueA = new Array();
            _local_3 = 0;
            while(_local_3 < 6)
            {
               this.evValueA.push(_arg_1.readUnsignedInt());
               _local_3++;
            }
            this.effNum = _arg_1.readUnsignedShort();
            this.effA = new Array();
            _local_4 = 0;
            while(_local_4 < this.effNum)
            {
               this.effA.push(new PetEffectInfo(_arg_1));
               _local_4++;
            }
         }
      }
   }
}

