package com.robot.core.info.fightInfo
{
   import com.robot.core.event.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.manager.*;
   import com.robot.core.pet.petWar.*;
   import flash.utils.IDataInput;
   import org.taomee.ds.*;
   import org.taomee.manager.*;
   
   public class NoteReadyToFightInfo
   {
      
      private var _userInfoArray:Array;
      
      private var _petArray:Array;
      
      private var _skillArray:Array;
      
      private var _obj:PetWarInfo;
      
      private var _petInfoMap:Array;
      
      private var _myCapA:Array;
      
      private var _myPetInfoA:Array;
      
      private var _petInfoArray:HashMap;
      
      public function NoteReadyToFightInfo(_arg_1:IDataInput)
      {
         var _local_14:int = 0;
         var _local_15:String = null;
         var _local_16:FighetUserInfo = null;
         var _local_17:PetInfo = null;
         var _local_2:FighetUserInfo = null;
         var _local_3:uint = 0;
         var _local_4:int = 0;
         var _local_5:PetInfo = null;
         var _local_6:uint = 0;
         var _local_7:uint = 0;
         var _local_8:uint = 0;
         var _local_9:uint = 0;
         var _local_10:uint = 0;
         var _local_12:Boolean = false;
         var _local_13:int = 0;
         this._userInfoArray = [];
         this._petArray = [];
         this._skillArray = [];
         this._petInfoMap = new Array();
         this._myCapA = new Array();
         this._myPetInfoA = new Array();
         this._petInfoArray = new HashMap();
         super();
         this._obj = new PetWarInfo();
         this._obj.myPetA = new Array();
         this._obj.otherPetA = new Array();
         var _local_11:uint = uint(_arg_1.readUnsignedInt());
         while(_local_13 < 2)
         {
            _local_2 = new FighetUserInfo(_arg_1);
            this._userInfoArray.push(_local_2);
            _local_3 = uint(_arg_1.readUnsignedInt());
            _local_4 = 0;
            while(_local_4 < _local_3)
            {
               _local_5 = new PetInfo(_arg_1,false);
               trace("NoteReadyToFightInfo",_local_5);
               this._petInfoArray.add(_local_5.catchTime,_local_5);
               this._petInfoMap.push(_local_5);
               _local_14 = int(_local_5.skinID);
               if(this._petArray.indexOf(_local_14) == -1 && _local_14 != 0)
               {
                  this._petArray.push(_local_14);
               }
               if(this._petArray.indexOf(_local_5.id) == -1)
               {
                  this._petArray.push(_local_5.id);
               }
               if(_local_2.id == MainManager.actorID)
               {
                  this._obj.myPetA.push(_local_5.id);
                  this._myCapA.push(_local_5.catchTime);
                  this._myPetInfoA.push(_local_5);
               }
               else
               {
                  this._obj.otherPetA.push(_local_5.id);
               }
               _local_6 = 0;
               while(_local_6 < _local_5.skillArray.length)
               {
                  if(this._skillArray.indexOf((_local_5.skillArray[_local_6] as PetSkillInfo).id) == -1)
                  {
                     this._skillArray.push((_local_5.skillArray[_local_6] as PetSkillInfo).id);
                  }
                  _local_6++;
               }
               _local_4++;
            }
            _local_13++;
         }
         PetWarController.myPetInfoA = this._myPetInfoA;
         PetWarController.allPetA = this._petInfoMap;
         PetWarController.myCapA = this._myCapA;
         EventManager.dispatchEvent(new PetFightEvent(PetFightEvent.GET_FIGHT_INFO_SUCCESS,this._obj));
      }
      
      public function get petArray() : Array
      {
         return this._petArray;
      }
      
      public function get skillArray() : Array
      {
         return this._skillArray;
      }
      
      public function get userInfoArray() : Array
      {
         return this._userInfoArray;
      }
      
      public function get petInfoArray() : HashMap
      {
         return this._petInfoArray;
      }
   }
}

