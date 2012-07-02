<?php
/**
 * トランザクション管理を行うためのユーティリティクラス。
 * PDOを利用した場合にトランザクションの状態を知ることができないために、こちらで管理する必要がある。
 *
 * TODO 複数アダプタへの対応 (see http://www.bshe.org/modules/xpress2/archives/166)
 */
class App_Model_MultipleTransactionManager {

// Class Fields --------------------------------------------------------------//

	protected static $databaseAdapter = NULL;
	protected static $transactionStarted = 0;
	protected static $transactionLocked = false;


// Class Methods -------------------------------------------------------------//

	/**
	 * トランザクションを開始する。
	 *
	 * @return Zend_Db_Adapter_Abstract
	 */
	public static function beginTransaction() {
		if (self::$databaseAdapter === NULL) {
			throw new DatabaseException("アダプターが設定されていません。");
			return;
		}

		if (self::$transactionStarted === 0) {
			// 開始する
			try {
				self::$databaseAdapter->beginTransaction();
				self::$transactionStarted = 1;
				return self::$databaseAdapter;
			} catch (Exception $ex) {
				self::$transactionStarted = 0;

				// Logging
				error_log($ex->getMessage());
				error_log($ex->getTraceAsString());
				throw $ex;
			}
		}
		else
		{
			// 呼び出し回数を保存
			self::$transactionStarted += 1;

			return FALSE;
		}

	}

	/**
	 * 変更を反映し、トランザクションを終了する。トランザクションがロックされている場合はコミットできない。
	 *
	 * @return Zend_Db_Adapter_Abstract
	 */
	public static function commit() {
		if (self::$databaseAdapter === NULL) {
			throw new DatabaseException("アダプターが設定されていません。");
			return;
		}

		if (self::$transactionStarted > 0) {
			// トランザクションがある
			if (self::$transactionStarted === 1) {
				// 最初のbeginTransactionに戻ったのでコミットする
				try {
					self::$databaseAdapter->commit();
					self::$transactionStarted = 0;		// 呼び出し回数を0へ
					return self::$databaseAdapter;
				} catch (Exception $ex) {
					error_log($ex->getMessage());
					error_log($ex->getTraceAsString());
					throw $ex;
				}
			}
			else
			{
				// 呼び出し回数を減らす
				self::$transactionStarted -= 1;
				return FALSE;
			}
		}
		else
		{
			self::$transactionStarted = 0;
			return FALSE;
		}
	}

	/**
	 * 変更を破棄し、トランザクションを終了する。トランザクションがロックされている場合は
	 * ロールバックは行われない。
	 *
	 * @return Zend_Db_Adapter_Abstract
	 */
	public static function rollBack() {
		if (self::$databaseAdapter === NULL) {
			throw new DatabaseException("アダプターが設定されていません。");
			return;
		}

		if (self::$transactionStarted > 0) {
			// トランザクションがある
			if (self::$transactionStarted === 1) {
				// 最初のbeginTransactionに戻ったのでロールバックする
				try {
					self::$databaseAdapter->rollBack();
					self::$transactionStarted = 0;		// 呼び出し回数を0へ
					return self::$databaseAdapter;
				} catch (Exception $ex) {
					error_log($ex->getMessage());
					error_log($ex->getTraceAsString());
					throw $ex;
				}
			}
			else
			{
				// 呼び出し回数を減らす
				self::$transactionStarted -= 1;
				return FALSE;
			}
		}
		else
		{
			self::$transactionStarted = 0;
			return FALSE;
		}
	}

	/**
	 * トランザクションをロックする。
	 */
	public static function lock() {
		if (self::$databaseAdapter !== NULL) {
			self::$transactionLocked = true;
		}
	}

	/**
	 * トランザクションロックを解放する。
	 */
	public static function unlock() {
		if (self::$databaseAdapter !== NULL) {
			self::$transactionLocked = false;
		}
	}

	/**
	 * トランザクション管理で使用するデータベースアダプターを設定する。
	 *
	 * @param Zend_Db_Adapter_Abstract $adapter アダプタ
	 */
	public static function setDatabaseAdapter(Zend_Db_Adapter_Abstract $adapter) {
		self::$databaseAdapter = $adapter;
	}

	/**
	 * 現在管理下にあるデータベースアダプターを取得する。
	 *
	 * @return Zend_Db_Adapter_Abstract
	 */
	public static function getDatabaseAdapter() {
		return self::$databaseAdapter;
	}

	/**
	 * トランザクションが開始されているかを取得する。
	 *
	 * @return bool
	 */
	public static function isTransactionStarted() {
		if( self::$transactionStarted > 0 )
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}

	/**
	 * トランザクションがロックされているかを取得する。
	 *
	 * @return bool
	 */
	public static function isTransactionLocked() {
		return self::$transactionLocked;
	}


	// Constructors --------------------------------------------------------------//

	/**
	 * インスタンス化を抑制するためのプライベートコンストラクタ
	 */
	private function __construct() {
	}

}