<?php
/*---------------------------------------------------------------------------
 * @Project: Alto CMS
 * @Project URI: http://altocms.com
 * @Description: Advanced Community Engine
 * @Copyright: Alto CMS Team
 * @License: GNU GPL v2 & MIT
 *----------------------------------------------------------------------------
 * Based on
 *   LiveStreet Engine Social Networking by Mzhelskiy Maxim
 *   Site: www.livestreet.ru
 *   E-mail: rus.engine@gmail.com
 *----------------------------------------------------------------------------
 */

/**
 * Экшен обработки ленты активности
 *
 * @package actions
 * @since   1.0
 */
class ActionStream extends Action {
    /**
     * Текущий пользователь
     *
     * @var ModuleUser_EntityUser|null
     */
    protected $oUserCurrent;
    /**
     * Какое меню активно
     *
     * @var string
     */
    protected $sMenuItemSelect = 'user';

    /**
     * Инициализация
     *
     */
    public function Init() {
        /**
         * Личная лента доступна только для авторизованных, для гостей показываем общую ленту
         */
        $this->oUserCurrent = $this->User_GetUserCurrent();
        if ($this->oUserCurrent) {
            $this->SetDefaultEvent('user');
        } else {
            $this->SetDefaultEvent('all');
        }
        $this->Viewer_Assign('aStreamEventTypes', $this->Stream_GetEventTypes());

        $this->Viewer_Assign('sMenuHeadItemSelect', 'stream');
        /**
         * Загружаем в шаблон JS текстовки
         */
        $this->Lang_AddLangJs(
            array(
                 'stream_subscribes_already_subscribed', 'error'
            )
        );
    }

    /**
     * Регистрация евентов
     *
     */
    protected function RegisterEvent() {
        $this->AddEvent('user', 'EventUser');
        $this->AddEvent('all', 'EventAll');
        $this->AddEvent('subscribe', 'EventSubscribe');
        $this->AddEvent('subscribeByLogin', 'EventSubscribeByLogin');
        $this->AddEvent('unsubscribe', 'EventUnSubscribe');
        $this->AddEvent('switchEventType', 'EventSwitchEventType');
        $this->AddEvent('get_more', 'EventGetMore');
        $this->AddEvent('get_more_user', 'EventGetMoreUser');
        $this->AddEvent('get_more_all', 'EventGetMoreAll');
    }

    /**
     * Список событий в ленте активности пользователя
     *
     */
    protected function EventUser() {
        /**
         * Пользователь авторизован?
         */
        if (!$this->oUserCurrent) {
            return parent::EventNotFound();
        }
        $oSkin = $this->Skin_GetSkin($this->Viewer_GetConfigSkin());
        if ($oSkin && $oSkin->GetCompatible() == 'alto') {
            $this->Viewer_AddWidget('right', 'activitySettings');
            $this->Viewer_AddWidget('right', 'activityFriends');
            $this->Viewer_AddWidget('right', 'activityUsers');
        } else {
            $this->Viewer_AddWidget('right', 'streamConfig');
        }

        /**
         * Читаем события
         */
        $aEvents = $this->Stream_Read();
        $this->Viewer_Assign(
            'bDisableGetMoreButton',
            $this->Stream_GetCountByReaderId($this->oUserCurrent->getId()) < Config::Get('module.stream.count_default')
        );
        $this->Viewer_Assign('aStreamEvents', $aEvents);
        if (count($aEvents)) {
            $oEvenLast = end($aEvents);
            $this->Viewer_Assign('iStreamLastId', $oEvenLast->getId());
        }
    }

    /**
     * Список событий в общей ленте активности сайта
     *
     */
    protected function EventAll() {

        $this->sMenuItemSelect = 'all';
        /**
         * Читаем события
         */
        $aEvents = $this->Stream_ReadAll();
        $this->Viewer_Assign(
            'bDisableGetMoreButton', $this->Stream_GetCountAll() < Config::Get('module.stream.count_default')
        );
        $this->Viewer_Assign('aStreamEvents', $aEvents);
        if (count($aEvents)) {
            $oEvenLast = end($aEvents);
            $this->Viewer_Assign('iStreamLastId', $oEvenLast->getId());
        }
    }

