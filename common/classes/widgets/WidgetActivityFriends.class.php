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
 * Виджет настройки ленты активности (друзья)
 *
 * @package widgets
 * @since   1.0
 */
class WidgetActivityFriends extends Widget {
    /**
     * Запуск обработки
     */
    public function Exec() {
        /**
         * пользователь авторизован?
         */
        if ($oUserCurrent = $this->User_GetUserCurrent()) {
            // * Получаем и прогружаем необходимые переменные в шаблон
            $aFriends = $this->User_GetUsersFriend($oUserCurrent->getId());
            if ($aFriends) {
                $this->Viewer_Assign('aStreamFriends', $aFriends['collection']);
            }
        }
    }
}

// EOF