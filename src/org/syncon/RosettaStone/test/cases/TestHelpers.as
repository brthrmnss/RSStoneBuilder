package org.syncon.RosettaStone.test.cases
{
	import org.syncon.RosettaStone.vo.LessonVO;

	public class TestHelpers
	{
		public function TestHelpers()
		{
		}
		
		public static function createLesson():LessonVO
		{
			var l : LessonVO = new LessonVO(); 
			l.name = 'lesson'; 
			l.baseFolder = 'test/lesson1';
			return l   
		}
	}
}