package com.robot.core.info.team
{
   import com.robot.core.config.xml.*;
   import com.robot.core.info.FitmentInfo;
   import com.robot.core.manager.*;
   import com.robot.core.utils.*;
   import flash.utils.IDataInput;
   import org.taomee.ds.*;
   
   public class ArmInfo extends FitmentInfo
   {
      
      public var styleID:uint;
      
      public var buyTime:uint;
      
      public var isUsed:Boolean;
      
      public var form:uint;
      
      public var hp:uint;
      
      public var workCount:uint;
      
      public var donateCount:uint;
      
      public var res:HashMap = new HashMap();
      
      public var resNum:uint;
      
      public function ArmInfo()
      {
         super();
      }
      
      public static function setFor2941(_arg_1:ArmInfo, _arg_2:IDataInput = null) : void
      {
         _arg_1.id = _arg_2.readUnsignedInt();
         _arg_1.pos.x = _arg_2.readUnsignedInt();
         _arg_1.pos.y = _arg_2.readUnsignedInt();
         _arg_1.dir = _arg_2.readUnsignedInt();
         _arg_1.status = _arg_2.readUnsignedInt();
      }
      
      public static function setFor2942(_arg_1:ArmInfo, _arg_2:IDataInput = null) : void
      {
         _arg_1.id = _arg_2.readUnsignedInt();
         _arg_1.usedCount = _arg_2.readUnsignedInt();
         _arg_1.allCount = _arg_2.readUnsignedInt();
      }
      
      public static function setFor2964(_arg_1:ArmInfo, _arg_2:IDataInput = null) : void
      {
         _arg_1.id = _arg_2.readUnsignedInt();
         _arg_1.buyTime = _arg_2.readUnsignedInt();
         _arg_1.form = _arg_2.readUnsignedInt();
         _arg_1.pos.x = _arg_2.readUnsignedInt();
         _arg_1.pos.y = _arg_2.readUnsignedInt();
         _arg_1.dir = _arg_2.readUnsignedInt();
         _arg_1.status = _arg_2.readUnsignedInt();
      }
      
      public static function setFor2966(_arg_1:ArmInfo, _arg_2:IDataInput = null) : void
      {
         _arg_1.buyTime = _arg_2.readUnsignedInt();
         _arg_1.id = _arg_2.readUnsignedInt();
         _arg_1.form = _arg_2.readUnsignedInt();
         _arg_1.isUsed = Boolean(_arg_2.readUnsignedInt());
      }
      
      public static function setFor2967_2965(_arg_1:ArmInfo, _arg_2:IDataInput = null) : void
      {
         var _local_3:uint = 0;
         var _local_5:int = 0;
         _arg_1.id = _arg_2.readUnsignedInt();
         _arg_1.buyTime = _arg_2.readUnsignedInt();
         _arg_1.form = _arg_2.readUnsignedInt();
         _arg_1.hp = _arg_2.readUnsignedInt();
         _arg_1.workCount = _arg_2.readUnsignedInt();
         _arg_1.donateCount = _arg_2.readUnsignedInt();
         _arg_1.res.clear();
         _arg_1.resNum = 0;
         var _local_4:Array = FortressItemXMLInfo.getResIDs(_arg_1.id,_arg_1.form);
         while(_local_5 < 4)
         {
            _local_3 = uint(_arg_2.readUnsignedInt());
            _arg_1.resNum += _local_3;
            _arg_1.res.add(_local_4[_local_5],_local_3);
            _local_5++;
         }
         _arg_1.pos.x = _arg_2.readUnsignedInt();
         _arg_1.pos.y = _arg_2.readUnsignedInt();
         _arg_1.dir = _arg_2.readUnsignedInt();
         _arg_1.status = _arg_2.readUnsignedInt();
      }
      
      override public function set id(_arg_1:uint) : void
      {
         _id = _arg_1;
         if(_id == 1)
         {
            this.styleID = ArmManager.headquartersID;
            isFixed = true;
         }
         else
         {
            this.styleID = _id;
            isFixed = false;
         }
         if(_id == 1)
         {
            type = SolidType.HEAD;
         }
         else if(_id >= 2 && _id <= 60)
         {
            type = SolidType.INDUSTRY;
         }
         else if(_id >= 61 && _id <= 140)
         {
            type = SolidType.MILITARY;
         }
         else if(_id >= 141 && _id <= 200)
         {
            type = SolidType.DEFENSE;
         }
         else if(_id >= 800001 && _id <= 800200)
         {
            type = SolidType.FRAME;
         }
         else if(_id >= 800501 && _id <= 801000)
         {
            type = SolidType.PUT;
         }
      }
      
      public function clone() : ArmInfo
      {
         var _local_1:ArmInfo = new ArmInfo();
         _local_1.id = id;
         _local_1.styleID = this.styleID;
         _local_1.pos = pos.clone();
         _local_1.dir = dir;
         _local_1.status = status;
         _local_1.buyTime = this.buyTime;
         _local_1.form = this.form;
         _local_1.hp = this.hp;
         _local_1.res = this.res.clone();
         _local_1.type = type;
         _local_1.workCount = this.workCount;
         _local_1.donateCount = this.donateCount;
         _local_1.isUsed = this.isUsed;
         _local_1.resNum = this.resNum;
         _local_1.isFixed = isFixed;
         return _local_1;
      }
   }
}

