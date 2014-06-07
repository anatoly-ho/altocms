--
-- Database Alto CMS
--

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_blog`
--

CREATE TABLE IF NOT EXISTS `prefix_blog` (
  `blog_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_owner_id` int(11) unsigned NOT NULL,
  `blog_title` varchar(200) NOT NULL,
  `blog_description` text NOT NULL,
  `blog_type` varchar(30) NOT NULL DEFAULT 'personal',
  `blog_date_add` datetime NOT NULL,
  `blog_date_edit` datetime DEFAULT NULL,
  `blog_rating` float(9,3) NOT NULL DEFAULT '0.000',
  `blog_count_vote` int(11) unsigned NOT NULL DEFAULT '0',
  `blog_count_user` int(11) unsigned NOT NULL DEFAULT '0',
  `blog_count_topic` int(10) unsigned NOT NULL DEFAULT '0',
  `blog_limit_rating_topic` float(9,3) NOT NULL DEFAULT '0.000',
  `blog_url` varchar(200) DEFAULT NULL,
  `blog_avatar` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`blog_id`),
  KEY `user_owner_id` (`user_owner_id`),
  KEY `blog_type` (`blog_type`),
  KEY `blog_url` (`blog_url`),
  KEY `blog_title` (`blog_title`),
  KEY `blog_count_topic` (`blog_count_topic`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `prefix_blog`
--

INSERT INTO `prefix_blog` (`blog_id`, `user_owner_id`, `blog_title`, `blog_description`, `blog_type`, `blog_date_add`, `blog_date_edit`, `blog_rating`, `blog_count_vote`, `blog_count_user`, `blog_count_topic`, `blog_limit_rating_topic`, `blog_url`, `blog_avatar`) VALUES
(1, 1, 'Blog by admin', 'This is your personal blog.', 'personal', NOW(), NULL, 0.000, 0, 0, 0, -1000.000, NULL, '0');

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_blog_type`
--