    /**
     * Активаци/деактивация типа события
     *
     */
    protected function EventSwitchEventType() {
        /**
         * Устанавливаем формат Ajax ответа
         */
        $this->Viewer_SetResponseAjax('json');
        /**
         * Пользователь авторизован?
         */
        if (!$this->oUserCurrent) {
            parent::EventNotFound();
        }
        if (!F::GetRequest('type')) {
            $this->Message_AddError($this->Lang_Get('system_error'), $this->Lang_Get('error'));
        }
        /**
         * Активируем/деактивируем тип
         */
        $this->Stream_SwitchUserEventType($this->oUserCurrent->getId(), F::GetRequestStr('type'));
        $this->Message_AddNotice($this->Lang_Get('stream_subscribes_updated'), $this->Lang_Get('attention'));
    }

    /**
     * Погрузка событий (замена постраничности)
     *
     */
    protected function EventGetMore() {
        /**
         * Устанавливаем формат Ajax ответа
         */
        $this->Viewer_SetResponseAjax('json');
        /**
         * Пользователь авторизован?
         */
        if (!$this->oUserCurrent) {
            parent::EventNotFound();
        }
        /**
         * Необходимо передать последний просмотренный ID событий
         */
        $iFromId = F::GetRequestStr('iLastId');
        if (!$iFromId) {
            $this->Message_AddError($this->Lang_Get('system_error'), $this->Lang_Get('error'));
            return;
        }
        /**
         * Получаем события
         */
        $aEvents = $this->Stream_Read(null, $iFromId);

        $oViewer = $this->Viewer_GetLocalViewer();
        $oViewer->Assign('aStreamEvents', $aEvents);
        $oViewer->Assign('sDateLast', F::GetRequestStr('sDateLast'));
        if (count($aEvents)) {
            $oEvenLast = end($aEvents);
            $this->Viewer_AssignAjax('iStreamLastId', $oEvenLast->getId());
        }
        /**
         * Возвращаем данные в ajax ответе
         */
        $this->Viewer_AssignAjax('result', $oViewer->Fetch('actions/stream/action.stream.events.tpl'));
        $this->Viewer_AssignAjax('events_count', count($aEvents));
    }

    /**
     * Погрузка событий для всего сайта
     *
     */
    protected function EventGetMoreAll() {
        /**
         * Устанавливаем формат Ajax ответа
         */
        $this->Viewer_SetResponseAjax('json');
        /**
         * Пользователь авторизован?
         */
        if (!$this->oUserCurrent) {
            parent::EventNotFound();
        }
        /**
         * Необходимо передать последний просмотренный ID событий
         */
        $iFromId = F::GetRequestStr('iLastId');
        if (!$iFromId) {
            $this->Message_AddError($this->Lang_Get('system_error'), $this->Lang_Get('error'));
            return;
        }
        /**
         * Получаем события
         */
        $aEvents = $this->Stream_ReadAll(null, $iFromId);

        $oViewer = $this->Viewer_GetLocalViewer();
        $oViewer->Assign('aStreamEvents', $aEvents);
        $oViewer->Assign('sDateLast', F::GetRequestStr('sDateLast'));
        if (count($aEvents)) {
            $oEvenLast = end($aEvents);
            $this->Viewer_AssignAjax('iStreamLastId', $oEvenLast->getId());
        }
        /**
         * Возвращаем данные в ajax ответе
         */
        $this->Viewer_AssignAjax('result', $oViewer->Fetch('actions/stream/action.stream.events.tpl'));
        $this->Viewer_AssignAjax('events_count', count($aEvents));
    }

    /**
     * Подгрузка событий для пользователя
     *
     */
    protected function EventGetMoreUser() {
        /**
         * Устанавливаем формат Ajax ответа
         */
        $this->Viewer_SetResponseAjax('json');
        /**
         * Пользователь авторизован?
         */
        if (!$this->oUserCurrent) {
            parent::EventNotFound();
        }
        /**
         * Необходимо передать последний просмотренный ID событий
         */
        $iFromId = F::GetRequestStr('iLastId');
        if (!$iFromId) {
            $this->Message_AddError($this->Lang_Get('system_error'), $this->Lang_Get('error'));
            return;
        }
        if (!($oUser = $this->User_GetUserById(F::GetRequestStr('iUserId')))) {
            $this->Message_AddError($this->Lang_Get('system_error'), $this->Lang_Get('error'));
            return;
        }
        /**
         * Получаем события
         */
        $aEvents = $this->Stream_ReadByUserId($oUser->getId(), null, $iFromId);

        $oViewer = $this->Viewer_GetLocalViewer();
        $oViewer->Assign('aStreamEvents', $aEvents);
        $oViewer->Assign('sDateLast', F::GetRequestStr('sDateLast'));
        if (count($aEvents)) {
            $oEvenLast = end($aEvents);
            $this->Viewer_AssignAjax('iStreamLastId', $oEvenLast->getId());
        }
        /**
         * Возвращаем данные в ajax ответе
         */
        $this->Viewer_AssignAjax('result', $oViewer->Fetch('actions/stream/action.stream.events.tpl'));
        $this->Viewer_AssignAjax('events_count', count($aEvents));
    }

