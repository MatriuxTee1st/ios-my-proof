<?php
/**
 * 画像出力を扱うAPI
 * @author uchida.yuki
 */
class Api_ImageController extends App_Controller_ApiController
{
	public function init()
	{
		parent::init();

		// Contexts
		$this->_contextSwitchHelper->addActionContext('get-info-banner', 'json');

		$this->_contextSwitchHelper->initContext('json');
	}

	/**
	 * バナー情報を取得する
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
	public function getInfoBannerAction()
	{
		// 設定ファイル読み込み
		$config = App_Util_ConfigUtil::load('banner.json');
		$bannerUrl = $config->path.$config->fileName;
		$url = $config->url;
		$displayTime = $config->display_time;

		$returnArray = array();

		$img = file_get_contents($bannerUrl);

		$returnArray['bannerImage'] = base64_encode($img);
		$returnArray['url'] = $url;
		$returnArray['displayTime'] = $displayTime;

		$this->view->assign($returnArray);
	}

}