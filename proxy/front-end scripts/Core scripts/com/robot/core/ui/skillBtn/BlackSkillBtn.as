package com.robot.core.ui.skillBtn
{
   import com.robot.core.manager.UIManager;
   import flash.display.MovieClip;
   
   public class BlackSkillBtn extends NormalSkillBtn
   {
      
      public function BlackSkillBtn(_arg_1:uint = 0, _arg_2:int = -1)
      {
         super(_arg_1,_arg_2);
      }
      
      override protected function getMC() : MovieClip
      {
         return UIManager.getMovieClip("ui_PetUpdate_PetSkillBtn");
      }
   }
}

