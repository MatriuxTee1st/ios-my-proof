<?php
/**
 * アプリケーションエントリーポイント
 */


/** 初期設定 */
include_once realpath(dirname(__FILE__) . '/__init__.php');

/** Zend_Application */
require_once 'Zend/Application.php';
require_once APPLICATION_PATH . '/utils/ConfigUtil.php';

try {
	// 出力バッファリング
	ob_start();

	if( isset($_POST['token']) && strcmp('725c16NzRk52bLR1fOMg', $_POST['token']) === 0 )
	{
		// Create application, bootstrap, and run
		$application = new Zend_Application(
			APPLICATION_ENV,
			App_Util_ConfigUtil::load('application.json')
		);

		$application->bootstrap();
		$application->run();
	}
	else
	{
		throw new Exception('Access denied. Token not found.');
	}

	// バッファを出力
	ob_end_flush();
} catch (Exception $ex) {
	// バッファを消去
	ob_end_clean();

	// 500へ
	header('HTTP/1.1 500 Internal Server Error');

	error_log($ex->getMessage());
	error_log($ex->getTraceAsString());
}