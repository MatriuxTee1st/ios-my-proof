<?php
/**
 * バッチ用初期設定スクリプト
 */

/**
 * アプリケーション環境の定義
 */
defined('APPLICATION_ENV_PRODUCTION') || define('APPLICATION_ENV_PRODUCTION', 'production');
defined('APPLICATION_ENV_TESTING') || define('APPLICATION_ENV_TESTING', 'testing');
defined('APPLICATION_ENV_DEVELOPMENT') || define('APPLICATION_ENV_DEVELOPMENT', 'development');
defined('APPLICATION_ENV_SURVEY') || define('APPLICATION_ENV_SURVEY', 'survey');

/**
 * 環境を設定
 */
defined('APPLICATION_ENV') || define('APPLICATION_ENV', (getenv('APPLICATION_ENV') ? getenv('APPLICATION_ENV') : 'production'));

/**
 * アプリケーションのパス及びライブラリパスの設定 (自動ロード用)
 */
defined('APPLICATION_PATH') || define('APPLICATION_PATH', realpath(dirname(__FILE__) . '/../application'));

$librariesDirectory = dir(realpath(APPLICATION_PATH . '/../library'));
$libPath = array();
while (FALSE !== ($entry = $librariesDirectory->read())) {
	$path = implode(DIRECTORY_SEPARATOR, array($librariesDirectory->path, $entry));
	if (is_dir($path)) {
		if (!(strcmp($entry, '..') === 0 || strcmp($entry, '.') === 0)) {
			$libPath[] = implode(DIRECTORY_SEPARATOR, array($librariesDirectory->path, $entry));
		}
	}
}

set_include_path(get_include_path() . PATH_SEPARATOR . implode(PATH_SEPARATOR, $libPath));

/**
* 自動ロードの設定
*/
require_once 'Zend/Loader.php';
require_once 'Zend/Loader/Autoloader.php';
require_once 'Zend/Loader/Autoloader/Resource.php';

$resourceAutoLoader = new Zend_Loader_Autoloader_Resource(array(
	'namespace' => 'App',
	'basePath' => APPLICATION_PATH
));
$resourceAutoLoader->addResourceTypes(array(
	'controllers' => array('path' => 'controllers', 'namespace' => 'Controller'),
	'models' => array('path' => 'models', 'namespace' => 'Model'),
	'models/tables' => array('path' => 'models/tables', 'namespace' => 'Model_Table'),
	'utils' => array('path' => 'utils', 'namespace' => 'Util')
));