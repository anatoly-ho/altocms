 {* Тема оформления Experience v.1.0  для Alto CMS      *}
 {* @licence     CC Attribution-ShareAlike   *}

<div class="topic-url">
    <p><b>{$aLang.topic_link_create_url}:</b>
        <a href="{router page='content'}go/{$oTopic->getId()}/"
           title="{$aLang.topic_link_count_jump}: {$oTopic->getLinkCountJump()}">{$oTopic->getLinkUrl()}</a>
        <span class="small muted">, {$oTopic->getLinkCountJump()} {$oTopic->getLinkCountJump()|declension:$aLang.link_jump_declesion:$sLang}</span>
    </p>
</div>