    /**
     * Подписка на пользователя по ID
     *
     */
    protected function EventSubscribe() {
        /**
         * Устанавливаем формат Ajax ответа
         */
        $this->Viewer_SetResponseAjax('json');
        /**
         * Пользователь авторизован?
         */
        if (!$this->oUserCurrent) {
            parent::EventNotFound();
        }
        /**
         * Проверяем существование пользователя
         */
        if (!$this->User_GetUserById(F::GetRequestStr('id'))) {
            $this->Message_AddError($this->Lang_Get('system_error'), $this->Lang_Get('error'));
        }
        if ($this->oUserCurrent->getId() == F::GetRequestStr('id')) {
            $this->Message_AddError($this->Lang_Get('stream_error_subscribe_to_yourself'), $this->Lang_Get('error'));
            return;
        }
        /**
         * Подписываем на пользователя
         */
        $this->Stream_SubscribeUser($this->oUserCurrent->getId(), F::GetRequestStr('id'));
        $this->Message_AddNotice($this->Lang_Get('stream_subscribes_updated'), $this->Lang_Get('attention'));
    }

    /**
     * Подписка на пользователя по логину
     *
     */
    protected function EventSubscribeByLogin() {
        /**
         * Устанавливаем формат Ajax ответа
         */
        $this->Viewer_SetResponseAjax('json');
        /**
         * Пользователь авторизован?
         */
        if (!$this->oUserCurrent) {
            parent::EventNotFound();
        }
        $sUserLogin = $this->GetPost('login');
        if (!$sUserLogin) {
            $this->Message_AddError($this->Lang_Get('system_error'), $this->Lang_Get('error'));
            return;
        }
        /**
         * Проверяем существование пользователя
         */
        $oUser = $this->User_GetUserByLogin($sUserLogin);
        if (!$oUser) {
            $this->Message_AddError(
                $this->Lang_Get('user_not_found', array('login' => htmlspecialchars(F::GetRequestStr('login')))),
                $this->Lang_Get('error')
            );
            return;
        }
        if ($this->oUserCurrent->getId() == $oUser->getId()) {
            $this->Message_AddError($this->Lang_Get('stream_error_subscribe_to_yourself'), $this->Lang_Get('error'));
            return;
        }
        /**
         * Подписываем на пользователя
         */
        $this->Stream_SubscribeUser($this->oUserCurrent->getId(), $oUser->getId());
        $this->Viewer_AssignAjax('uid', $oUser->getId());
        $this->Viewer_AssignAjax('user_login', $oUser->getLogin());
        $this->Viewer_AssignAjax('user_web_path', $oUser->getUserWebPath());
        $this->Viewer_AssignAjax('user_avatar_48', $oUser->getAvatarUrl(48));
        $this->Message_AddNotice($this->Lang_Get('userfeed_subscribes_updated'), $this->Lang_Get('attention'));
    }

    /**
     * Отписка от пользователя
     *
     */
    protected function EventUnsubscribe() {
        /**
         * Устанавливаем формат Ajax ответа
         */
        $this->Viewer_SetResponseAjax('json');
        /**
         * Пользователь авторизован?
         */
        if (!$this->oUserCurrent) {
            parent::EventNotFound();
        }
        /**
         * Пользователь с таким ID существует?
         */
        if (!$this->User_GetUserById(F::GetRequestStr('id'))) {
            $this->Message_AddError($this->Lang_Get('system_error'), $this->Lang_Get('error'));
        }
        /**
         * Отписываем
         */
        $this->Stream_UnsubscribeUser($this->oUserCurrent->getId(), F::GetRequestStr('id'));
        $this->Message_AddNotice($this->Lang_Get('stream_subscribes_updated'), $this->Lang_Get('attention'));
    }

    /**
     * Выполняется при завершении работы экшена
     *
     */
    public function EventShutdown() {
        /**
         * Загружаем в шаблон необходимые переменные
         */
        $this->Viewer_Assign('sMenuItemSelect', $this->sMenuItemSelect);
    }

}

// EOF