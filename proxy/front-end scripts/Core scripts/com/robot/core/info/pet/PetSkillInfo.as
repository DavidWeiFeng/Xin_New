package com.robot.core.info.pet
{
   import com.robot.core.config.xml.SkillXMLInfo;
   import flash.utils.IDataInput;
   
   public class PetSkillInfo
   {
      
      private var _id:uint;
      
      public var pp:uint;
      
      public function PetSkillInfo(_arg_1:IDataInput = null)
      {
         super();
         if(_arg_1 != null)
         {
            this._id = _arg_1.readUnsignedInt();
            this.pp = _arg_1.readUnsignedInt();
         }
      }
      
      public function set id(_arg_1:uint) : void
      {
         this._id = _arg_1;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return SkillXMLInfo.getName(this.id);
      }
      
      public function get maxPP() : uint
      {
         return SkillXMLInfo.getPP(this.id);
      }
      
      public function get damage() : uint
      {
         return SkillXMLInfo.getDamage(this.id);
      }
   }
}

