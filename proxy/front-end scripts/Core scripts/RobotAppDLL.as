package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   public class RobotAppDLL extends Sprite
   {
      
      public function RobotAppDLL()
      {
         try
         {
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");
         }
         catch(e:SecurityError)
         {
         }
         super();
      }
   }
}

