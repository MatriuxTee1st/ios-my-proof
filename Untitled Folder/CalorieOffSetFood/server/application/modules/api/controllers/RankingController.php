<?php
class Api_RankingController extends App_Controller_ApiController
{
	private $_viewHistoryModel;
	private $_recipeRankingModel;

	public function init()
	{
		parent::init();

		$this->_viewHistoryModel = new App_Model_Table_ViewHistory();
		$this->_recipeRankingModel = new App_Model_Table_RecipeRanking();

		// Contexts
		$this->_contextSwitchHelper->addActionContext('add-recipe-view-history', 'json');
		$this->_contextSwitchHelper->addActionContext('get-recipe-view-ranking', 'json');

		$this->_contextSwitchHelper->initContext('json');
	}

	/**
	 * ユーザーの閲覧情報を記録する
	 * @param (array) <b>data</b> ... 登録情報&nbsp;
	 * <ul>
	 * <li>(int) <b>recipe_no</b> ... レコードの主キー</li>
	 * <li>(string) <b>view_date</b> ... 閲覧日時</li>
	 * </ul>
	 * @return (bool) <b>result</b> ... 結果(true/false)<br>&nbsp;
	 * (array) <b>error</b> ... エラー情報（エラー発生時のみ）</li>
	 * <ul>
	 * <li>(int) <b>code</b> ... エラーコード</li>
	 * <ul>
	 * <li><b>2000</b> ... データが送られてきていないか、正しいJSON形式ではありません</li>
	 * <li><b>2100</b> ... 必須データが送られてきていません</li>
	 * </ul>
	 * <li>(string) <b>message</b> ... エラーメッセージ</li>
	 * </ul>
	 */
	public function addRecipeViewHistoryAction()
	{
		// モデル
		$viewHistoryModel = $this->_viewHistoryModel;

		// 戻り値
		$returnArray = array('result' => false);

		// データ受取り
		$data = $this->_getParam('data', null);
		if( get_magic_quotes_gpc() )
		{
			$data = stripslashes($data);
		}
		$data = json_decode($data);

		// バリデーション
		if( empty($data) )
		{
			// データが送られてきていないか、JSONから変換できませんでした
			$returnArray['error']['code'] = '2000';
			$returnArray['error']['message'] = 'Data not send, or json syntax error.';
			$this->view->assign($returnArray);
			return;
		}

		try{
			App_Model_MultipleTransactionManager::beginTransaction();

			foreach( $data as $record )
			{
				// レシピ番号が０番のものは記録対象外
				if( $record->recipe_no === 0 ) continue;

				// DBにデータを挿入
				$now = date('Y-m-d H:i:s', time());

				$insertData = array(
					'recipe_no' => $record->recipe_no,
					'view_date' => $record->view_date,
					'regist_date' => $now
				);

				$result = $viewHistoryModel->insert($insertData);

				if( !isset($result) || $result < 1 ) error_log('[add-recipe-view-history] Insert failed.');

				$returnArray['result'] = true;
			}

			App_Model_MultipleTransactionManager::commit();
		}catch( Exception $e ){
			App_Model_MultipleTransactionManager::rollback();
			$returnArray['result'] = false;
			$returnArray['error']['code'] = '3000';
			$returnArray['error']['message'] = 'DB error. Insert failed.';
			error_log($e->getMessage());
			error_log($e->getTraceAsString());
		}

		$this->view->assign($returnArray);
	}

	/**
	 * レシピのアクセスランキングを返す
	 * @return (bool) <b>result</b> ... 結果(true/false)<br>&nbsp;
	 * (array) <b>error</b> ... エラー情報（エラー発生時のみ）</li>
	 * <ul>
	 * <li>(int) <b>code</b> ... エラーコード</li>
	 * <ul>
	 * <li><b>2000</b> ... データが送られてきていないか、正しいJSON形式ではありません</li>
	 * <li><b>2100</b> ... 必須データが送られてきていません</li>
	 * </ul>
	 * <li>(string) <b>message</b> ... エラーメッセージ</li>
	 * </ul>
	 */
	public function getRecipeViewRankingAction()
	{
		// モデル
		$recipeRankingModel = $this->_recipeRankingModel;

		// 設定ファイル
		$rankingConfig = App_Util_ConfigUtil::load('ranking.json');

		// 戻り値
		$returnArray = array('result' => false);

		// 最新ランキングを取得
		$getLimit = $rankingConfig->getLimit;	// 取得上限
		$query = $recipeRankingModel->select(true);
		$query->order('regist_date DESC,rank');
		$query->limit(($getLimit*2));
		$result = $recipeRankingModel->fetchAll($query);

		// 返却データを整形
		$returnObjectArray = array();
		$prevDeckIds = array();
		$nowCount = 1;
		if( isset($result) && count($result) > 0 )
		{
			foreach( $result as $record )
			{
				// 取得上限を超えたら終了
				if( $nowCount > $getLimit ) break;

				// 一度も格納したことのないレシピIDなら返却配列にオブジェクトを格納
				if( !isset($prevDeckIds[$record->recipe_no]) )
				{
					// 格納済みか判定するためにレシピIDを判定用配列に記録
					$prevDeckIds[$record->recipe_no] = true;
					// 返却用オブジェクト作成
					$one = new stdClass();
					$one->rank = (int)$record->rank;
					$one->recipe_no = (int)$record->recipe_no;
					$returnObjectArray[] = $one;

					$nowCount++;
				}
			}
			$returnArray['result'] = true;
			$returnArray['record'] = $returnObjectArray;
		}

		$this->view->assign($returnArray);
	}
}