package com.robot.core.npc
{
   import com.robot.core.config.xml.*;
   import flash.geom.*;
   
   public class NpcInfo
   {
      
      public var bubbingList:Array;
      
      public var dialogList:Array;
      
      public var point:Point;
      
      public var clothIds:Array;
      
      public var npcId:uint;
      
      public var npcMap:uint;
      
      public var npcName:String;
      
      public var color:uint;
      
      public var npcPath:String;
      
      public var type:String;
      
      public var startIDs:Array;
      
      public var endIDs:Array;
      
      public var proIDs:Array;
      
      public var offSetPoint:Point;
      
      public var questionA:Array;
      
      public var posList:Array;
      
      public function NpcInfo(_arg_1:XMLList = null)
      {
         var _local_2:Array = null;
         var _local_3:XML = null;
         var _local_4:Array = null;
         this.bubbingList = [];
         this.dialogList = [];
         this.clothIds = [];
         super();
         if(Boolean(_arg_1))
         {
            this.npcId = uint(_arg_1.@id);
            this.npcMap = uint(_arg_1.@mapID);
            this.npcName = _arg_1.@name;
            this.color = uint(_arg_1.@color);
            this.type = _arg_1.@type;
            if(Boolean(_arg_1.@offSetPoint))
            {
               _local_4 = String(_arg_1.@offSetPoint).split("|");
               this.offSetPoint = new Point(uint(_local_4[0]),uint(_local_4[1]));
            }
            else
            {
               this.offSetPoint = new Point();
            }
            if(Boolean(_arg_1.question))
            {
               this.questionA = String(_arg_1.question).split("$");
            }
            else
            {
               this.questionA = [];
            }
            this.startIDs = NpcXMLInfo.getStartIDs(this.npcId);
            this.endIDs = NpcXMLInfo.getEndIDs(this.npcId);
            this.proIDs = NpcXMLInfo.getNpcProIDs(this.npcId);
            this.npcPath = NPC.getSceneNpcPathById(this.npcId > 90000 ? 90000 : this.npcId);
            _local_2 = String(_arg_1.@point).split("|");
            this.point = new Point(uint(_local_2[0]),uint(_local_2[1]));
            if(Boolean(_arg_1.hasOwnProperty("@cloths")))
            {
               this.clothIds = String(_arg_1.@cloths).split("|");
            }
            else
            {
               this.clothIds = [];
            }
            for each(_local_3 in _arg_1.dialog.list)
            {
               this.bubbingList.push(_local_3.@str);
            }
            if(Boolean(_arg_1.des))
            {
               this.dialogList = String(_arg_1.des).split("$");
            }
            else
            {
               this.dialogList = [];
            }
            if(Boolean(_arg_1.hasOwnProperty("@posList")))
            {
               this.posList = String(_arg_1.@posList).split("|");
            }
            else
            {
               this.posList = [];
            }
         }
      }
   }
}

