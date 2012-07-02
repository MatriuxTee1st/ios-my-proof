<?php
/**
 * アプリケーションの初期設定を行う。
 *
 * @author kenichi.tanaka
 */
class App_Bootstrap extends Zend_Application_Bootstrap_Bootstrap {

// Constant Values -----------------------------------------------------------//


// Class Methods -------------------------------------------------------------//

	public function __construct($application) {
		parent::__construct($application);
	}


// Bootstrap methods ---------------------------------------------------------//

	/**
	* データベースへの接続を初期化する。
	*/
	protected function _initDatabaseAdapter() {
		// ※ Zend_Application_Resource_Dbでも可
		$dbconfig = App_Util_ConfigUtil::load('database.json');
		$adapter = Zend_Db::factory($dbconfig->adapter, $dbconfig->db);

		Zend_Db_Table::setDefaultAdapter($adapter);
		App_Model_MultipleTransactionManager::setDatabaseAdapter($adapter);

		return $adapter;
	}

	protected function _initSession() {
		Zend_Session::setOptions(array('strict' => false));
		if (!Zend_Session::isStarted()) {
			Zend_Session::start();
		}
	}

}