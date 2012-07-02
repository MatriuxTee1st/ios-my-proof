<?php
class App_Model_Table_RecipeRanking extends App_Model_TableCore
{
	protected $_name = 't_recipe_ranking';
	protected $_primary = 'id';

	public function insert(array $data)
	{
		$result = parent::insert($data);
		return $result;
	}

}
