package com.robot.core.ui.loading
{
   import com.robot.core.ui.loading.loadingstyle.BaseLoadingStyle;
   import com.robot.core.ui.loading.loadingstyle.EmptyLoadingStyle;
   import com.robot.core.ui.loading.loadingstyle.ILoadingStyle;
   import com.robot.core.ui.loading.loadingstyle.MainLoadingStyle;
   import com.robot.core.ui.loading.loadingstyle.ShipToSpaceLoading;
   import com.robot.core.ui.loading.loadingstyle.TitleOnlyLoading;
   import com.robot.core.ui.loading.loadingstyle.TitlePercentLoading;
   import flash.display.DisplayObjectContainer;
   
   public class Loading
   {
      
      public static const NO_ALL:int = -1;
      
      public static const TITLE_AND_PERCENT:int = 1;
      
      public static const JUST_TITLE:int = 0;
      
      public static const ICON_ONLY:int = 2;
      
      public static const MAIN_LOAD:int = 3;
      
      public static const SHIP_TO_SPACE:int = 4;
      
      public function Loading()
      {
         super();
      }
      
      public static function getLoadingStyle(_arg_1:int, _arg_2:DisplayObjectContainer, _arg_3:String = "Loading...", _arg_4:Boolean = false) : ILoadingStyle
      {
         var _local_5:ILoadingStyle = null;
         switch(_arg_1)
         {
            case NO_ALL:
               _local_5 = new EmptyLoadingStyle();
               break;
            case MAIN_LOAD:
               _local_5 = new MainLoadingStyle(_arg_2,_arg_3,_arg_4);
               break;
            case TITLE_AND_PERCENT:
               _local_5 = new TitlePercentLoading(_arg_2,_arg_3,_arg_4);
               break;
            case JUST_TITLE:
               _local_5 = new TitleOnlyLoading(_arg_2,_arg_3,_arg_4);
               break;
            case ICON_ONLY:
               _local_5 = new BaseLoadingStyle(_arg_2,_arg_4);
               break;
            case SHIP_TO_SPACE:
               _local_5 = new ShipToSpaceLoading(_arg_2,_arg_3,_arg_4);
               break;
            default:
               _local_5 = new EmptyLoadingStyle();
         }
         return _local_5;
      }
   }
}

