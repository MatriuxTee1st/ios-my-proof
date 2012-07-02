<?php
/**
 * エラー表示用コントローラ
 *
 * @author kenichi.tanaka
 */
class App_Controller_ErrorController extends Zend_Controller_Action{

// Actions -------------------------------------------------------------------//

	/**
	 * エラーアクション
	 */
	public function errorAction() {
		$errors = $this->_getParam('error_handler');

		switch ($errors->type) {
			case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
			case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:

				// 404 error -- controller or action not found
				$this->getResponse()->setHttpResponseCode(404);
				error_log('Page not found');
				break;
			default:
				// application error
				$this->getResponse()->setHttpResponseCode(500);
				error_log('Application error');
				break;
		}

		error_log($errors->exception);
exit(0);
	}

}

