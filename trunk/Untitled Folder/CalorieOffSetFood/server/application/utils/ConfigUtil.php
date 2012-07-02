<?php
/**
 * 設定ファイルを読み込むユーティリティー
 *
 * @author yuki.uchida
 */
final class App_Util_ConfigUtil {

// Constant values -----------------------------------------------------------//

	const TYPE_PHP  = 'Php';
	const TYPE_XML  = 'Xml';
	const TYPE_INI  = 'Ini';
	const TYPE_JSON = 'Json';
	const TYPE_YAML = 'Yaml';

// Class Fields --------------------------------------------------------------//

	/**
	 * シングルトン
	 */
	private static $_instance = null;

// Class Methods -------------------------------------------------------------//

	/**
	 * 使用可能にする
	 */
	public static function getInstance() {
		if (self::$_instance === null) {
			self::$_instance = new self();
		}
		return self::$_instance;
	}

	/**
	 * 設定ファイルを読み込む
	 */
	public static function load($config) {
		return self::getInstance()->loadConfig($config);
	}


// Fields --------------------------------------------------------------------//

	/**
	 * 設定ファイルが入った場所
	 */
	private $_configDirectory = null;

	/**
	* 環境情報
	*/
	private $_env = null;

// Constructors --------------------------------------------------------------//

	private function __construct() {
		$this->_configDirectory = APPLICATION_PATH . "/configs/";
		$this->_env = APPLICATION_ENV;
	}


// Methods -------------------------------------------------------------------//

	/**
	 * 設定ファイルをロードする。
	 *
	 * @param string $config  設定ファイル名
	 * @param string $section 読み込むセクション
	 * @param string $type    設定ファイルの形式
	 * @return Zend_Config
	 */
	private function loadConfig($config) {
		$env = $this->_env;
		if (isset($config)) {
			$_ext = strtolower(pathinfo($config, PATHINFO_EXTENSION));
			if ($_ext !== null) {
				switch ($_ext) {
					case 'php':
						$type = self::TYPE_PHP;
						break;
					case 'ini':
						$type = self::TYPE_INI;
						break;
					case 'js':
					case 'json':
						$type = self::TYPE_JSON;
						break;
					case 'yml':
					case 'yaml':
						$type = self::TYPE_YAML;
						break;
					case 'xml':
						$type = self::TYPE_XML;
						break;
				}
			}
			if ($type === null) {
				$type = self::TYPE_XML;
			}
			$_file = realpath($this->_configDirectory . basename($config));

			$_config = null;
			switch ($type) {
				case self::TYPE_PHP:
					$_config = new Zend_Config(include($_file));
					break;
				default:
					$_configClass = "Zend_Config_{$type}";
					$_config = new $_configClass($_file, $env);
				break;
			}

			// 保存
			return $_config;
		}
		return false;
	}

}