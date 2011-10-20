package org.syncon.RosettaStone.test.cases
{
	import flexunit.framework.TestCase;
	
	import org.flexunit.Assert;

	public class Astest // extends TestCase
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function subtraction():void { 
			 Assert.assertEquals(8+2-2, 10-2);   
		}
		
	}
}