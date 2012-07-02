<?php
/**
 * JSON形式で通信するAPIのベースクラス。
 *
 * @author kenichi.tanaka
 * @since iAnki 3.4
 */
class App_Controller_ApiController extends Zend_Controller_Action {

// Fields --------------------------------------------------------------------//

	/**
	 * @var Zend_Controller_Action_Helper_ContextSwitch
	 */
	protected $_contextSwitchHelper = NULL;


// Constructors --------------------------------------------------------------//

	public function init() {
		parent::init();

		$this->_contextSwitchHelper = $this->_helper->contextSwitch;
		$this->_contextSwitchHelper->setHeader('json', 'Content-Type', 'application/json; charset=utf-8');
	}


// Dispatcher ----------------------------------------------------------------//

}