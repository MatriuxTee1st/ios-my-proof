<?php
include_once realpath(dirname(__FILE__) . '/__init__.php');

echo date('Y-m-d H:i:s', time())." Ranking count start.\n";

// DB接続
$dbCon = initDatabaseAdapter();
if( !$dbCon )
{
	echo "DB Error. Connection failed.\n";
	exit(0);
}

// モデル
$viewHistoryModel = new App_Model_Table_ViewHistory();
$recipeRankingModel = new App_Model_Table_RecipeRanking();

// 設定ファイル
$rankingConfig = App_Util_ConfigUtil::load('ranking.json');

// 集計範囲日付を設定
$now = new DateTime();
$start = new DateTime();
$end = new DateTime();
// countDayRange日前から昨日まで
$countDayRangeStartModify = '-'.$rankingConfig->countDayRange.' day';
$countDayRangeEndModify = '-1 day';
// 集計開始日と集計終了日を設定
$start->modify($rankingConfig->countTimeStart);
$start->modify($countDayRangeStartModify);
$end->modify($rankingConfig->countTimeEnd);
$end->modify($countDayRangeEndModify);
// 文字列に整形
$nowDate = $now->format('Y-m-d H:i:s');
$startDate = $start->format('Y-m-d H:i:s');
$endDate = $end->format('Y-m-d H:i:s');

App_Model_MultipleTransactionManager::beginTransaction();
try{

	// すでに集計済みなら削除する
	$existSql = $recipeRankingModel->select()->from($recipeRankingModel, 'id');
	$existSql->where('regist_date = ?', $nowDate)->limit(1);
	$existResult = $recipeRankingModel->fetchRow($existSql);
	if( isset($existResult) )
	{
		$deleteWhere = $recipeRankingModel->getAdapter()->quoteInto('regist_date = ?', $nowDate);
		$deleteResult = $recipeRankingModel->delete($deleteWhere);
		if( isset($deleteResult) && $deleteResult > 0 )
		{
			echo "delete OK.\n";
		}
	}

	// 集計SQL作成
	$registCount = $rankingConfig->registCount;
	$countSql = $viewHistoryModel->select()->from($viewHistoryModel, array('recipe_no', 'counter'=>'count(recipe_no)'));
	$countSql->where('recipe_no != ?', 0)->where('view_date >= ?', $startDate)->where('view_date <= ?', $endDate);
	$countSql->group('recipe_no');
	$countSql->order('counter DESC');
	$countSql->limit(($registCount*2));
	$result = $viewHistoryModel->fetchAll($countSql);
	// 集計結果登録
	if( isset($result) && count($result) > 0 )
	{
		$rank = 1;
		foreach( $result as $record )
		{
			// 登録結果が取得件数を超えたら終わる
			if( $rank > $registCount ) break;

			// レシピ番号が０番のものは記録対象外
			if( $record->recipe_no === 0 ) continue;

			echo "rank:".$rank." - recipe_no: ".$record->recipe_no."\n";

			// 登録
			$data = array(
				'recipe_no' => $record->recipe_no,
				'rank' => $rank,
				'count' => $record->counter,
				'regist_date' => $nowDate
			);
			$res = $recipeRankingModel->insert($data);

			$rank++;
		}
	}
	App_Model_MultipleTransactionManager::commit();
}catch( Exception $e ){
	App_Model_MultipleTransactionManager::rollback();
	echo "Db error.\n";
	error_log($e->getMessage());
	error_log($e->getTraceAsString());
}

echo date('Y-m-d H:i:s', time())." Ranking count finish.\n\n";


/**
* データベースへの接続を初期化する。
*/
function initDatabaseAdapter() {
	$dbconfig = App_Util_ConfigUtil::load('database.json');
	$adapter = null;
	try{
		$adapter = Zend_Db::factory($dbconfig->adapter, $dbconfig->db);
		Zend_Db_Table::setDefaultAdapter($adapter);
		App_Model_MultipleTransactionManager::setDatabaseAdapter($adapter);
	}catch (Exception $e){
		error_log($e->getMessage());
		error_log($e->getTraceAsString());
	}

	return $adapter;
}