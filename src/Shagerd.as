﻿package  {
	import classes.Setup;
	
	import flash.display.MovieClip;
	
	public class Shagerd extends MovieClip
	{

		public function Shagerd() {
			
			Setup.load('D:/Kheshti/Project/LMS-app');
			Setup.serviceFormat('GetActiveCourseMessage',1,'اعلان ها');
		}
		
	}
	
}
