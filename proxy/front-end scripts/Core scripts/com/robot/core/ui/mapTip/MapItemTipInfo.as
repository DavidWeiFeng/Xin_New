package com.robot.core.ui.mapTip
{
   import com.robot.core.config.xml.MapIntroXMLInfo;
   
   public class MapItemTipInfo
   {
      
      public var type:uint;
      
      public var title:String;
      
      public var content:Array;
      
      public function MapItemTipInfo(_arg_1:uint, _arg_2:uint)
      {
         super();
         this.type = _arg_2;
         switch(this.type)
         {
            case 0:
               this.title = MapIntroXMLInfo.getDes(_arg_1);
               this.content = [MapIntroXMLInfo.getDifficulty(_arg_1),MapIntroXMLInfo.getLevel(_arg_1)];
               return;
            case 1:
               this.title = "任务";
               this.content = MapIntroXMLInfo.getTasks(_arg_1);
               return;
            case 2:
               this.title = "精灵";
               this.content = MapIntroXMLInfo.getSprites(_arg_1);
               return;
            case 3:
               this.title = "矿产";
               this.content = MapIntroXMLInfo.getMinerals(_arg_1);
               return;
            case 4:
               this.title = "游戏";
               this.content = MapIntroXMLInfo.getGames(_arg_1);
               return;
            case 5:
               this.title = "NoNo";
               this.content = MapIntroXMLInfo.getNonos(_arg_1);
               return;
            case 6:
               this.title = "新品上架";
               this.content = MapIntroXMLInfo.getNewgoods(_arg_1);
               return;
            default:
               this.title = "";
               this.content = [];
               return;
         }
      }
   }
}