CREATE TABLE IF NOT EXISTS `prefix_blog_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_code` varchar(16) NOT NULL,
  `type_name` varchar(32) NOT NULL,
  `type_description` varchar(255) DEFAULT NULL,
  `allow_add` tinyint(1) DEFAULT '1',
  `min_rate_add` float DEFAULT '0',
  `allow_list` tinyint(1) DEFAULT '1',
  `min_rate_list` float DEFAULT NULL,
  `index_ignore` tinyint(1) DEFAULT '0',
  `membership` tinyint(4) DEFAULT '0',
  `acl_write` int(11) DEFAULT NULL,
  `min_rate_write` float DEFAULT '0',
  `acl_read` int(11) DEFAULT NULL,
  `min_rate_read` float DEFAULT '0',
  `acl_comment` int(11) DEFAULT NULL,
  `min_rate_comment` float DEFAULT '0',
  `content_type` varchar(50) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `norder` int(11) DEFAULT '0',
  `candelete` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`type_code`),
  KEY `numord` (`norder`),
  KEY `allow_add` (`allow_add`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Дамп данных таблицы `prefix_blog_type`
--

INSERT INTO `prefix_blog_type` (`id`, `type_code`, `type_name`, `type_description`, `allow_add`, `min_rate_add`, `allow_list`, `min_rate_list`, `index_ignore`, `membership`, `acl_write`, `min_rate_write`, `acl_read`, `min_rate_read`, `acl_comment`, `min_rate_comment`, `content_type`, `active`, `norder`, `candelete`) VALUES
(1, 'personal', '{{blogtypes_type_personal_name}}', '{{blogtypes_type_personal_description}}', 0, 0, 1, NULL, 0, 0, 0, -100, 1, 0, 2, -10, '', 1, 0, 0),
(2, 'open', '{{blogtypes_type_open_name}}', '{{blogtypes_type_open_description}}', 1, 1, 1, NULL, 0, 1, 2, -10, 1, 0, 2, -10, NULL, 1, 0, 0),
(3, 'close', '{{blogtypes_type_close_name}}', '{{blogtypes_type_close_description}}', 1, 1, 1, NULL, 1, 2, 4, 0, 4, 0, 4, -10, NULL, 1, 0, 0),
(4, 'hidden', '{{blogtypes_type_hidden_name}}', '{{blogtypes_type_hidden_description}}', 0, 10, 0, NULL, 1, 4, 4, 0, 4, 0, 4, -10, NULL, 1, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_blog_user`
--

CREATE TABLE IF NOT EXISTS `prefix_blog_user` (
  `blog_user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `blog_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `user_role` int(3) DEFAULT '1',
  PRIMARY KEY (`blog_user_id`),
  UNIQUE KEY `blog_id_user_id_uniq` (`blog_id`,`user_id`),
  KEY `blog_id` (`blog_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_blog_user`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_comment`
--

CREATE TABLE IF NOT EXISTS `prefix_comment` (
  `comment_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `comment_pid` int(11) unsigned DEFAULT NULL,
  `comment_left` int(11) NOT NULL DEFAULT '0',
  `comment_right` int(11) NOT NULL DEFAULT '0',
  `comment_level` int(11) NOT NULL DEFAULT '0',
  `target_id` int(11) unsigned DEFAULT NULL,
  `target_type` varchar(30) NOT NULL DEFAULT 'topic',
  `target_parent_id` int(11) unsigned NOT NULL DEFAULT '0',
  `user_id` int(11) unsigned NOT NULL,
  `comment_text` text NOT NULL,
  `comment_text_hash` varchar(32) NOT NULL,
  `comment_date` datetime NOT NULL,
  `comment_date_edit` datetime NULL DEFAULT NULL,
  `comment_user_edit` int(11) unsigned DEFAULT '0',
  `comment_user_ip` varchar(40) NOT NULL,
  `comment_rating` float(9,3) NOT NULL DEFAULT '0.000',
  `comment_count_vote` int(11) unsigned NOT NULL DEFAULT '0',
  `comment_count_favourite` int(11) unsigned NOT NULL DEFAULT '0',
  `comment_delete` tinyint(4) NOT NULL DEFAULT '0',
  `comment_publish` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`comment_id`),
  KEY `comment_pid` (`comment_pid`),
  KEY `type_date_rating` (`target_type`,`comment_date`,`comment_rating`),
  KEY `id_type` (`target_id`,`target_type`),
  KEY `type_delete_publish` (`target_type`,`comment_delete`,`comment_publish`),
  KEY `user_type` (`user_id`,`target_type`),
  KEY `target_parent_id` (`target_parent_id`),
  KEY `comment_left` (`comment_left`),
  KEY `comment_right` (`comment_right`),
  KEY `comment_level` (`comment_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_comment`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_comment_online`
--

CREATE TABLE IF NOT EXISTS `prefix_comment_online` (
  `comment_online_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `target_id` int(11) unsigned DEFAULT NULL,
  `target_type` varchar(30) NOT NULL DEFAULT 'topic',
  `target_parent_id` int(11) unsigned NOT NULL DEFAULT '0',
  `comment_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`comment_online_id`),
  UNIQUE KEY `id_type` (`target_id`,`target_type`),
  KEY `comment_id` (`comment_id`),
  KEY `type_parent` (`target_type`,`target_parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_comment_online`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_favourite`
--

CREATE TABLE IF NOT EXISTS `prefix_favourite` (
  `user_id` int(11) unsigned NOT NULL,
  `target_id` int(11) unsigned DEFAULT NULL,
  `target_type` varchar(30) DEFAULT 'topic',
  `target_publish` tinyint(1) DEFAULT '1',
  `tags` varchar(250) NOT NULL,
  UNIQUE KEY `user_id_target_id_type` (`user_id`,`target_id`,`target_type`),
  KEY `target_publish` (`target_publish`),
  KEY `id_type` (`target_id`,`target_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_favourite`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_favourite_tag`
--

CREATE TABLE IF NOT EXISTS `prefix_favourite_tag` (
  `user_id` int(11) unsigned NOT NULL,
  `target_id` int(11) unsigned NOT NULL,
  `target_type` varchar(30) NOT NULL,
  `is_user` tinyint(1) NOT NULL DEFAULT '0',
  `text` varchar(50) NOT NULL,
  KEY `user_id_target_type_id` (`user_id`,`target_type`,`target_id`),
  KEY `target_type_id` (`target_type`,`target_id`),
  KEY `is_user` (`is_user`),
  KEY `text` (`text`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_favourite_tag`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_friend`
--

CREATE TABLE IF NOT EXISTS `prefix_friend` (
  `user_from` int(11) unsigned NOT NULL DEFAULT '0',
  `user_to` int(11) unsigned NOT NULL DEFAULT '0',
  `status_from` int(4) NOT NULL,
  `status_to` int(4) NOT NULL,
  PRIMARY KEY (`user_from`,`user_to`),
  KEY `user_to` (`user_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_friend`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_invite`
--

CREATE TABLE IF NOT EXISTS `prefix_invite` (
  `invite_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `invite_code` varchar(32) NOT NULL,
  `user_from_id` int(11) unsigned NOT NULL,
  `user_to_id` int(11) unsigned DEFAULT NULL,
  `invite_date_add` datetime NOT NULL,
  `invite_date_used` datetime DEFAULT NULL,
  `invite_used` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`invite_id`),
  UNIQUE KEY `invite_code` (`invite_code`),
  KEY `user_from_id` (`user_from_id`),
  KEY `user_to_id` (`user_to_id`),
  KEY `invite_date_add` (`invite_date_add`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_invite`
--

-- --------------------------------------------------------

-- --
-- Структура таблицы 'prefix_mresource'
--

CREATE TABLE IF NOT EXISTS `prefix_mresource` (
  `mresource_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date_add` datetime NOT NULL,
  `date_del` datetime DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `storage` varchar(16) DEFAULT NULL,
  `uuid` varchar(64) NOT NULL,
  `link` tinyint(1) NOT NULL,
  `type` int(11) NOT NULL,
  `path_url` varchar(512) NOT NULL,
  `path_file` varchar(512) DEFAULT NULL,
  `hash_url` varchar(64) DEFAULT NULL,
  `hash_file` varchar(64) DEFAULT NULL,
  `candelete` tinyint(1) DEFAULT '1',
  `params` text,
  PRIMARY KEY (`mresource_id`),
  KEY `user_id` (`user_id`),
  KEY `type` (`type`),
  KEY `hash_file` (`hash_file`),
  KEY `hash_url` (`hash_url`),
  KEY `link` (`link`),
  KEY `storage` (`storage`),
  KEY `uuid` (`uuid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

-- --------------------------------------------------------

--
-- Структура таблицы 'prefix_mresource_target'
--

CREATE TABLE IF NOT EXISTS `prefix_mresource_target` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mresource_id` int(11) NOT NULL,
  `target_type` varchar(32) NOT NULL,
  `target_id` int(11) NOT NULL,
  `date_add` datetime NOT NULL,
  `target_tmp` varchar(32) DEFAULT NULL,
  `description` text,
  `incount` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_id` (`target_type`,`target_id`,`mresource_id`),
  KEY `target_tmp` (`target_tmp`),
  KEY `target_type` (`target_type`),
  KEY `target_id` (`target_id`),
  KEY `mresource_id` (`mresource_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_notify_task`
--

CREATE TABLE IF NOT EXISTS `prefix_notify_task` (
  `notify_task_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(30) DEFAULT NULL,
  `user_mail` varchar(50) DEFAULT NULL,
  `notify_subject` varchar(200) DEFAULT NULL,
  `notify_text` text,
  `date_created` datetime DEFAULT NULL,
  `notify_task_status` tinyint(2) unsigned DEFAULT NULL,
  PRIMARY KEY (`notify_task_id`),
  KEY `date_created` (`date_created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_notify_task`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_reminder`
--

CREATE TABLE IF NOT EXISTS `prefix_reminder` (
  `reminder_code` varchar(32) NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `reminder_date_add` datetime NOT NULL,
  `reminder_date_used` datetime DEFAULT '0000-00-00 00:00:00',
  `reminder_date_expire` datetime NOT NULL,
  `reminde_is_used` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`reminder_code`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_reminder`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_session`
--

CREATE TABLE IF NOT EXISTS `prefix_session` (
  `session_key` varchar(50) NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `session_ip_create` varchar(40) NOT NULL,
  `session_ip_last` varchar(40) NOT NULL,
  `session_date_create` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `session_date_last` datetime NOT NULL,
  `session_agent_hash` varchar(50) DEFAULT NULL,
  `session_exit` datetime DEFAULT NULL,
  PRIMARY KEY (`session_key`),
  KEY `user_id` (`user_id`),
  KEY `session_date_last` (`session_date_last`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_session`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_stream_event`
--

CREATE TABLE IF NOT EXISTS `prefix_stream_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_type` varchar(100) NOT NULL,
  `target_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `publish` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `event_type` (`event_type`,`user_id`),
  KEY `user_id` (`user_id`),
  KEY `publish` (`publish`),
  KEY `target_id` (`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_stream_event`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_stream_subscribe`
--

CREATE TABLE IF NOT EXISTS `prefix_stream_subscribe` (
  `user_id` int(11) unsigned NOT NULL,
  `target_user_id` int(11) unsigned NOT NULL,
  KEY `user_id` (`user_id`,`target_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_stream_subscribe`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_stream_user_type`
--

CREATE TABLE IF NOT EXISTS `prefix_stream_user_type` (
  `user_id` int(11) unsigned NOT NULL,
  `event_type` varchar(100) DEFAULT NULL,
  KEY `user_id` (`user_id`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_stream_user_type`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_subscribe`
--

CREATE TABLE IF NOT EXISTS `prefix_subscribe` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `target_type` varchar(20) NOT NULL,
  `target_id` int(11) unsigned DEFAULT NULL,
  `user_id` INT( 11 ) UNSIGNED NULL DEFAULT NULL,
  `mail` varchar(50) NOT NULL,
  `date_add` datetime NOT NULL,
  `date_remove` datetime DEFAULT NULL,
  `ip` varchar(40) NOT NULL,
  `key` varchar(32) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `type` (`target_type`),
  KEY `user_id` (`user_id`),
  KEY `mail` (`mail`),
  KEY `status` (`status`),
  KEY `key` (`key`),
  KEY `target_id` (`target_id`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_subscribe`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_talk`
--

CREATE TABLE IF NOT EXISTS `prefix_talk` (
  `talk_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `talk_title` varchar(200) NOT NULL,
  `talk_text` text NOT NULL,
  `talk_date` datetime NOT NULL,
  `talk_date_last` datetime NOT NULL,
  `talk_user_id_last` int(11) unsigned NOT NULL,
  `talk_user_ip` varchar(40) NOT NULL,
  `talk_comment_id_last` int(11) unsigned DEFAULT NULL,
  `talk_count_comment` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`talk_id`),
  KEY `user_id` (`user_id`),
  KEY `talk_title` (`talk_title`),
  KEY `talk_date` (`talk_date`),
  KEY `talk_date_last` (`talk_date_last`),
  KEY `talk_user_id_last` (`talk_user_id_last`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_talk`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_talk_blacklist`
--

CREATE TABLE IF NOT EXISTS `prefix_talk_blacklist` (
  `user_id` int(11) unsigned NOT NULL,
  `user_target_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`user_target_id`),
  KEY `prefix_talk_blacklist_fk_target` (`user_target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_talk_blacklist`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_talk_user`
--

CREATE TABLE IF NOT EXISTS `prefix_talk_user` (
  `talk_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `date_last` datetime DEFAULT NULL,
  `comment_id_last` int(11) unsigned NOT NULL DEFAULT '0',
  `comment_count_new` int(11) NOT NULL DEFAULT '0',
  `talk_user_active` tinyint(1) DEFAULT '1',
  UNIQUE KEY `talk_id_user_id` (`talk_id`,`user_id`),
  KEY `user_id` (`user_id`),
  KEY `date_last` (`date_last`),
  KEY `date_last_2` (`date_last`),
  KEY `talk_user_active` (`talk_user_active`),
  KEY `comment_count_new` (`comment_count_new`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_talk_user`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_topic`
--

CREATE TABLE IF NOT EXISTS `prefix_topic` (
  `topic_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `blog_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `topic_type` varchar(30) DEFAULT 'topic',
  `topic_title` varchar(200) NOT NULL,
  `topic_tags` varchar(250) NOT NULL COMMENT 'tags separated by a comma',
  `topic_date_add` datetime NOT NULL,
  `topic_date_edit` datetime DEFAULT NULL,
  `topic_date_show` datetime DEFAULT NULL,
  `topic_user_ip` varchar(20) NOT NULL,
  `topic_publish` tinyint(1) NOT NULL DEFAULT '0',
  `topic_publish_draft` tinyint(1) NOT NULL DEFAULT '1',
  `topic_publish_index` tinyint(1) NOT NULL DEFAULT '0',
  `topic_rating` float(9,3) NOT NULL DEFAULT '0.000',
  `topic_count_vote` int(11) unsigned NOT NULL DEFAULT '0',
  `topic_count_vote_up` int(11) NOT NULL DEFAULT '0',
  `topic_count_vote_down` int(11) NOT NULL DEFAULT '0',
  `topic_count_vote_abstain` int(11) NOT NULL DEFAULT '0',
  `topic_count_read` int(11) unsigned NOT NULL DEFAULT '0',
  `topic_count_comment` int(11) unsigned NOT NULL DEFAULT '0',
  `topic_count_favourite` int(11) unsigned NOT NULL DEFAULT '0',
  `topic_cut_text` varchar(100) DEFAULT NULL,
  `topic_forbid_comment` tinyint(1) NOT NULL DEFAULT '0',
  `topic_text_hash` varchar(32) NOT NULL,
  `topic_url` varchar(250) DEFAULT NULL,
  `topic_index_ignore` tinyint(2) DEFAULT '0',
  PRIMARY KEY (`topic_id`),
  KEY `blog_id` (`blog_id`),
  KEY `topic_count_comment` (`topic_count_comment`),
  KEY `topic_date_add` (`topic_date_add`),
  KEY `topic_publish` (`topic_publish`),
  KEY `topic_rating` (`topic_rating`),
  KEY `topic_text_hash` (`topic_text_hash`),
  KEY `user_id` (`user_id`),
  KEY `topic_url` (`topic_url`),
  KEY `topic_index_ignore` (`topic_index_ignore`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_topic`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_topic_content`
--

CREATE TABLE IF NOT EXISTS `prefix_topic_content` (
  `topic_id` int(11) unsigned NOT NULL,
  `topic_text` longtext NOT NULL,
  `topic_text_short` text NOT NULL,
  `topic_text_source` longtext NOT NULL,
  `topic_extra` text NOT NULL,
  PRIMARY KEY (`topic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_topic_content`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_topic_photo`
--

CREATE TABLE IF NOT EXISTS `prefix_topic_photo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) unsigned DEFAULT NULL,
  `path` varchar(255) NOT NULL,
  `description` text,
  `target_tmp` varchar(40) DEFAULT NULL,
  `date_add` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `topic_id` (`topic_id`),
  KEY `target_tmp` (`target_tmp`),
  KEY `date_add` (`date_add`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_topic_photo`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_topic_question_vote`
--

CREATE TABLE IF NOT EXISTS `prefix_topic_question_vote` (
  `topic_id` int(11) unsigned NOT NULL,
  `user_voter_id` int(11) unsigned NOT NULL,
  `answer` tinyint(4) NOT NULL,
  UNIQUE KEY `topic_id_user_id` (`topic_id`,`user_voter_id`),
  KEY `user_voter_id` (`user_voter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_topic_question_vote`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_topic_read`
--

CREATE TABLE IF NOT EXISTS `prefix_topic_read` (
  `topic_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `date_read` datetime NOT NULL,
  `comment_count_last` int(10) unsigned NOT NULL DEFAULT '0',
  `comment_id_last` int(11) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `topic_id_user_id` (`topic_id`,`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_topic_read`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_topic_tag`
--

CREATE TABLE IF NOT EXISTS `prefix_topic_tag` (
  `topic_tag_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `blog_id` int(11) unsigned NOT NULL,
  `topic_tag_text` varchar(50) NOT NULL,
  PRIMARY KEY (`topic_tag_id`),
  KEY `topic_id` (`topic_id`),
  KEY `user_id` (`user_id`),
  KEY `blog_id` (`blog_id`),
  KEY `topic_tag_text` (`topic_tag_text`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_topic_tag`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_user`
--

CREATE TABLE IF NOT EXISTS `prefix_user` (
  `user_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(30) NOT NULL,
  `user_password` varchar(100) NOT NULL,
  `user_mail` varchar(50) NOT NULL,
  `user_skill` float(9,3) unsigned NOT NULL DEFAULT '0.000',
  `user_date_register` datetime NOT NULL,
  `user_date_activate` datetime DEFAULT NULL,
  `user_date_comment_last` datetime DEFAULT NULL,
  `user_last_session` varchar(50) default NULL,
  `user_ip_register` varchar(40) NOT NULL,
  `user_rating` float(9,3) NOT NULL DEFAULT '0.000',
  `user_count_vote` int(11) unsigned NOT NULL DEFAULT '0',
  `user_activate` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `user_activate_key` varchar(32) DEFAULT NULL,
  `user_profile_name` varchar(50) DEFAULT NULL,
  `user_profile_sex` enum('man','woman','other') NOT NULL DEFAULT 'other',
  `user_profile_country` varchar(30) DEFAULT NULL,
  `user_profile_region` varchar(30) DEFAULT NULL,
  `user_profile_city` varchar(30) DEFAULT NULL,
  `user_profile_birthday` datetime DEFAULT NULL,
  `user_profile_about` text,
  `user_profile_date` datetime DEFAULT NULL,
  `user_profile_avatar` varchar(250) DEFAULT NULL,
  `user_profile_foto` varchar(250) DEFAULT NULL,
  `user_settings_notice_new_topic` tinyint(1) NOT NULL DEFAULT '1',
  `user_settings_notice_new_comment` tinyint(1) NOT NULL DEFAULT '1',
  `user_settings_notice_new_talk` tinyint(1) NOT NULL DEFAULT '1',
  `user_settings_notice_reply_comment` tinyint(1) NOT NULL DEFAULT '1',
  `user_settings_notice_new_friend` tinyint(1) NOT NULL DEFAULT '1',
  `user_settings_timezone` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_login` (`user_login`),
  UNIQUE KEY `user_mail` (`user_mail`),
  KEY `user_activate_key` (`user_activate_key`),
  KEY `user_activate` (`user_activate`),
  KEY `user_rating` (`user_rating`),
  KEY `user_profile_sex` (`user_profile_sex`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `prefix_user`
--

INSERT INTO `prefix_user` (`user_id`, `user_login`, `user_password`, `user_mail`, `user_skill`, `user_date_register`, `user_date_activate`, `user_date_comment_last`, `user_ip_register`, `user_rating`, `user_count_vote`, `user_activate`, `user_activate_key`, `user_profile_name`, `user_profile_sex`, `user_profile_country`, `user_profile_region`, `user_profile_city`, `user_profile_birthday`, `user_profile_about`, `user_profile_date`, `user_profile_avatar`, `user_profile_foto`, `user_settings_notice_new_topic`, `user_settings_notice_new_comment`, `user_settings_notice_new_talk`, `user_settings_notice_reply_comment`, `user_settings_notice_new_friend`, `user_settings_timezone`) VALUES
(1, 'admin', '21232f297a57a5a743894a0e4a801fc3', 'admin@admin.adm', 0.000, NOW(), NULL, NULL, '127.0.0.1', 0.000, 0, 1, NULL, NULL, 'other', NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, 1, 1, 1, 1, 1, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_userfeed_subscribe`
--

CREATE TABLE IF NOT EXISTS `prefix_userfeed_subscribe` (
  `user_id` int(11) unsigned NOT NULL,
  `subscribe_type` tinyint(4) NOT NULL,
  `target_id` int(11) unsigned NOT NULL,
  KEY `user_id` (`user_id`,`subscribe_type`,`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_userfeed_subscribe`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_user_administrator`
--

CREATE TABLE IF NOT EXISTS `prefix_user_administrator` (
  `user_id` int(11) unsigned NOT NULL,
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_user_administrator`
--

INSERT INTO `prefix_user_administrator` (`user_id`) VALUES
(1);

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_user_changemail`
--

CREATE TABLE IF NOT EXISTS `prefix_user_changemail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `date_add` datetime NOT NULL,
  `date_used` datetime DEFAULT NULL,
  `date_expired` datetime NOT NULL,
  `mail_from` varchar(50) NOT NULL,
  `mail_to` varchar(50) NOT NULL,
  `code_from` varchar(32) NOT NULL,
  `code_to` varchar(32) NOT NULL,
  `confirm_from` tinyint(1) NOT NULL DEFAULT '0',
  `confirm_to` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `code_from` (`code_from`),
  KEY `code_to` (`code_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_user_changemail`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_user_field`
--

CREATE TABLE IF NOT EXISTS `prefix_user_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `pattern` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `type` (`type`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

--
-- Дамп данных таблицы `prefix_user_field`
--

INSERT INTO `prefix_user_field` (`id`, `type`, `name`, `title`, `pattern`) VALUES
(1, 'contact', 'phone', 'Телефон', ''),
(2, 'contact', 'mail', 'E-mail', '<a href="mailto:{*}" rel="nofollow">{*}</a>'),
(3, 'contact', 'skype', 'Skype', '<a href="skype:{*}" rel="nofollow">{*}</a>'),
(4, 'contact', 'icq', 'ICQ', '<a href="http://www.icq.com/people/about_me.php?uin={*}" rel="nofollow">{*}</a>'),
(5, 'contact', 'www', 'Сайт', '<a href="http://{*}" rel="nofollow">{*}</a>'),
(6, 'social', 'twitter', 'Twitter', '<a href="http://twitter.com/{*}/" rel="nofollow">{*}</a>'),
(7, 'social', 'facebook', 'Facebook', '<a href="http://facebook.com/{*}" rel="nofollow">{*}</a>'),
(8, 'social', 'vkontakte', 'ВКонтакте', '<a href="http://vk.com/{*}" rel="nofollow">{*}</a>'),
(9, 'social', 'odnoklassniki', 'Одноклассники', '<a href="http://www.odnoklassniki.ru/profile/{*}/" rel="nofollow">{*}</a>');

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_user_field_value`
--

CREATE TABLE IF NOT EXISTS `prefix_user_field_value` (
  `user_id` int(11) unsigned NOT NULL,
  `field_id` int(11) unsigned DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  KEY `user_id` (`user_id`,`field_id`),
  KEY `field_id` (`field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `prefix_user_field_value`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_user_note`
--

CREATE TABLE IF NOT EXISTS `prefix_user_note` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `target_user_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `text` text NOT NULL,
  `date_add` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `target_user_id` (`target_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_user_note`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_vote`
--

CREATE TABLE IF NOT EXISTS `prefix_vote` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `target_id` int(11) unsigned NOT NULL DEFAULT '0',
  `target_type` varchar(30) NOT NULL DEFAULT 'topic',
  `user_voter_id` int(11) unsigned NOT NULL,
  `vote_direction` tinyint(2) DEFAULT '0',
  `vote_value` float(9,3) NOT NULL DEFAULT '0.000',
  `vote_date` datetime NOT NULL,
  `vote_ip` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `target_id_type` (`target_id`,`target_type`),
  KEY `user_voter_id` (`user_voter_id`),
  KEY `vote_ip` (`vote_ip`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Дамп данных таблицы `prefix_vote`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_wall`
--

CREATE TABLE IF NOT EXISTS `prefix_wall` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `wall_user_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `count_reply` int(11) NOT NULL DEFAULT '0',
  `last_reply` varchar(100) NOT NULL,
  `date_add` datetime NOT NULL,
  `ip` varchar(40) NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `wall_user_id` (`wall_user_id`),
  KEY `ip` (`ip`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `prefix_wall`
--


-- --------------------------------------------------------

--
-- Структура таблицы `prefix_page`
--

CREATE TABLE IF NOT EXISTS `prefix_page` (
  `page_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `page_pid` int(11) unsigned DEFAULT NULL,
  `page_url` varchar(50) NOT NULL,
  `page_url_full` varchar(254) NOT NULL,
  `page_title` varchar(200) NOT NULL,
  `page_text` text NOT NULL,
  `page_date_add` datetime NOT NULL,
  `page_date_edit` datetime DEFAULT NULL,
  `page_seo_keywords` varchar(250) DEFAULT NULL,
  `page_seo_description` varchar(250) DEFAULT NULL,
  `page_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `page_main` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `page_sort` int(11) NOT NULL,
  `page_auto_br` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`page_id`),
  KEY `page_pid` (`page_pid`),
  KEY `page_url_full` (`page_url_full`,`page_active`),
  KEY `page_title` (`page_title`),
  KEY `page_sort` (`page_sort`),
  KEY `page_main` (`page_main`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;


INSERT INTO `prefix_page` (`page_id`, `page_pid`, `page_url`, `page_url_full`, `page_title`, `page_text`, `page_date_add`, `page_date_edit`, `page_seo_keywords`, `page_seo_description`, `page_active`, `page_main`, `page_sort`, `page_auto_br`) VALUES
(1, NULL, 'about', 'about', 'about', 'edit this page http://yousite/page/admin/', '2010-06-06 02:29:28', NULL, '', '', 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_adminban`
--

CREATE TABLE  IF NOT EXISTS `prefix_adminban` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `banwarn` int(11) NOT NULL default '0',
  `bandate` datetime NOT NULL,
  `banline` datetime default NULL,
  `bancomment` varchar(255) default NULL,
  `banunlim` tinyint(4) NOT NULL default '0',
  `banactive` TINYINT DEFAULT '0' NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_adminips`
--

CREATE TABLE IF NOT EXISTS `prefix_adminips` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `ip1` bigint(20) default '0',
  `ip2` bigint(20) default '0',
  `bandate` datetime NOT NULL,
  `banline` datetime default NULL,
  `bancomment` varchar(255) default NULL,
  `banunlim` tinyint(4) NOT NULL default '0',
  `banactive` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `ip1` (`ip1`),
  KEY `ip2` (`ip2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_content`
--

CREATE TABLE IF NOT EXISTS `prefix_content` (
  `content_id` int(11) unsigned NOT NULL AUTO_INCREMENT ,
  `content_title` varchar(200) NOT NULL,
  `content_title_decl` varchar(200) NOT NULL,
  `content_sort` int(11) NOT NULL DEFAULT '0',
  `content_url` varchar(50) NOT NULL,
  `content_active` tinyint(1) NOT NULL DEFAULT '1',
  `content_candelete` tinyint(1) NOT NULL DEFAULT '0',
  `content_cancreate` tinyint(1) NOT NULL DEFAULT '0',
  `content_access` tinyint(1) NOT NULL DEFAULT '1',
  `content_config` text DEFAULT NULL,
  PRIMARY KEY (`content_id`),
  KEY ( `content_url` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `prefix_content` (`content_id`, `content_title`, `content_title_decl`, `content_sort`, `content_url`, `content_active`, `content_candelete`, `content_config`) VALUES
(1, 'Топик','Топики','1',  'topic', '1', '0', 'a:3:{s:8:"photoset";i:1;s:8:"question";i:1;s:4:"link";i:1;}');

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_content_field`
--

CREATE TABLE IF NOT EXISTS `prefix_content_field` (
  `field_id` int(11) unsigned NOT NULL AUTO_INCREMENT ,
  `content_id` int(11) unsigned NOT NULL,
  `field_sort` int(11) NOT NULL DEFAULT '0',
  `field_type` varchar(30) NOT NULL DEFAULT 'input',
  `field_name` varchar(50) NOT NULL,
  `field_description` varchar(200) NOT NULL,
  `field_options` text DEFAULT NULL ,
  `field_required` tinyint(1) NOT NULL DEFAULT '0',
  `field_postfix` text DEFAULT NULL,
  PRIMARY KEY ( `field_id` ),
  KEY ( `content_id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_content_values`
--

CREATE TABLE IF NOT EXISTS `prefix_content_values` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `target_type` varchar(40) NOT NULL DEFAULT 'topic',
  `target_id` int(11) unsigned DEFAULT NULL,
  `field_id` int(11) unsigned NOT NULL,
  `field_type` varchar(40) NOT NULL DEFAULT 'input',
  `value_type` enum('string','text','number') NOT NULL,
  `value` text DEFAULT NULL,
  `value_varchar` varchar(250) DEFAULT NULL,
  `value_source` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `target_type` (`target_type`),
  KEY `target_id` (`target_id`),
  KEY `value_type` (`value_type`),
  KEY `field_id` (`field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_track`
--

CREATE TABLE IF NOT EXISTS `prefix_track` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `target_type` varchar(20) NOT NULL,
  `target_id` int(11) unsigned DEFAULT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `date_add` datetime NOT NULL,
  `date_remove` datetime DEFAULT NULL,
  `ip` varchar(20) NOT NULL,
  `key` varchar(32) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `type` (`target_type`),
  KEY `user_id` (`user_id`),
  KEY `status` (`status`),
  KEY `key` (`key`),
  KEY `target_id` (`target_id`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `prefix_storage`
--

CREATE TABLE IF NOT EXISTS `prefix_storage` (
  `storage_key` VARCHAR( 100 ) NOT NULL ,
  `storage_val` VARCHAR( 255 ) NULL ,
PRIMARY KEY ( `storage_key` )
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `prefix_blog`
--
ALTER TABLE `prefix_blog`
  ADD CONSTRAINT `prefix_blog_fk` FOREIGN KEY (`user_owner_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_blog_user`
--
ALTER TABLE `prefix_blog_user`
  ADD CONSTRAINT `prefix_blog_user_fk` FOREIGN KEY (`blog_id`) REFERENCES `prefix_blog` (`blog_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_blog_user_fk1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_comment`
--
ALTER TABLE `prefix_comment`
  ADD CONSTRAINT `prefix_topic_comment_fk` FOREIGN KEY (`comment_pid`) REFERENCES `prefix_comment` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `topic_comment_fk1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_comment_online`
--
ALTER TABLE `prefix_comment_online`
  ADD CONSTRAINT `prefix_topic_comment_online_fk1` FOREIGN KEY (`comment_id`) REFERENCES `prefix_comment` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_favourite`
--
ALTER TABLE `prefix_favourite`
  ADD CONSTRAINT `prefix_favourite_target_fk` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_favourite_tag`
--
ALTER TABLE `prefix_favourite_tag`
  ADD CONSTRAINT `prefix_favourite_tag_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_friend`
--
ALTER TABLE `prefix_friend`
  ADD CONSTRAINT `prefix_friend_from_fk` FOREIGN KEY (`user_from`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_friend_to_fk` FOREIGN KEY (`user_to`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_invite`
--
ALTER TABLE `prefix_invite`
  ADD CONSTRAINT `prefix_invite_fk` FOREIGN KEY (`user_from_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_invite_fk1` FOREIGN KEY (`user_to_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_reminder`
--
ALTER TABLE `prefix_reminder`
  ADD CONSTRAINT `prefix_reminder_fk` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_session`
--
ALTER TABLE `prefix_session`
  ADD CONSTRAINT `prefix_session_fk` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_stream_event`
--
ALTER TABLE `prefix_stream_event`
  ADD CONSTRAINT `prefix_stream_event_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_stream_subscribe`
--
ALTER TABLE `prefix_stream_subscribe`
  ADD CONSTRAINT `prefix_stream_subscribe_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_stream_user_type`
--
ALTER TABLE `prefix_stream_user_type`
  ADD CONSTRAINT `prefix_stream_user_type_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_talk`
--
ALTER TABLE `prefix_talk`
  ADD CONSTRAINT `prefix_talk_fk` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_talk_blacklist`
--
ALTER TABLE `prefix_talk_blacklist`
  ADD CONSTRAINT `prefix_talk_blacklist_fk_target` FOREIGN KEY (`user_target_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_talk_blacklist_fk_user` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_talk_user`
--
ALTER TABLE `prefix_talk_user`
  ADD CONSTRAINT `prefix_talk_user_fk` FOREIGN KEY (`talk_id`) REFERENCES `prefix_talk` (`talk_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_talk_user_fk1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_topic`
--
ALTER TABLE `prefix_topic`
  ADD CONSTRAINT `prefix_topic_fk` FOREIGN KEY (`blog_id`) REFERENCES `prefix_blog` (`blog_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_topic_fk1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_topic_content`
--
ALTER TABLE `prefix_topic_content`
  ADD CONSTRAINT `prefix_topic_content_fk` FOREIGN KEY (`topic_id`) REFERENCES `prefix_topic` (`topic_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_topic_photo`
--
ALTER TABLE `prefix_topic_photo`
  ADD CONSTRAINT `prefix_topic_photo_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `prefix_topic` (`topic_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_topic_question_vote`
--
ALTER TABLE `prefix_topic_question_vote`
  ADD CONSTRAINT `prefix_topic_question_vote_fk` FOREIGN KEY (`topic_id`) REFERENCES `prefix_topic` (`topic_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_topic_question_vote_fk1` FOREIGN KEY (`user_voter_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_topic_read`
--
ALTER TABLE `prefix_topic_read`
  ADD CONSTRAINT `prefix_topic_read_fk` FOREIGN KEY (`topic_id`) REFERENCES `prefix_topic` (`topic_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_topic_read_fk1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_topic_tag`
--
ALTER TABLE `prefix_topic_tag`
  ADD CONSTRAINT `prefix_topic_tag_fk` FOREIGN KEY (`topic_id`) REFERENCES `prefix_topic` (`topic_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_topic_tag_fk1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_topic_tag_fk2` FOREIGN KEY (`blog_id`) REFERENCES `prefix_blog` (`blog_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_userfeed_subscribe`
--
ALTER TABLE `prefix_userfeed_subscribe`
  ADD CONSTRAINT `prefix_userfeed_subscribe_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_user_administrator`
--
ALTER TABLE `prefix_user_administrator`
  ADD CONSTRAINT `user_administrator_fk` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_user_changemail`
--
ALTER TABLE `prefix_user_changemail`
  ADD CONSTRAINT `prefix_user_changemail_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_user_field_value`
--
ALTER TABLE `prefix_user_field_value`
  ADD CONSTRAINT `prefix_user_field_value_ibfk_2` FOREIGN KEY (`field_id`) REFERENCES `prefix_user_field` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_user_field_value_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_user_note`
--
ALTER TABLE `prefix_user_note`
  ADD CONSTRAINT `prefix_user_note_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_user_note_ibfk_1` FOREIGN KEY (`target_user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_vote`
--
ALTER TABLE `prefix_vote`
  ADD CONSTRAINT `prefix_topic_vote_fk1` FOREIGN KEY (`user_voter_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prefix_wall`
--
ALTER TABLE `prefix_wall`
  ADD CONSTRAINT `prefix_wall_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prefix_wall_ibfk_1` FOREIGN KEY (`wall_user_id`) REFERENCES `prefix_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
